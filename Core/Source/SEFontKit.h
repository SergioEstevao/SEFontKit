//
//  SEFontKit.h
//  SEFontKit
//
//  Created by Sergio Estevao on 09/05/2013.
//  Copyright (c) 2013 Sergio Estevao. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#define NSFontAttributeName (NSString *)kCTFontAttributeName
#define NSStrikethroughStyleAttributeName @""
#define NSUnderlineStyleAttributeName (NSString *)kCTUnderlineStyleAttributeName
#define NSUnderlineStyleNone 0x00
#define NSUnderlineStyleSingle 0x01
#endif

#import "SEFontManager.h"
#import "SEFontMetricsView.h"
#import "UIFont+SEExtensions.h"
#import "SETextAttributesPickerViewController.h"
#import "SEFontPickerViewController.h"