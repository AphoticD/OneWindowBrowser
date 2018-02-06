//
//  OWBrowserController.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView, OWUserAgentController, OWLandingPageController;

@interface OWBrowserController : NSObject {
	IBOutlet NSTextField *address;
	IBOutlet NSButton *backButton;
	IBOutlet NSButton *forwardButton;
	IBOutlet WebView *myWebView;
	IBOutlet NSProgressIndicator *myProgress;
	IBOutlet NSButton *stopButton;
	IBOutlet NSButton *reloadButton;
    
	IBOutlet NSMenu *historyMenu;
	IBOutlet NSMenuItem *clearHistory;
	IBOutlet NSMenuItem *goToLanding;
	
	IBOutlet NSMenuItem *disableJavascriptOption;
	IBOutlet NSMenuItem *customUserAgentOption;
	
	IBOutlet NSMenuItem *landingLastViewed;
	IBOutlet NSMenuItem *landingCustom;
	
	NSMutableArray *historyURLs;
	OWUserAgentController *userAgentController;
	OWLandingPageController *landingPageController;
}

- (IBAction) enterAddress:(id) sender;

- (void) addToHistory: (NSString *) titleToAdd
			  withURL: (NSURL *) urlToAdd;

- (void) performHistoryMenuItem: (id) sender;
- (void) performClearHistory: (id) sender;
- (void) performGoToLanding: (id) sender;

- (void) performDisableJavascriptOption: (id) sender;
- (void) performCustomUserAgentOption: (id) sender;

- (void) performSetLandingToLastViewed: (id) sender;
- (void) performSetLandingToCustom: (id) sender;

- (NSButton *) backButton;
- (NSButton *) forwardButton;
- (NSTextField *) address;
- (WebView *) myWebView;
- (NSProgressIndicator *) myProgress;
- (NSButton *) stopButton;
- (NSButton *) reloadButton;

- (NSMenu *) historyMenu;
- (NSMenuItem *) clearHistory;
- (NSMenuItem *) goToLanding;

- (NSMenuItem *) disableJavascriptOption;
- (NSMenuItem *) customUserAgentOption;

- (NSMenuItem *) landingLastViewed;
- (NSMenuItem *) landingCustom;

- (NSMutableArray *) historyURLs;

@end
