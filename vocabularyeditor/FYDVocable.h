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

- (id)initWithNative:(NSString*)native AndForeign:(NSString*)foreign AndStage:(FYDStage*)stage;

@property (strong,nonatomic) NSString *native;
@property (strong,nonatomic) NSString *foreign;
@property (weak,nonatomic) FYDStage *stage;

@end
