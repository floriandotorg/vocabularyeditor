//
//  FYDStage.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDStage.h"

#import "FYDVocable.h"

#ifndef FYD_NO_VOCABULARY_TEST
#import "FYDVocabularyTest.h"
#endif

@interface FYDStage ()

@property (assign,nonatomic) int no;
@property (strong,nonatomic) NSMutableArray *vocabularies;

@end

@implementation FYDStage

- (id)initWithNo:(NSInteger)no;
{
    if (self = [super init])
    {
        self.vocabularies = [[NSMutableArray alloc] init];
        self.no = no;
    }
    return self;
}

- (void)createVocableWithNative:(NSString*)native AndForeign:(NSString*)foreign AndExample:(NSString*)example
{
    [self.vocabularies addObject:[[FYDVocable alloc] initWithNative:native AndForeign:foreign AndForeignExample:example AndStage:self]];
}

- (void)addVocable:(FYDVocable*)vocable
{
    vocable.stage = self;
    [self.vocabularies addObject:vocable];
}

- (void)removeVocable:(FYDVocable*)vocable
{
    vocable.stage = nil;
    [self.vocabularies removeObject:vocable];
}

- (NSInteger)vocabularyCount
{
    return self.vocabularies.count;
}

- (FYDVocable*)vocableAt:(NSInteger)vocableNo
{
    return self.vocabularies[vocableNo];
}

#ifndef FYD_NO_VOCABULARY_TEST
- (FYDVocabularyTest*)vocabularyTestWithBox:(FYDVocabularyBox*)box
{
    return [[FYDVocabularyTest alloc] initWithVocabularies:self.vocabularies AndVocabularyBox:box];
}
#endif

#pragma mark - Persistent State

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.no forKey:@"no"];
    [aCoder encodeObject:self.vocabularies forKey:@"vocabularies"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.no = [aDecoder decodeIntegerForKey:@"no"];
        self.vocabularies = [aDecoder decodeObjectForKey:@"vocabularies"];
        
        for (FYDVocable *vocable in self.vocabularies)
        {
            vocable.stage = self;
        }
    }
    
    return self;
}

@end
