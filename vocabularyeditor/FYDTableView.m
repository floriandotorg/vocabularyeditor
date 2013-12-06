//
//  FYDTableView.m
//  vocabularyeditor
//
//  Created by Florian Kaiser on 26.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDTableView.h"

@interface NSObject ()

- (BOOL)tableView:(NSTableView*)sender deleteDrop:(NSPasteboard*)draggingPasteboard dropOperation:(NSTableViewDropOperation)dropOperation;

@end

@implementation FYDTableView

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint
{
    session.animatesToStartingPositionsOnCancelOrFail = NO;
}

- (void)draggingSession:(NSDraggingSession*)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    if (!NSMouseInRect([self convertPointFromBase:[self.window convertScreenToBase:screenPoint]], self.bounds, NO))
    {
        if ([(NSObject*)[self dataSource] tableView:self deleteDrop:session.draggingPasteboard dropOperation:operation])
        {
            NSShowAnimationEffect(NSAnimationEffectDisappearingItemDefault, screenPoint, NSZeroSize, nil, nil, nil);
        }
    }
}

@end
