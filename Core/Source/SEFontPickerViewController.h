//
//  SEFontPickViewController.h
//  SEFontKit
//
//  Created by Sergio Estevao on 19/11/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEFontPickerViewController;

@protocol SEFontPickerViewControllerDelegage <NSObject>

- (void) fontPickerViewController:(SEFontPickerViewController*) fontPicker selectedFont:(UIFont*)font;

@end

@interface SEFontPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property(nonatomic, weak) id<SEFontPickerViewControllerDelegage> delegate;

@end
