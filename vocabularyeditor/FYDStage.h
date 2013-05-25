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

@property (readonly,nonatomic) int no;

- (id)initWithNo:(NSInteger)no;

- (NSInteger)vocabularyCount;
- (FYDVocable*)vocableAt:(NSInteger)vocableNo;

- (void)createVocableWithNative:(NSString*)native AndForeign:(NSString*)foreign;

- (void)addVocable:(FYDVocable*)vocable;
- (void)removeVocable:(FYDVocable*)vocable;

#ifndef FYD_NO_VOCABULARY_TEST
- (FYDVocabularyTest*)vocabularyTestWithBox:(FYDVocabularyBox*)box;
#endif

@end
