//
//  SEDetailViewController.h
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

@interface SEDetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;
- (IBAction)sizeChanged:(UISegmentedControl *)sender;


@end
