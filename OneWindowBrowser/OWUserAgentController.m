//
//  OWUserAgentController.m
//  OneWindowBrowser XcodeV2.5
//
//  Created by Daniel Brunet on 6/02/18.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import "OWUserAgentController.h"
#import "OWBrowserController.h"
#import "OWAppDelegate.h"
#import <WebKit/WebKit.h>

@implementation OWUserAgentController

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
	
	[[self textField] setStringValue:[[[self browserController] myWebView] customUserAgent]];
	
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
	//send the custom user agent to the web view
	[[[self browserController] myWebView] setCustomUserAgent:[[self textField] stringValue]];
	
	//close the window
	[[self window] close];

} //performOK:


- (IBAction) performUseDefault: (id) sender
{
	//send the custom user agent to the web view
	[[[self browserController] myWebView] setCustomUserAgent:kDefaultUserAgentString];
	
	//close the window
	[[self window] close];
	
} //performUseDefault:

@end
