//
//  NSString+SEExtension.m
//  Demo
//
//  Created by Sergio Estevao on 21/10/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "NSString+SEExtension.h"

@implementation NSString (SEExtension)

- (BOOL) se_isEmpty{
    return self.length == 0;
}

+ (BOOL) se_isNullOrEmpty:(NSString *) str {
    return str == nil || [str se_isEmpty];
}

+ (BOOL) se_isNullOrWhiteSpaces:(NSString *) str {
    return str == nil || [str se_isEmpty] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  se_isEmpty];
}

@end

