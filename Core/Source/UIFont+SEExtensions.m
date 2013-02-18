//
//  UIFont+SEExtensions.m
//  SEFontKit
//
//  Created by Sergio Estevao on 25/10/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

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
