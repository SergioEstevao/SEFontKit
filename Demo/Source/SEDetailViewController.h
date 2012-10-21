//
//  SEDetailViewController.h
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SEFontMetricsView.h"

@interface SEDetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UITableView *detailsTable;
@property (strong, nonatomic) IBOutlet SEFontMetricsView *fontMetrics;
- (IBAction)sizeChanged:(UISegmentedControl *)sender;


@end
