//
//  SEFontManager.m
//  SEFontKit
//
//  Created by Sergio Estevao on 26/01/2013.
//  Copyright (c) 2013 Sergio Estevao. All rights reserved.
//

#import "SEFontManager.h"
#import "UIFont+SEExtensions.h"

NSString * const DownloadedFonts = @"DownloadedFonts";
@implementation SEFontManager

NSMutableDictionary * _fontsDownloaded;

+ (SEFontManager *)sharedFontManager {
    static SEFontManager *_sharedFontManager = nil;
    static dispatch_once_t _sharedFontManagerOnceToken;
    dispatch_once(&_sharedFontManagerOnceToken, ^{
        _sharedFontManager = [[SEFontManager alloc] init];
        [_sharedFontManager loadFonts];
    });
    
    return _sharedFontManager;
}

-(id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:DownloadedFonts];
    _fontsDownloaded = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    return self;
}

- (void) loadFonts {
    [_fontsDownloaded enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSError * error;
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj] options:NSDataReadingUncached error:&error];
        if (data == nil || data.length == 0){
            return;
        }
        
        [UIFont registerFontFromData:data withError:&error];
    }];
}

- (NSString *) addFontFromURL:(NSURL *) url error:(NSError **)error{
    NSData * data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:error];
    if (data == nil || data.length == 0){
        return NO;
    }
    
    NSString * name = [UIFont registerFontFromData:data withError:error];
    
    if (name == nil){
        // There was a problem registering the font
        return nil;
    }
    
    NSURL * baseFolder = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    baseFolder = [baseFolder URLByAppendingPathComponent:DownloadedFonts];
    BOOL result =[[NSFileManager defaultManager] createDirectoryAtURL:baseFolder withIntermediateDirectories:YES attributes:nil error:error];
    if (!result){
        return NO;
    }
    baseFolder = [baseFolder URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.ttf",name]];
    result = [data writeToURL:baseFolder options:NSDataWritingAtomic error:error];
    if (!result){
        return NO;
    }
    [_fontsDownloaded setObject:[baseFolder absoluteString] forKey:name];
    
    // save it to userDefaults
    [[NSUserDefaults standardUserDefaults] setObject:_fontsDownloaded forKey:DownloadedFonts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return name;
}

- (BOOL) removeFontByName:(NSString *) name {
    
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:[_fontsDownloaded objectForKey:name]] error:nil];
    [_fontsDownloaded removeObjectForKey:name];
    [UIFont unregisterFontWithName:name withError:nil];
    // save it to userDefaults
    [[NSUserDefaults standardUserDefaults] setObject:_fontsDownloaded forKey:DownloadedFonts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
- (BOOL) isUserFont:(NSString *) name{
    return [_fontsDownloaded objectForKey:name] != nil;
}

- (NSString *) uniqueFilename:(NSString *) prefixString {
    
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@", prefixString, guid];
    
    return  uniqueFileName;
}

@end
