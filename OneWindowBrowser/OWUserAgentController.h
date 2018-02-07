//
//  OWUserAgentController.h
//  OneWindowBrowser XcodeV2.5
//
//  Created by Daniel Brunet on 6/02/18.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OWBrowserController;

@interface OWUserAgentController : NSWindowController {
	IBOutlet NSTextField *textField;
	IBOutlet NSButton *doneButton;
	
	OWBrowserController *browserController;
}

- (NSWindow *) initWithPanelNibName: (NSString *) nibName
		   browserController: (OWBrowserController *) aController;

- (NSTextField *) textField;
- (NSButton *) doneButton;

- (OWBrowserController *) browserController;

- (IBAction) performDone: (id) sender;

@end
