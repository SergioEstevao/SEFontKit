//
//  SEDetailViewController.m
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SEDetailViewController.h"
#import "SEFontMetricsView.h"

const NSInteger MaxFontSize = 80;
const NSInteger MinFontSize = 8;

@interface SEDetailViewController () {
    NSInteger fontSize;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIFont * font;
@property (strong, nonatomic) IBOutlet UITableView *detailsTable;
@property (strong, nonatomic) IBOutlet SEFontMetricsView *fontMetrics;

- (void)configureView;
@end

@implementation SEDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Font Detail", @"Font Detail");
        self.detailItem = [[UIFont systemFontOfSize:[UIFont systemFontSize]] fontName];
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (!self.detailItem) {
        return;
    }
    
    self.font = [UIFont fontWithName:self.detailItem size:fontSize];
    self.title = self.detailItem;
    
    self.fontMetrics.superview.frame = CGRectMake(self.fontMetrics.superview.frame.origin.x, 
                                                  self.fontMetrics.superview.frame.origin.y, 
                                                  self.fontMetrics.superview.frame.size.width, 
                                                  fmax(MaxFontSize,self.font.lineHeight)); 
    self.fontMetrics.font = self.font;
    self.fontMetrics.frame = CGRectMake(self.fontMetrics.frame.origin.x, 
                                        roundf((self.fontMetrics.superview.frame.size.height-self.font.lineHeight)/2), 
                                        self.fontMetrics.frame.size.width,
                                        self.font.lineHeight);
    self.detailsTable.frame = CGRectMake(0, 
                                         fmax(MaxFontSize,self.font.lineHeight), 
                                         self.detailsTable.frame.size.width, 
                                         self.view.frame.size.height-fmax(MaxFontSize,self.font.lineHeight));    
    [self.fontMetrics setNeedsDisplay];
    [self.detailsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailsTable.delegate = self;
    self.detailsTable.dataSource = self;
    fontSize = [UIFont systemFontSize];
    if ( [[self class] fontMetricsSize] != 0){
        fontSize = [[self class] fontMetricsSize];
    }
    
    if ( [[self class] fontMetricsText] != nil){
        self.fontMetrics.text = [[self class] fontMetricsText];
    }

	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setDetailsTable:nil];
    [self setFontMetrics:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.font = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self configureView];
}

							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Fonts", @"Fonts");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Font Name";
            break;
        case 1:
            return @"Font Metrics";
            break;
        default:
            return 0;
            break;
    };
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 6;
            break;
        default:
            return 0;
            break;
    };
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row){
                case (0):
                    cell.textLabel.text = NSLocalizedString(@"Family",@"Family");
                    cell.detailTextLabel.text = self.font.familyName;
                    break;
                case (1):
                    cell.textLabel.text = NSLocalizedString(@"Name",@"Name");
                    cell.detailTextLabel.text = self.font.fontName;
                    break;
            }
            break;
        case 1:
            switch (indexPath.row){
                case (0):
                    cell.textLabel.text = NSLocalizedString(@"Point Size",@"Point Size");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.pointSize] stringValue];
                    break;
                case (1):
                    cell.textLabel.text = NSLocalizedString(@"Line Height",@"Line Height");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.lineHeight] stringValue];
                    break;
                case (2):
                    cell.textLabel.text = NSLocalizedString(@"Ascender",@"Ascender");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.ascender] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,22,44)];
                    cell.accessoryView.backgroundColor = self.fontMetrics.ascenderColor;
                    break;
                case (3):
                    cell.textLabel.text = NSLocalizedString(@"Cap Height",@"Cap Height");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.capHeight] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,22,44)];
                    cell.accessoryView.backgroundColor = self.fontMetrics.capColor;
                    break;
                case (4):
                    cell.textLabel.text = NSLocalizedString(@"x Height",@"x Height");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.xHeight] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,22,44)];
                    cell.accessoryView.backgroundColor = self.fontMetrics.xColor;                    
                    break;
                case (5):
                    cell.textLabel.text = NSLocalizedString(@"Descender",@"Descender");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.descender] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,22,44)];
                    cell.accessoryView.backgroundColor = self.fontMetrics.descenderColor;
                    break;
                
    
            }
            break;
        
        default:
            break;
    }
    return cell;
}

- (IBAction)sizeChanged:(UISegmentedControl*)sender {
    NSInteger change = 0;
    if ( [sender selectedSegmentIndex] == 0){
        change = -1;
    } 
    if ( [sender selectedSegmentIndex] ==1){
        change = +1;
    }
    fontSize += change;
    
    if ( fontSize > MaxFontSize){
        fontSize = MaxFontSize;
    }
    
    if ( fontSize < MinFontSize){
        fontSize = MinFontSize;
    }
    [[self class] setFontMetricsSize:fontSize];
    [self configureView];
}

- (IBAction)textChanged:(id)sender {
    [[self class] setFontMetricsText:[sender text]];
}


+ (NSString*)fontMetricsText {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sergioestevao.fontmetrics.fonttext"];
}

+ (void)setFontMetricsText:(NSString*)newValue {
	[[NSUserDefaults standardUserDefaults] setObject:newValue forKey:@"com.sergioestevao.fontmetrics.fonttext"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)fontMetricsSize {
	return [[NSUserDefaults standardUserDefaults] floatForKey:@"com.sergioestevao.fontmetrics.fontsize"];
}

+ (void)setFontMetricsSize:(float)newValue {
	[[NSUserDefaults standardUserDefaults] setFloat:newValue forKey:@"com.sergioestevao.fontmetrics.fontsize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
