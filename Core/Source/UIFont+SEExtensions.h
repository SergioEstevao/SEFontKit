//
//  UIFont+SEExtensions.h
//
// Copyright (c) 2013 Sergio Estevao (http://sergioestevao.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
