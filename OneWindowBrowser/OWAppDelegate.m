//
//  OWAppDelegate.m
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import "OWAppDelegate.h"
#import "OWWindowHelper.h"
#import "OWBrowserController.h"
#import <WebKit/WebKit.h>

@implementation OWAppDelegate

- (void) awakeFromNib
{
	[self loadPreferences];
	
} //awakeFromNib


- (BOOL) applicationShouldTerminate:(id)sender
{
	//ask the window to close. This will in turn save the user settings.
	[window performClose:self];
	
	return NSTerminateNow; //goodbye

} //applicationShouldTerminate:


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES; //if the window closes, quit the app
	
} //applicationShouldTerminateAfterLastWindowClosed:


- (NSWindow *) window
{
	return window;
	
} //window


- (NSMenuItem *) fadeIn
{
    return fadeIn;
    
} //fadeIn


- (NSMenuItem *) fadeOut
{
    return fadeOut;
    
} //fadeOut


- (OWBrowserController *) browserController
{	
	return browserController;

} //browserController


- (void) performFadeIn: (id) sender
{
    if([[self window] alphaValue] < kFadeMax)
        [[self window] setAlphaValue:[[self window] alphaValue] + kFadeStep];
	else
		[[self window] setAlphaValue:kFadeMax];

} //performFadeIn


- (void) performFadeOut: (id) sender
{
    if([[self window] alphaValue] > kFadeMin + kFadeStep)
        [[self window] setAlphaValue:[[self window] alphaValue] - kFadeStep];
	else
		[[self window] setAlphaValue:kFadeMin];

} //performFadeOut:



- (void) loadPreferences
{
	//load the window's size and position from the auto-save
	[[self window] setFrameAutosaveName:@"OneWindowBrowser"];
	
    //load window alpha value
    if([[NSUserDefaults standardUserDefaults] floatForKey:@"windowAlpha"])
        [[self window] setAlphaValue:
			[[NSUserDefaults standardUserDefaults] floatForKey:@"windowAlpha"]];

    //load in landing page options
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"landingPageLastViewed"] == YES) {
		[[[self browserController] address] setStringValue:
			[[NSUserDefaults standardUserDefaults] objectForKey:@"addressURL"]]; //last viewed page on quit
	} else {
		
		//read the custom set default landing page user defaults if exists (browserController)
		if([[NSUserDefaults standardUserDefaults] objectForKey:@"landingPageURL"]) {
			[[[self browserController] address] setStringValue:
				[[NSUserDefaults standardUserDefaults] objectForKey:@"landingPageURL"]];
		} else {
			[[[self browserController] address] setStringValue:kBrowserDefaultLandingURL]; //otherwise load default

			//assign the default to the user prefs
			[[NSUserDefaults standardUserDefaults] setValue:kBrowserDefaultLandingURL
													 forKey:@"landingPageURL"];
		}
	}
	
	//apply default option for landingPageLastViewed if not already set
	//(performed after the first test, which would allow the default page to load if key is not set)
	if([[NSUserDefaults standardUserDefaults] valueForKey:@"landingPageLastViewed"] == nil)
		[[NSUserDefaults standardUserDefaults] setBool:	klandingPageLastViewed
												forKey:@"landingPageLastViewed"];
	
	//read the stored textSizeMultiplier (browserController)
	if([[NSUserDefaults standardUserDefaults] floatForKey:@"textSize"]) {
		[[[self browserController] myWebView] setTextSizeMultiplier:
			[[NSUserDefaults standardUserDefaults] floatForKey:@"textSize"]];
	}
	
	//restore the browser histroy (browserController)
	NSArray *historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"browserHistory"];
	
	NSEnumerator *historyEnumerator = [historyArray objectEnumerator];
	NSDictionary *historyItem;
	while(historyItem = [historyEnumerator nextObject]) {
		[[self browserController] addToHistory:[historyItem objectForKey:@"title"]
									   withURL:[NSURL URLWithString:[historyItem objectForKey:@"url"]]];
	}
	
	//set the UserAgent from preferences, or use the default user agent string
	NSString *userAgentString = kDefaultUserAgentString;
	if([[NSUserDefaults standardUserDefaults] stringForKey:@"userAgentString"])
		userAgentString = [[NSUserDefaults standardUserDefaults] stringForKey:@"userAgentString"];
	
	[[[self browserController] myWebView] setCustomUserAgent:userAgentString];
	
	//load the last address on first load
	[[[self browserController] myWebView] takeStringURLFrom:[[self browserController] address]];
	
	//restore javascript option
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"JavascriptDisabled"] == YES)
		[[self browserController] performDisableJavascriptOption:self];
		
} //loadPreferences


- (void) savePreferences
{
	//landingPageLastViewed (BOOL) and landingPageURL (NSString *) are saved/stored when selected from the menu
	
	
	//persist last address URL and text size, stored in user defaults (Preferences)
	NSString *addressURL = [[[self browserController] address] stringValue];
	[[NSUserDefaults standardUserDefaults] setValue:addressURL forKey:@"addressURL"];
		
	float textSize = [[[self browserController] myWebView] textSizeMultiplier];
	[[NSUserDefaults standardUserDefaults] setFloat:textSize forKey:@"textSize"];
	
	//save the window alpha to the user defaults
	[[NSUserDefaults standardUserDefaults] setFloat:[[self window] alphaValue]
											 forKey:@"windowAlpha"];
	
	//store the history as a dictionary
	NSMutableArray *historyArray = [[NSMutableArray alloc] initWithCapacity:[[[self browserController] historyURLs] count]];
	NSEnumerator *historyMenuEnumerator = [[[[self browserController] historyMenu] itemArray] objectEnumerator];
	NSMenuItem *thisMenuItem;
	while(thisMenuItem = [historyMenuEnumerator nextObject]) {
		if([thisMenuItem action] == @selector(performHistoryMenuItem:)) {
			NSString *historyTitle = [thisMenuItem title];
			NSString *historyURLString = [[[[self browserController] historyURLs] objectAtIndex:[thisMenuItem tag]] absoluteString];
			
			NSDictionary *thisHistoryItem = [NSDictionary dictionaryWithObjectsAndKeys:
				historyTitle, @"title", historyURLString, @"url", nil];
			
			[historyArray addObject:thisHistoryItem];
		}
	}
	
	//write the history array to the user defaults
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:historyArray]
											  forKey:@"browserHistory"];	

	//release the newly created array
	[historyArray release];
	
	//save the current user agent string
	[[NSUserDefaults standardUserDefaults] setValue:[[[self browserController] myWebView] customUserAgent]
											  forKey:@"userAgentString"];

	//save the javascript option
	[[NSUserDefaults standardUserDefaults] setBool:![[[[self browserController] myWebView] preferences] isJavaScriptEnabled]
											forKey:@"JavascriptDisabled"];
	
} //savePreferences


#pragma mark Menu Item Validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	//disable Fade In/Out items if we're already at min or max
	if([menuItem action] == @selector(performFadeIn:)) {
		if([[self window] alphaValue] >= kFadeMax)
			return NO;
	}
	
	if([menuItem action] == @selector(performFadeOut:)) {
		if([[self window] alphaValue] <= kFadeMin)
			return NO;
	}
	
	return YES;
	
}  //validateMenuItem:

@end
