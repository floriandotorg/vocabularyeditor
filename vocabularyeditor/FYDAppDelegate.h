//
//  FYDAppDelegate.h
//  vocabularyeditor
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FYDAppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
