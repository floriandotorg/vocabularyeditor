//
//  NSString+containsString.m
//  Dehoga
//
//  Created by Florian Kaiser on 04.11.13.
//  Copyright (c) 2013 28Apps UG (haftungsbeschränkt). All rights reserved.
//

#import "NSString+containsString.h"

@implementation NSString (containsString)

- (BOOL)containsString:(NSString*)string
{
    return [self rangeOfString:string options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound;
}

@end
