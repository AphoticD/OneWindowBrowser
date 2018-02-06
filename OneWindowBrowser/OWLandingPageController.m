//
//  OWLandingPageController.m
//  OneWindowBrowser XcodeV2.5
//
//  Created by Daniel Brunet on 6/02/18.
//  Copyright 2018 __MyCompanyName__. All rights reserved.
//

#import "OWLandingPageController.h"
#import "OWBrowserController.h"
#import "OWAppDelegate.h"
#import <WebKit/WebKit.h>


@implementation OWLandingPageController

- (id) initWithWindowNibName: (NSString *) nibName
		   browserController: (OWBrowserController *) aController
{
	if(self = [super initWithWindowNibName: nibName]) {		
		browserController = [aController retain];
	}
	
	return self;
	
} //initWithWindowNibName:browserController:


- (void) dealloc
{
	[browserController release];
	
	[super dealloc];
	
} //dealloc


- (void) showWindow:(id)sender
{
	[super showWindow:sender];

	//load in the landingPageURL from user defaults (if exists)
	NSString *landingPageURL = kBrowserDefaultLandingURL;
	if([[NSUserDefaults standardUserDefaults] valueForKey:@"landingPageURL"])
		landingPageURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"landingPageURL"];
	
	[[self textField] setStringValue:landingPageURL];
	
} //showWindow:


- (NSTextField *) textField
{
	return textField;
	
} //textField


- (NSButton *) cancelButton
{
	return cancelButton;
	
} //cancelButton


- (NSButton *) okButton
{
	return okButton;
	
} //okButton


- (NSButton *) useDefaultButton
{
	return useDefaultButton;
	
} //useDefaultButton


- (OWBrowserController *) browserController
{
	return browserController;
	
} //browserController


- (IBAction) performCancel:(id) sender
{
	//close the window
	[[self window] close];
	
} //performCancel


- (IBAction) performOK: (id) sender
{
	//store the custom landing page URL in the user defaults
	[[NSUserDefaults standardUserDefaults] setValue:[[self textField] stringValue]
											 forKey:@"landingPageURL"];

	//override the lastViewed key to flag the custom URL for use
	[[NSUserDefaults standardUserDefaults] setBool:NO
											forKey:@"landingPageLastViewed"];

	//close the window
	[[self window] close];
	
} //performOK:


- (IBAction) performUseDefault: (id) sender
{
	//store the DEFAULT landing page URL in the user defaults
	[[NSUserDefaults standardUserDefaults] setValue:kBrowserDefaultLandingURL
											 forKey:@"landingPageURL"];
	
	//override the lastViewed key to flag the custom URL for use
	[[NSUserDefaults standardUserDefaults] setBool:NO
											forKey:@"landingPageLastViewed"];
	
	//close the window
	[[self window] close];
	
} //performUseDefault:

@end
