//
//  OWPreferencesController.m
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/6/18.
//

#import "OWBrowserController.h"
#import "OWAppDelegate.h"
#import "OWPreferencesController.h"
#import <WebKit/WebKit.h>

@implementation OWPreferencesController

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
      [super showWindow: sender];
    
    // Pre-selects dropdown if User Agent string doesn't match default
    if (![[[[self browserController] myWebView] customUserAgent] isEqualToString:kDefaultUserAgentString]) {
        [[self userAgentSelector]selectItemAtIndex: 1];
    }
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"landingPageURL"]  isEqual: kBrowserDefaultLandingURL]) {
        [[self landingPageField] setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"landingPageURL"]];
    }

    
} //showWindow:


- (BOOL) windowShouldClose: (id) sender
{
    //save the preferences
    if([[self userAgentSelector]indexOfSelectedItem] == 0){
        [[[self browserController] myWebView] setCustomUserAgent:kDefaultUserAgentString];
    }
    
    // basic check, should remove spaces
    NSString *landingPageURL = kBrowserDefaultLandingURL;
    
    if(![[[self landingPageField] stringValue] isEqualToString:@""]){
        landingPageURL = [[self landingPageField] stringValue];
    }
    
    [self saveLandingPage: landingPageURL];
    
    return YES; //close the window
    
} //windowShouldClose:

- (void) saveLandingPage: (NSString *) newURL
{
    //store the custom landing page URL in the user defaults
    [[NSUserDefaults standardUserDefaults] setObject:newURL
                                              forKey:@"landingPageURL"];
    
    //override the lastViewed key to flag the custom URL for use
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:@"landingPageLastViewed"];
}

- (IBAction) setLandingPageToCurrentPage: (id) sender
{
    NSString *currentURL = [[[self browserController] myWebView] mainFrameURL];
    
    [[self landingPageField] setStringValue:currentURL];
    [self saveLandingPage:currentURL];
    
} //setLandingPageToCurrentPage:

- (NSTextField *) landingPageField
{
    return landingPageField;
    
} //landingPageField


- (NSPopUpButton *) userAgentSelector
{
    return userAgentSelector;
    
} //userAgentSelector


- (NSButton *) setLandingPageButton
{
    return setLandingPageButton;
    
} //setLandingPageButton


- (OWBrowserController *) browserController
{
    return browserController;
    
} //browserController


@end
