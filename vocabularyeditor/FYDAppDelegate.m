//
//  FYDAppDelegate.m
//  vocabularyeditor
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDAppDelegate.h"

#import "SCEvents.h"
#import "NSString+Empty.h"
#import "NSString+containsString.h"

#import "FYDStage.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"

@interface FYDAppDelegate ()

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *saveButton;
@property (unsafe_unretained) IBOutlet NSWindow *mainWindow;
@property (weak) IBOutlet NSSearchField *searchField;

@property (strong, nonatomic) FYDVocabularyBox *vocabularyBox;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *orgData;

@property (strong, nonatomic) SCEvents *events;

@property (unsafe_unretained) IBOutlet NSPanel *addWordSheet;
@property (weak) IBOutlet NSTextField *addWordForeignText;
@property (weak) IBOutlet NSTextField *addWordNativeText;
@property (weak) IBOutlet NSTextField *addWordExampleText;

@end

#define FYDVocableDragType @"floydvocable"

@implementation FYDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.searchField.delegate = self;
    
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:FYDVocableDragType]];
    
    [self loadVocabularyBox];
    
    [self startDropboxMonitor];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.mainWindow makeKeyAndOrderFront:self];
    return NO;
}

#pragma mark - Dropbox Monitor

- (void)startDropboxMonitor
{
    self.events = [[SCEvents alloc] init];
    
    self.events.delegate = self;
    
    [self.events startWatchingPaths:[NSArray arrayWithObject:self.vocabularyBoxFilePath]];
}

- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    [self loadVocabularyBox];
}

#pragma mark - Add Vocable

- (IBAction)plusButtonClick:(NSButton *)sender
{
    [NSApp beginSheet:self.addWordSheet
       modalForWindow:(NSWindow *)_window
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}

- (void)newWord
{
    if (![self.addWordNativeText.stringValue isEmpty] && ![self.addWordForeignText.stringValue isEmpty])
    {
        [[self.vocabularyBox stageAt:0] createVocableWithNative:self.addWordNativeText.stringValue AndForeign:self.addWordForeignText.stringValue AndExample:self.addWordExampleText.stringValue];
    }
    
    self.addWordNativeText.stringValue = @"";
    self.addWordForeignText.stringValue = @"";
    self.addWordExampleText.stringValue = @"";
    
    [self.addWordForeignText becomeFirstResponder];
}

- (IBAction)addWordNextButtonClick:(NSButton *)sender
{
    [self newWord];
}

- (IBAction)addWordSaveButtonClick:(NSButton *)sender
{
    [self newWord];
    
    [NSApp endSheet:self.addWordSheet];
    [self.addWordSheet orderOut:sender];
    
    [self vocabularyBoxHasChanged];
}

#pragma mark - Vocabulary Box

- (IBAction)saveButtonClick:(id)sender
{
    [self saveVocabularyBox];
    self.saveButton.enabled = NO;
}

- (void)vocabularyBoxHasChanged
{
    [self updateData];
    [self.tableView selectRowIndexes:[[NSIndexSet alloc] init] byExtendingSelection:NO];
    self.saveButton.enabled = YES;
}

- (NSString*) vocabularyBoxFilePath
{
    return [NSHomeDirectory() stringByAppendingString:@"/Dropbox/Apps/FloydVocabulary/VocabularyBox.plist"];
}

- (void)updateData
{
    self.orgData = [[NSMutableArray alloc] init];
    
    for (NSUInteger n = 0; n < self.vocabularyBox.stageCount; ++n)
    {
        FYDStage *stage = [self.vocabularyBox stageAt:n];
        [self.orgData addObject:stage];
        
        NSMutableArray *vocables = [[NSMutableArray alloc] init];
        
        for (NSUInteger m = 0; m < stage.vocabularyCount; ++m)
        {
            [vocables addObject:[stage vocableAt:m]];
        }
        
        [vocables sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             FYDVocable *vocable1 = obj1;
             FYDVocable *vocable2 = obj2;
             
             return [vocable1.foreign localizedCaseInsensitiveCompare:vocable2.foreign];
         }];
        
        [self.orgData addObjectsFromArray:vocables];
    }
    
    [self filterData];
}

- (void) loadVocabularyBox
{
    self.vocabularyBox = [NSKeyedUnarchiver unarchiveObjectWithFile:self.vocabularyBoxFilePath];
    
    [self updateData];
}

- (void) saveVocabularyBox
{
    [NSKeyedArchiver archiveRootObject:self.vocabularyBox toFile:self.vocabularyBoxFilePath];
}

#pragma mark - Search

-(void)controlTextDidChange:(NSNotification *)obj
{
    if ([obj.object isKindOfClass:[NSSearchField class]])
    {
        [self filterData];
    }
}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    if ([obj.object isKindOfClass:[NSTableView class]])
    {
        [self vocabularyBoxHasChanged];
    }
}

- (void)filterData
{
    if ([self.searchField.stringValue isEmpty])
    {
        self.data = self.orgData;
    }
    else
    {
        self.data = [[self.orgData objectsAtIndexes:[self.orgData indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop)
        {
            if ([obj isKindOfClass:[FYDVocable class]])
            {
                FYDVocable *vocable = (FYDVocable*)obj;
                if ([vocable.foreign containsString:self.searchField.stringValue] || [vocable.native containsString:self.searchField.stringValue] || [vocable.foreign_example containsString:self.searchField.stringValue])
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
            else
            {
                return YES;
            }
        }]] mutableCopy];
    }
    
    [self.tableView reloadData];
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
        else if ([tableColumn.identifier isEqualToString:@"foreign_example"])
        {
            return vocable.foreign_example;
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
    else if ([tableColumn.identifier isEqualToString:@"foreign_example"])
    {
        vocable.foreign_example = object;
    }
}

#pragma mark - Table Drag & Drop

- (BOOL)tableView:(NSTableView*)tableView writeRowsWithIndexes:(NSIndexSet*)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    
    [pboard declareTypes:[NSArray arrayWithObject:FYDVocableDragType] owner:self];
    
    [pboard setData:indexData forType:FYDVocableDragType];
    
    return YES;
}

- (NSIndexSet*)dragRowsForDrop:(NSPasteboard*)draggingPasteboard
{
    NSData* rowData = [draggingPasteboard dataForType:FYDVocableDragType];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
}

- (FYDStage*)lastStageBeforeRow:(NSUInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    NSUInteger n = row;

    if (n >= self.data.count)
    {
        n = self.data.count - 1;
    }
    
    if (n > 0 && dropOperation == NSTableViewDropAbove && [self.data[n] isKindOfClass:[FYDStage class]])
    {
        --n;
    }
    
    for (; ![self.data[n] isKindOfClass:[FYDStage class]]; --n);
    
    return self.data[n];
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    if ([self lastStageBeforeRow:row proposedDropOperation:dropOperation] != ((FYDVocable*)self.data[[self dragRowsForDrop:info.draggingPasteboard].firstIndex]).stage)
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
    NSIndexSet *dragRows = [self dragRowsForDrop:info.draggingPasteboard];
    
    FYDStage *stage = [self lastStageBeforeRow:row proposedDropOperation:dropOperation];
    
    [dragRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
        {
            FYDVocable *vocable = self.data[idx];
            
            if (stage != vocable.stage)
            {
                [vocable.stage removeVocable:vocable];
                [stage addVocable:vocable];
            }
        }];
    
    [self vocabularyBoxHasChanged];
    
    return YES;
}

- (BOOL)tableView:(NSTableView*)sender deleteDrop:(NSPasteboard*)draggingPasteboard dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSIndexSet *dragRows = [self dragRowsForDrop:draggingPasteboard];
    
    [dragRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
        {
            FYDVocable *vocable = self.data[idx];
            [vocable.stage removeVocable:vocable];
        }];
    
    [self vocabularyBoxHasChanged];
    
     return YES;
}

@end
