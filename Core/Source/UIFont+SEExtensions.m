//
//  UIFont+SEExtensions.m
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

#import "UIFont+SEExtensions.h"

@implementation UIFont (SEExtensions)

+ (UIFont *) fontFromCTFont:(CTFontRef) fontRef{
    NSString * fontName = (__bridge_transfer NSString*)CTFontCopyPostScriptName(fontRef);
    CGFloat size = CTFontGetSize(fontRef);
    UIFont * font = [UIFont fontWithName:fontName size:size];
    return font;
}

- (CTFontRef) CTFontRef {
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)self.fontName,
                                            self.pointSize,
                                            NULL);
    return ctFont;
}

+ (UIFont*) fontFromURL:(NSURL *)url size:(CGFloat) size withError:(NSError**) error{
    NSData * data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:error];
    if (data == nil || data.length == 0){
        return nil;
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGFontRef cgFont = CGFontCreateWithDataProvider(provider);
    CFErrorRef localError;
    if (!CTFontManagerRegisterGraphicsFont(cgFont, &localError)) {
        if ( error != nil){
            *error = (__bridge_transfer NSError *)localError;
        }
        return nil;
    }
    NSString * fontName = (__bridge_transfer NSString*)CGFontCopyPostScriptName(cgFont);
    UIFont * font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(cgFont);
    CGDataProviderRelease(provider);
    return font;
}

+ (NSString *) registerFontFromData:(NSData *)data withError:(NSError**) error{
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGFontRef cgFont = CGFontCreateWithDataProvider(provider);
    CFErrorRef localError;
    if (!CTFontManagerRegisterGraphicsFont(cgFont, &localError)) {
        if ( error != nil){
            *error = (__bridge_transfer NSError *)localError;
        }
        return nil;
    }
    NSString * fontName = (__bridge_transfer NSString*)CGFontCopyPostScriptName(cgFont);
    return fontName;
}

+ (BOOL) unregisterFontWithName:(NSString *)name withError:(NSError**) error{
    CGFontRef cgFont = CGFontCreateWithFontName((__bridge CFStringRef)name);
    CFErrorRef localError;
    if (!CTFontManagerUnregisterGraphicsFont(cgFont, &localError)) {
        if ( error != nil){
            *error = (__bridge_transfer NSError *)localError;
        }
        return NO;
    }
    return YES;
}



- (NSString *)description
{
	return [NSString stringWithFormat:@"%i pt %@", (int)self.pointSize, self.fontName];
}

@end
