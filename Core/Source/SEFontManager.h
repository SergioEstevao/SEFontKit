//
//  SEFontManager.h
//  SEFontKit
//
//  Created by Sergio Estevao on 26/01/2013.
//  Copyright (c) 2013 Sergio Estevao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEFontManager : NSObject

+ (SEFontManager *)sharedFontManager;

- (BOOL) addFontFromURL:(NSURL *) url error:(NSError **)error;

- (BOOL) removeFontByName:(NSString *) name;

- (BOOL) isUserFont:(NSString *) name;

@end
