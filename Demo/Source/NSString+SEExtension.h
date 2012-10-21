//
//  NSString+SEExtension.h
//  Demo
//
//  Created by Sergio Estevao on 21/10/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

@interface NSString (SEExtension)

/*!
 Returns YES if the string is empty
 */
- (BOOL) se_isEmpty;

/*!
 Returns YES if the string is nil or empty
 
 @param str The string to check
 */
+ (BOOL) se_isNullOrEmpty:(NSString *) str;

/*!
 Returns YES if the string is nil, empty or only contains withespace chars like: space, tab, newline
 
 @param str The string to check
 */
+ (BOOL) se_isNullOrWhiteSpaces:(NSString *) str;

@end
