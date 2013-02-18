//
//  SERootViewController.m
//  SEFontKit
//
//  Created by Sergio Estevao on 27/01/2013.
//  Copyright (c) 2013 Sergio Estevao. All rights reserved.
//

#import "SERootViewController.h"

#import "SEMasterViewController.h"
#import "SEDetailViewController.h"
#import "SETextEditViewController.h"

@interface SERootViewController ()
    @property (strong, nonatomic) UINavigationController *navigationController;
    @property (strong, nonatomic) UISplitViewController *splitViewController;
@end

@implementation SERootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UITabBarController * tabController = [[UITabBarController alloc] init];
    NSArray * viewControllers = nil;
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        SEMasterViewController *masterViewController = [[SEMasterViewController alloc] initWithNibName:@"SEMasterViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Metrics" image:nil tag:0];
        
        UINavigationController * textEditViewController = [[UINavigationController alloc] initWithRootViewController:[[SETextEditViewController alloc] init]];
        textEditViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Picker" image:nil tag:1];
        
        viewControllers = @[self.navigationController, textEditViewController];
    } else {
        SEMasterViewController *masterViewController = [[SEMasterViewController alloc] initWithNibName:@"SEMasterViewController" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        SEDetailViewController *detailViewController = [[SEDetailViewController alloc] initWithNibName:@"SEDetailViewController" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    	
    	masterViewController.detailViewController = detailViewController;
    	
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Metrics" image:nil tag:0];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[SETextEditViewController alloc] init]];
        self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Picker" image:nil tag:1];
        
        viewControllers = @[self.splitViewController, self.navigationController];
    }
    tabController.viewControllers = viewControllers;
    [self.view addSubview:tabController.view];
    [self addChildViewController:tabController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
