//
//  FYDWord.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocable.h"

#import "FYDStage.h"

@interface FYDVocable ()

@end

@implementation FYDVocable

- (id)initWithNative:(NSString*)native AndForeign:(NSString*)foreign AndForeignExample:(NSString*)foreign_example AndStage:(FYDStage*)stage
{
    if (self = [super init])
    {
        self.native = native;
        self.foreign = foreign;
        self.foreign_example = foreign_example;
        self.stage = stage;
    }
    return self;
}

#pragma mark - Persistent State

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.native forKey:@"native"];
    [aCoder encodeObject:self.foreign forKey:@"foreign"];
    [aCoder encodeObject:self.foreign_example forKey:@"foreign_example"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.native = [aDecoder decodeObjectForKey:@"native"];
        self.foreign = [aDecoder decodeObjectForKey:@"foreign"];
        self.foreign_example = [aDecoder decodeObjectForKey:@"foreign_example"];
    }
    
    return self;
}

@end
