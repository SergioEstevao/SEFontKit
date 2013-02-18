//
//  UIFont+SEExtensions.h
//  SEFontKit
//
//  Created by Sergio Estevao on 25/10/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

@interface UIFont (SEExtensions)

+ (UIFont *) fontFromCTFont:(CTFontRef) fontRef;

/** Loads a font from an url and adds it to the Font Manager.
*/
+ (UIFont*) fontFromURL:(NSURL *)url size:(CGFloat) size withError:(NSError**) error;

/** Registers a font from a data object and returns the font name.
 */
+ (NSString *) registerFontFromData:(NSData *)data withError:(NSError**) error;

/** Unregisters a font from the font manager.
 */
+ (BOOL) unregisterFontWithName:(NSString *)name withError:(NSError**) error;

/** Return the CTFontRef of the current font.
 */
- (CTFontRef) CTFontRef;


@end
