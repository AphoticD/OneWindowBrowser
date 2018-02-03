//
//  WindowHelper.m
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 22/05/17.
//  Copyright 2017 Aphotic. All rights reserved.
//

#import "WindowHelper.h"
#import "BrowserController.h"
#import <WebKit/WebKit.h>

@implementation WindowHelper

- (BOOL) windowShouldClose: (id) sender
{	
	//persist last address URL and text size, stored in user defaults (Preferences)
	NSString *addressURL = [[[self browserController] address] stringValue];
	[[NSUserDefaults standardUserDefaults] setValue:addressURL forKey:@"addressURL"];
	
	float textSize = [[[self browserController] myWebView] textSizeMultiplier];
	[[NSUserDefaults standardUserDefaults] setFloat:textSize forKey:@"textSize"];
	
    float windowAlpha = [[self window] alphaValue];
    [[NSUserDefaults standardUserDefaults] setFloat:windowAlpha forKey:@"windowAlpha"];
    
	return YES; //close the window
	
} //windowShouldClose:


- (BrowserController *) browserController
{
	return browserController;

} //browserController


- (NSWindow *) window
{
    return window;

} //window

@end
