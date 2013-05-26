//
//  NSString+Empty.m
//  vocabulary
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)

- (BOOL)isEmpty
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

@end
