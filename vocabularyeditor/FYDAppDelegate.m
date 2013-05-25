//
//  FYDAppDelegate.m
//  vocabularyeditor
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDAppDelegate.h"

#import "FYDStage.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"

@interface FYDAppDelegate ()

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *saveButton;

@property (strong, nonatomic) FYDVocabularyBox *vocabularyBox;
@property (strong, nonatomic) NSMutableArray *data;

@end

#define FYDVocableDragType @"floydvocable"

@implementation FYDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:FYDVocableDragType]];
    [self loadVocabularyBox];
}

- (IBAction)saveButtonClick:(id)sender
{
    [self saveVocabularyBox];
    self.saveButton.enabled = NO;
}

- (void)dataHasChanged
{
    self.saveButton.enabled = YES;
    [self.tableView reloadData];
}

- (NSString*) vocabularyBoxFilePath
{
    return [NSHomeDirectory() stringByAppendingString:@"/Dropbox/Apps/FloydVocabulary/VocabularyBox.plist"];
}

- (void) loadVocabularyBox
{
    self.vocabularyBox = [NSKeyedUnarchiver unarchiveObjectWithFile:self.vocabularyBoxFilePath];
    
    self.data = [[NSMutableArray alloc] init];
    
    for (NSUInteger n = 0; n < self.vocabularyBox.stageCount; ++n)
    {
        FYDStage *stage = [self.vocabularyBox stageAt:n];
        
        [self.data addObject:stage];
        
        for (NSUInteger m = 0; m < stage.vocabularyCount; ++m)
        {
            [self.data addObject:[stage vocableAt:m]];
        }
    }
    
    [self.tableView reloadData];
}

- (void) saveVocabularyBox
{
    [NSKeyedArchiver archiveRootObject:self.vocabularyBox toFile:self.vocabularyBoxFilePath];
}

#pragma mark - Table

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.data.count;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    return [self.data[row] isKindOfClass:[FYDStage class]];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return ![self tableView:tableView isGroupRow:row];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return ![self tableView:tableView isGroupRow:row];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([self.data[row] isKindOfClass:[FYDStage class]])
    {
        if ([tableColumn.identifier isEqualToString:@"foreign"])
        {
            FYDStage *stage = self.data[row];
            return [NSString stringWithFormat:@"Stage %i", stage.no];
        }
        else
        {
            return @"";
        }
    }
    else if ([self.data[row] isKindOfClass:[FYDVocable class]])
    {
        FYDVocable *vocable = self.data[row];
        
        if ([tableColumn.identifier isEqualToString:@"foreign"])
        {
            return vocable.foreign;
        }
        else if ([tableColumn.identifier isEqualToString:@"native"])
        {
            return vocable.native;
        }
    }
    
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    FYDVocable *vocable = self.data[row];
    
    if ([tableColumn.identifier isEqualToString:@"foreign"])
    {
        vocable.foreign = object;
    }
    else if ([tableColumn.identifier isEqualToString:@"native"])
    {
        vocable.native = object;
    }
    
    [self dataHasChanged];
}

#pragma mark - Table Drag & Drop

- (BOOL)tableView:(NSTableView*)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    
    [pboard declareTypes:[NSArray arrayWithObject:FYDVocableDragType] owner:self];
    
    [pboard setData:indexData forType:FYDVocableDragType];
    
    return YES;
}

- (NSUInteger)dragRowForDrop:(id<NSDraggingInfo>)info
{
    NSData* rowData = [[info draggingPasteboard] dataForType:FYDVocableDragType];
    
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    
    return [rowIndexes firstIndex];
}

- (FYDStage*)lastStageBeforeRow:(NSUInteger)row
{
    NSUInteger n = row;
    
    if (n >= self.data.count)
    {
        n = self.data.count - 1;
    }
    
    for (; ![self.data[n] isKindOfClass:[FYDStage class]]; --n);
    
    return self.data[n];
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    if ([self lastStageBeforeRow:row] != ((FYDVocable*)self.data[[self dragRowForDrop:info]]).stage)
    {
        return NSDragOperationMove | NSDragOperationDelete;
    }
    else
    {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView*)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSUInteger dragRow = [self dragRowForDrop:info];
    
    FYDVocable *vocable = self.data[dragRow];
    FYDStage *stage = [self lastStageBeforeRow:row];
    
    if (stage != vocable.stage)
    {
        [self.data removeObjectAtIndex:dragRow];
        
        if (dropOperation == NSTableViewDropAbove)
        {
            [self.data insertObject:vocable atIndex:row - 1];
        }
        else
        {
            [self.data insertObject:vocable atIndex:row];
        }
        
        [vocable.stage removeVocable:vocable];
        [stage addVocable:vocable];
        
        [self dataHasChanged];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
