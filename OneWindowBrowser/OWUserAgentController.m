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

- (NSWindow *) initWithPanelNibName: (NSString *) nibName
		   browserController: (OWBrowserController *) aController
{
	if(self = [super initWithWindowNibName: nibName]) {		
		browserController = [aController retain];
	}
	
	return self.window;

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


- (NSButton *) doneButton
{
	return doneButton;

} //doneButton


- (OWBrowserController *) browserController
{
	return browserController;
	
} //browserController


- (IBAction) performDone: (id) sender
{
    NSString *userAgentString = [[self textField] stringValue];
	//send the custom user agent to the web view
	[[[self browserController] myWebView] setCustomUserAgent: userAgentString];
	
    //store the custom landing page URL in the user defaults
    [[NSUserDefaults standardUserDefaults] setObject:userAgentString
                                              forKey:@"userAgentString"];
    
	//close the sheet
    [NSApp endSheet:[self window]];

} //performDone:




@end
