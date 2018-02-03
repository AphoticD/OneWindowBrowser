//
//  WindowHelper.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 22/05/17.
//  Copyright 2017 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BrowserController;

@interface WindowHelper : NSObject {
	IBOutlet BrowserController *browserController;
    IBOutlet NSWindow *window;
}

- (BrowserController *) browserController;
- (NSWindow *) window;

@end
