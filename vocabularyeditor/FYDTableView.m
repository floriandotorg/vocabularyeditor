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
    //NSLog(@"endedAtPoint: %f, %f", [self.window convertRectFromScreen:NSMakeRect(screenPoint.x, screenPoint.y, 0, 0)].origin.x, [self.window convertRectFromScreen:NSMakeRect(screenPoint.x, screenPoint.y, 0, 0)].origin.y);
    
    if (!NSMouseInRect([self.window convertRectFromScreen:NSMakeRect(screenPoint.x, screenPoint.y, 0, 0)].origin, self.bounds, NO))
    {
        //NSLog(@"drop out of tableview");
        if ([(NSObject*)[self dataSource] tableView:self deleteDrop:session.draggingPasteboard dropOperation:operation])
        {
            NSShowAnimationEffect(NSAnimationEffectDisappearingItemDefault, screenPoint, NSZeroSize, nil, nil, nil);
        }
    }
}

@end
