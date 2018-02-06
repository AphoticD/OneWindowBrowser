//
//  OWWindowHelper.h
//  OneWindowBrowser
//
//  Created by Daniel Brunet on 22/05/17.
//  Copyright 2018 Aphotic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class OWBrowserController;

@interface OWWindowHelper : NSObject {
	IBOutlet OWBrowserController *browserController;
    IBOutlet NSWindow *window;
}

- (OWBrowserController *) browserController;
- (NSWindow *) window;

@end
