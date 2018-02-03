//
//  BrowserController.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2017 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView;

@interface BrowserController : NSObject {
	IBOutlet NSTextField *address;
	IBOutlet NSButton *backButton;
	IBOutlet NSButton *forwardButton;
	IBOutlet WebView *myWebView;
	IBOutlet NSProgressIndicator *myProgress;
	IBOutlet NSMenu *historyMenu;
	IBOutlet NSButton *stopButton;
	IBOutlet NSButton *reloadButton;
    
	NSMutableArray *historyURLs;
}

- (NSMutableArray *) historyURLs;

- (IBAction) enterAddress:(id) sender;

- (void) addToHistory: (NSString *) titleToAdd
			  withURL: (NSURL *) urlToAdd;

- (void) performHistoryMenuItem: (id) sender;

- (NSButton *) backButton;
- (NSButton *) forwardButton;
- (NSTextField *) address;
- (WebView *) myWebView;
- (NSProgressIndicator *) myProgress;
- (NSMenu *) historyMenu;
- (NSButton *) stopButton;
- (NSButton *) reloadButton;

@end
