//
//  OWAppDelegate.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kDefaultUserAgentString		@"Mozilla/5.0 (iPad; U; CPU OS 3_2_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B500 Safari/531.21.10"
#define kBrowserHistoryLimit		100
#define kBrowserDefaultLandingURL	@"http://www.google.com"
#define klandingPageLastViewed		YES

#define kFadeMin 0.2
#define kFadeMax 1.0
#define kFadeStep 0.15

@class OWBrowserController;

@interface OWAppDelegate : NSObject {
	IBOutlet NSWindow *window;
    
    IBOutlet NSMenuItem *fadeIn;
    IBOutlet NSMenuItem *fadeOut;
	
	IBOutlet OWBrowserController *browserController;
}

- (NSWindow *) window;
- (NSMenuItem *) fadeIn;
- (NSMenuItem *) fadeOut;

- (OWBrowserController *) browserController;

- (void) performFadeIn: (id) sender;
- (void) performFadeOut: (id) sender;

- (void) loadPreferences;
- (void) savePreferences;

@end
