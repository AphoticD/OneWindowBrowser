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

#define kFadeMin 0.2
#define kFadeMax 1.0
#define kFadeStep 0.15

@implementation AppDelegate

- (void) awakeFromNib
{
	//load the window's size and position from the auto-save
	[[self window] setFrameAutosaveName:@"OneWindowBrowser"];
	
    //load window alpha value
    if([[NSUserDefaults standardUserDefaults] floatForKey:@"windowAlpha"])
        [[self window] setAlphaValue:
         [[NSUserDefaults standardUserDefaults] floatForKey:@"windowAlpha"]];
    
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
     


@end
