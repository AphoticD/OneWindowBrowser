//
//  AppDelegate.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 18/05/17.
//  Copyright 2017 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject {
	IBOutlet NSWindow *window;
    
    IBOutlet NSMenuItem *fadeIn;
    IBOutlet NSMenuItem *fadeOut;
}

- (NSWindow *) window;
- (NSMenuItem *) fadeIn;
- (NSMenuItem *) fadeOut;

- (void) performFadeIn: (id) sender;
- (void) performFadeOut: (id) sender;

@end
