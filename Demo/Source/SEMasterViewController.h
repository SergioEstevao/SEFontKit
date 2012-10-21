//
//  SEMasterViewController.h
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//


@class SEDetailViewController;

@interface SEMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) SEDetailViewController *detailViewController;

@end
