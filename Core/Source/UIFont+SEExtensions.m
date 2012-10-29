//
//  UIFont+SEExtensions.m
//  SEFontKit
//
//  Created by Sergio Estevao on 25/10/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "UIFont+SEExtensions.h"

@implementation UIFont (SEExtensions)

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
    CFErrorRef localError = NULL;
    if (!CTFontManagerRegisterGraphicsFont(cgFont, &localError)) {
                *error = (__bridge NSError *)localError;
        return nil;
    }
    NSString * fontName = (__bridge_transfer NSString*)CGFontCopyPostScriptName(cgFont);
    UIFont * font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(cgFont);
    CGDataProviderRelease(provider);
    return font;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, %f", self.fontName, self.pointSize];
}

@end