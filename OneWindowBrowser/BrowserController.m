//
//  BrowserController.m
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2017 Aphotic. All rights reserved.
//

#import "BrowserController.h"
#import <WebKit/WebKit.h>

@implementation BrowserController

- (void) dealloc
{
	[address release];
	[backButton release];
	[forwardButton release];
	[myWebView release];
	[myProgress release];
	[historyMenu release];
	[stopButton release];
	[reloadButton release];
	[historyURLs release];
    
	[super dealloc];

} //dealloc


- (void) resetButtons
{
	[[self backButton] setEnabled:[[self myWebView] canGoBack]];
	[[self forwardButton] setEnabled:[[self myWebView] canGoForward]];

} //resetButtons


- (void)awakeFromNib
{
	//initialize the historyURLs array
	historyURLs = [[NSMutableArray alloc] initWithCapacity:13];
	
	//read last web address URL from the user defaults if exists
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"addressURL"]) {
		[[self address] setStringValue:
		 [[NSUserDefaults standardUserDefaults] objectForKey:@"addressURL"]];
	} else {
		[[self address] setStringValue:@"http://localhost/"];
	}

	//read the stored textSizeMultiplier
	if([[NSUserDefaults standardUserDefaults] floatForKey:@"textSize"]) {
		[[self myWebView] setTextSizeMultiplier:
		 [[NSUserDefaults standardUserDefaults] floatForKey:@"textSize"]];
	}
	
	//set the UserAgent to iPad OS 3.2.2
	[[self myWebView] setCustomUserAgent:@"Mozilla/5.0 (iPad; U; CPU OS 3_2_2 like Mac OS X; en-us)" \
			"AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B500 Safari/531.21.10"];
	
	//load the last address on first load
	[[self myWebView] takeStringURLFrom:[self address]];

} //awakeFromNib


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
	
} //webView:didFinishLoadForFrame


- (void)webView:(WebView *)sender
			didStartProvisionalLoadForFrame:(WebFrame *)frame
{
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


- (NSButton *) stopButton
{
	return stopButton;

} //stopButton


- (NSButton *) reloadButton
{
	return reloadButton;

} //reloadButton


- (NSMutableArray *) historyURLs
{
	return historyURLs;
	
} //history

@end
