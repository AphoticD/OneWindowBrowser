//
//  OWPreferencesController.h
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/6/18.
//

#import <Cocoa/Cocoa.h>

@class OWBrowserController;

@interface OWPreferencesController : NSWindowController{
    IBOutlet NSTextField *landingPageField;
    IBOutlet NSPopUpButton *userAgentSelector;
    IBOutlet NSButton *setLandingPageButton;
    
    OWBrowserController *browserController;
}

- (id) initWithWindowNibName: (NSString *) nibName
           browserController: (OWBrowserController *) aController;

- (NSTextField *) landingPageField;
- (NSPopUpButton *) userAgentSelector;
- (NSButton *) setLandingPageButton;

- (OWBrowserController *) browserController;

@end
