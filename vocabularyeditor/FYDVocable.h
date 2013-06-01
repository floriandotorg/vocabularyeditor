//
//  FYDWord.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDStage;

@interface FYDVocable : NSObject

- (id)initWithNative:(NSString*)native AndForeign:(NSString*)foreign AndForeignExample:(NSString*)foreign_example AndStage:(FYDStage*)stage;

@property (strong,nonatomic) NSString *native;
@property (strong,nonatomic) NSString *foreign;
@property (strong,nonatomic) NSString *foreign_example;
@property (weak,nonatomic) FYDStage *stage;

@end
