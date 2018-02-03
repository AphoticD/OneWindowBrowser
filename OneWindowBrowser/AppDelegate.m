//
//  AppDelegate.m
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2017 Aphotic. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowHelper.h"
#import "BrowserController.h"
#import <WebKit/WebKit.h>

@implementation AppDelegate

- (void) awakeFromNib
{
	//load the window's size and position from the auto-save
	[[self window] setFrameAutosaveName:@"OneWindowBrowser"];
	
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


@end
