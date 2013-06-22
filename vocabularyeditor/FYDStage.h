//
//  FYDStage.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDVocable;
@class FYDVocabularyBox;
@class FYDVocabularyTest;

@interface FYDStage : NSObject

@property (readonly, nonatomic) int no;
@property (readonly, nonatomic) NSUInteger testCount;
@property (weak, nonatomic) FYDVocabularyBox *vocabularyBox;

- (id)initWithNo:(NSInteger)no inVocabularyBox:(FYDVocabularyBox*)vocabularyBox;

- (NSInteger)vocabularyCount;
- (FYDVocable*)vocableAt:(NSInteger)vocableNo;

- (void)createVocableWithNative:(NSString*)native AndForeign:(NSString*)foreign AndExample:(NSString*)example;

- (void)addVocable:(FYDVocable*)vocable;
- (void)removeVocable:(FYDVocable*)vocable;

- (void)incTestCount;
- (BOOL)recommanded;

#ifndef FYD_NO_VOCABULARY_TEST
- (FYDVocabularyTest*)vocabularyTestWithBox:(FYDVocabularyBox*)box;
#endif

@end
