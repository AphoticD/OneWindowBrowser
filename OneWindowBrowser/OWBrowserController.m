//
//  OWBrowserController.m
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import "OWBrowserController.h"
#import "OWAppDelegate.h"
#import "OWUserAgentController.h"
#import "OWLandingPageController.h"
#import <WebKit/WebKit.h>


@implementation OWBrowserController

- (void) dealloc
{
	[historyURLs release];
    [userAgentController release];
	[landingPageController release];
	
	[super dealloc];

} //dealloc


- (void) resetButtons
{
	[[self backButton] setEnabled:[[self myWebView] canGoBack]];
	[[self forwardButton] setEnabled:[[self myWebView] canGoForward]];
	[[self stopButton] setEnabled:[[[[self myWebView] mainFrame] dataSource] isLoading]];

} //resetButtons


- (void)webView:(WebView *)sender
didReceiveTitle:(NSString *)title
	   forFrame:(WebFrame *)frame
{
	//set the window title to the provided web page title
	[[sender window] setTitle:title];

	//add this request to the historyURLs array and populate the History menu
	[self addToHistory: title
			   withURL: [[[frame dataSource] request] URL]];
	
} //webView:didReceiveTitle


- (void)webView:(WebView *)sender
			didFinishLoadForFrame:(WebFrame *)frame
{
	//updat the address field when the page has finished loading
	[[self address] setStringValue:[[[[[sender mainFrame] dataSource] request] URL] absoluteString]];
	
	//reset the GUI buttons
	[self resetButtons];
	
	//stop the spinning progress indicator
	[[self myProgress] stopAnimation:self];
	
	//[[self myProgress] setHidden:YES];
	
} //webView:didFinishLoadForFrame


- (void)webView:(WebView *)sender
			didStartProvisionalLoadForFrame:(WebFrame *)frame
{
	//[[self myProgress] setHidden:NO];
	
	//start the spinning address indicator when a load begins
	[[self myProgress] startAnimation:self];

	//reset the GUI buttons
	[self resetButtons];

} //webView:didStartProvisionalLoadForFrame


- (IBAction) enterAddress:(id) sender
{
	//gather the address string
    NSString *addressURL = [[self address] stringValue];
    
	//prefix with http:// if a standard http,https or file prefix was not supplied
	//all other prefixes will be made unavailable for loading (slightly more secure this way?)
    if([addressURL hasPrefix:@"http://"] == NO &&
       [addressURL hasPrefix:@"https://"] == NO &&
       [addressURL hasPrefix:@"file://"] == NO)
        addressURL = [@"http://" stringByAppendingString:addressURL];
    
	//send the address to the webView to load
	[[[self myWebView] mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:addressURL]]];
	
} //enterAddress:


- (void) addToHistory: (NSString *) titleToAdd
			  withURL: (NSURL *) urlToAdd
{
	//initialize the historyURLs array if not yet set
	if(historyURLs == nil)
		historyURLs = [[NSMutableArray alloc] initWithCapacity:13];
	
	//check if the URL exists in the history, if so, delete it, then reinsert at the top of the menu (+URL array)
	if([historyURLs containsObject:urlToAdd]) {
		int indexToRemove = [historyURLs indexOfObject:urlToAdd];
		[historyMenu removeItemAtIndex:indexToRemove];
		[historyURLs removeObjectAtIndex:indexToRemove];
	}
	
	//instantiate the new menu item with the title and standard action
	NSMenuItem *itemToAdd = [[NSMenuItem alloc] initWithTitle:titleToAdd
													   action:@selector(performHistoryMenuItem:)
												keyEquivalent:@""];
	//target self
	[itemToAdd setTarget:self];
	
	//insert the URL into the top of the mutable array
	[[self historyURLs] insertObject:urlToAdd
						 atIndex:0];
	
	//insert the menu item into the top of the history menu
	[[self historyMenu] insertItem:itemToAdd
						   atIndex:0];
	
	//release the item (now retained by the historyURLs array)
	[itemToAdd release];
	
	//enumerate the historyURLs array and update the history menu tags.
	//the tags will be used as a reference in the array for loading URLs from the menu items
	//i.e. each menu item's tag corresponds to the index of an URL in the historyURLs array.
	
	int i;
	for(i = 0; i < [[self historyURLs] count]; i++) {
	
		//check that the menu item exists;
		if([[[self historyMenu] itemArray] objectAtIndex:i] != nil) {
			
			//set the tag of the item in the menu to i
			[[[[self historyMenu] itemArray] objectAtIndex:i] setTag:i];
		}
	}
	
	//limit to kBrowserHistoryLimit number of history menu items
	if([historyURLs count] > kBrowserHistoryLimit) {
		unsigned int lastItemIndex = [historyURLs count] - 1;
		
		[historyMenu removeItem:[historyMenu itemWithTag:(int)lastItemIndex]];
		[historyURLs removeObjectAtIndex:lastItemIndex];
	}
														
} //addToHistory:withURL:


- (void) performHistoryMenuItem: (id) sender
{
	//pull the URL from the historyURLs array using the tag of the sender as an index
	NSURL *selectedURL = [historyURLs objectAtIndex:[sender tag]];
	
	//insert the URL from the historyURLs array at the index associated with the sender's tag into the address field
	[[self address] setStringValue:[selectedURL absoluteString]];
	
	//simulate hitting Enter.
	[self enterAddress:[self address]];
	
} //performHistoryMenuItem


- (void) performClearHistory: (id) sender
{
    //display an alert confirmation dialog
    
#if !MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_2
	NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Are you sure you want to clear history?"];
    [alert setInformativeText:@"You can't undo this action."];
    [alert addButtonWithTitle:@"Clear"];
	[alert addButtonWithTitle:@"Cancel"];
    [alert setAlertStyle:NSWarningAlertStyle];
    int returnValue = [alert runModal];
    [alert release];
	
	if(returnValue != NSAlertFirstButtonReturn)
		return;
#else
    //Jaguar alert method
    if(NSRunAlertPanel(@"Are you sure you want to clear history?",
                       @"You can't undo this action.",
                       @"Clear",
                       @"Cancel", nil) != NSAlertDefaultReturn)
        return;
    
#endif
    
	//save the current page for reinserting into the cleared history
	NSString *currentTitle = [[historyMenu itemAtIndex:0] title];
	NSURL *currentURL = [historyURLs objectAtIndex:0];

	//iterate the menu, removing all items which trigger the performHistoryMenuItem: selector
	NSEnumerator *historyEnumerator = [[historyMenu itemArray] objectEnumerator];
	NSMenuItem *thisMenuItem;
	while(thisMenuItem = [historyEnumerator nextObject]) {
		if([thisMenuItem action] == @selector(performHistoryMenuItem:))
			[historyMenu removeItem: thisMenuItem];
	}
	
	//clear the historyURLs array
	[historyURLs removeAllObjects];
	
	//reinsert the current page 
	[self addToHistory: currentTitle
			   withURL: currentURL];
		
} //performClearHistory:


- (void) performGoToLanding: (id) sender
{
	//load in the default landing page URL string
	[[self address] setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"landingPageURL"]];
	
	//simulate hitting Enter on the address field
	[self enterAddress:self];
	
} //performGoToLanding:


- (void) performDisableJavascriptOption: (id) sender
{
	//toggle the current switch for javascript enabled
	[[[self myWebView] preferences] setJavaScriptEnabled:
		![[[self myWebView] preferences] isJavaScriptEnabled]];
	
} //performDisableJavascriptOption:


- (void) performCustomUserAgentOption: (id) sender
{
	if(userAgentController == nil)
		userAgentController = [[OWUserAgentController alloc] initWithWindowNibName:@"CustomUserAgent"
																 browserController:self];
	[userAgentController showWindow:self];
	
} //performCustomUserAgentOption:


- (void) performSetLandingToLastViewed: (id) sender
{
	[[NSUserDefaults standardUserDefaults] setBool:YES
											forKey:@"landingPageLastViewed"];
	
} //performSetLandingToLastViewed


- (void) performSetLandingToCustom: (id) sender
{
	if(landingPageController == nil)
		landingPageController = [[OWLandingPageController alloc] initWithWindowNibName:@"CustomLandingURL"
																	 browserController:self];
	[landingPageController showWindow:self];
	
} //performSetLandingToCustom


#pragma mark Accessors

- (NSButton *) backButton
{
	return backButton;

} //backButton


- (NSButton *) forwardButton
{
	return forwardButton;

} //forwardButton


- (NSTextField *) address
{
	return address;
} //address


- (WebView *) myWebView
{
	return myWebView;

} //myWebView


- (NSProgressIndicator *) myProgress
{
	return myProgress;
	
} //myProgress


- (NSMenu *) historyMenu
{
	return historyMenu;

} //historyMenu


- (NSMenuItem *) clearHistory
{
	return clearHistory;

} //clearHistory


- (NSMenuItem *) goToLanding
{
	return goToLanding;

} //goToLanding


- (NSButton *) stopButton
{
	return stopButton;

} //stopButton


- (NSButton *) reloadButton
{
	return reloadButton;

} //reloadButton


- (NSMenuItem *) disableJavascriptOption
{
	return disableJavascriptOption;
	
} //disableJavascriptOption


- (NSMenuItem *) customUserAgentOption
{
	return customUserAgentOption;

} //customUserAgentOption


- (NSMenuItem *) landingLastViewed
{
	return landingLastViewed;
} //landingLastViewed


- (NSMenuItem *) landingCustom
{
	return landingCustom;
	
} //landingCustom


- (NSMutableArray *) historyURLs
{
	return historyURLs;
	
} //history


#pragma mark Menu Item Validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{	
	//mark the options menu items as set where appropriate
	if([menuItem action] == @selector(performDisableJavascriptOption:)) {
		[menuItem setState:[[[self myWebView] preferences] isJavaScriptEnabled]?
			   NSOffState : NSOnState]; //inverted; Disabled == NSOnState, Enabled == NSOffState
		return YES;
	}
	
	if([menuItem action] == @selector(performSetLandingToLastViewed:)) {
		[menuItem setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"landingPageLastViewed"]?
				NSOnState : NSOffState];
		return YES;
	}

	if([menuItem action] == @selector(performSetLandingToCustom:)) {
		[menuItem setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"landingPageLastViewed"]?
				NSOffState : NSOnState]; //inverted state
		return YES;
	}
	
	return YES;
	
}  //validateMenuItem:

@end
