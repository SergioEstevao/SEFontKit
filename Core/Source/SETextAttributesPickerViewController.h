//
//  SEFontPickerViewController.h
//  SEFontKit
//
//  Created by Sergio Estevao on 18/11/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SETextAttributesPickerViewController;

@protocol SETextAttributesPickerViewControllerDelegage <NSObject>

@optional
- (void) textAttributesPickerViewController:(SETextAttributesPickerViewController*) fontPicker selectedAttributes:(NSDictionary*)attributes;

@end


@interface SETextAttributesPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id<SETextAttributesPickerViewControllerDelegage> delegate;

@property  (strong, nonatomic) NSDictionary * attributes;

@end
