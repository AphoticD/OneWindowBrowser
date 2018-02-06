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
	IBOutlet NSButton *cancelButton;
	IBOutlet NSButton *okButton;
	IBOutlet NSButton *useDefaultButton;
	
	OWBrowserController *browserController;
}

- (id) initWithWindowNibName: (NSString *) nibName
		   browserController: (OWBrowserController *) aController;

- (NSTextField *) textField;
- (NSButton *) cancelButton;
- (NSButton *) okButton;
- (NSButton *) useDefaultButton;

- (OWBrowserController *) browserController;

- (IBAction) performCancel:(id) sender;
- (IBAction) performOK: (id) sender;
- (IBAction) performUseDefault: (id) sender;

@end
