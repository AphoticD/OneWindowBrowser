//
//  OWWindowHelper.m
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 22/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import "OWWindowHelper.h"
#import "OWBrowserController.h"
#import "OWAppDelegate.h"

@implementation OWWindowHelper

- (BOOL) windowShouldClose: (id) sender
{	
	//save the preferences
	[(OWAppDelegate *)[NSApp delegate] savePreferences];
	
	return YES; //close the window
	
} //windowShouldClose:


- (OWBrowserController *) browserController
{
	return browserController;

} //browserController


- (NSWindow *) window
{
    return window;

} //window

@end
