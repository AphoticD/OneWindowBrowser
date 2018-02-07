//
//  OWBrowserController.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView, OWPreferencesController;

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
	IBOutlet NSMenuItem *goToPreferences;
	
	NSMutableArray *historyURLs;
	OWPreferencesController *preferencesController;
}

- (IBAction) enterAddress:(id) sender;

- (void) addToHistory: (NSString *) titleToAdd
			  withURL: (NSURL *) urlToAdd;

- (void) performHistoryMenuItem: (id) sender;
- (void) performClearHistory: (id) sender;
- (void) performGoToLanding: (id) sender;

- (void) performDisableJavascriptOption: (id) sender;
- (void) performShowPreferences: (id) sender;


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

- (NSMenuItem *) goToPreferences;

- (NSMutableArray *) historyURLs;

@end
