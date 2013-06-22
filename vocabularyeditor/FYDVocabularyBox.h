//
//  FYDVocabularyBox.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDStage;
@class FYDVocable;
@class FYDVocabularyTest;

@interface FYDVocabularyBox : NSObject

- (id) init;

- (FYDStage*)addStage;

- (NSInteger)stageCount;
- (FYDStage*)stageAt:(NSInteger)stageNo;

#ifndef FYD_NO_VOCABULARY_TEST
- (FYDVocabularyTest*)vocabularyTestForStage:(NSInteger)stageNo;
#endif

- (FYDStage*)recommandedStage;

- (void)putIntoFirstStage:(FYDVocable*)vocable;
- (void)putIntoNextStage:(FYDVocable*)vocable;

@end
