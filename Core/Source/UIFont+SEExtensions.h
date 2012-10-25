//
//  UIFont+SEExtensions.h
//  SEFontKit
//
//  Created by Sergio Estevao on 25/10/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

@interface UIFont (SEExtensions)

/** Loads a font from an url and adds it to the Font Managaer
*/
+ (UIFont*) fontFromURL:(NSURL *)url size:(CGFloat) size withError:(NSError**) error;

/** Return the CTFontRef of the current font.
 */
- (CTFontRef) CTFontRef;


@end
