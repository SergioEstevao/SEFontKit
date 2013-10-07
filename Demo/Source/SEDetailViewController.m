//
//  SEDetailViewController.m
//
// Copyright (c) 2013 Sergio Estevao (http://sergioestevao.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SEDetailViewController.h"
#import "SEFontMetricsView.h"

const NSInteger MaxFontSize = 80;
const NSInteger MinFontSize = 8;
const CGRect MetricColorLabelSize = {0,0,22,44};
const CGFloat Paddding = 10;

@interface SEDetailViewController () {
    NSInteger fontSize;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIFont * font;
@property (strong, nonatomic) IBOutlet SEFontMetricsView *fontMetrics;
@property (strong, nonatomic) IBOutlet UIView *headerView;

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
    self.fontMetrics.font = self.font;
    self.headerView.frame = CGRectIntegral(CGRectMake(self.fontMetrics.frame.origin.x,
                                       0,
                                       self.fontMetrics.frame.size.width,
                                       self.font.lineHeight+2+Paddding));
    self.fontMetrics.frame = CGRectIntegral(CGRectMake(self.fontMetrics.frame.origin.x,
                                        Paddding/2,
                                        self.fontMetrics.frame.size.width,
                                        self.font.lineHeight+2));
    self.tableView.tableHeaderView = self.headerView;
    [self.fontMetrics setNeedsDisplay];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100+Paddding)];
    self.fontMetrics = [[SEFontMetricsView alloc] initWithFrame:CGRectMake(0, Paddding/2, self.view.frame.size.width, 100)];
    self.fontMetrics.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.fontMetrics.text = @"F f G g";
    self.fontMetrics.textAlignment = NSTextAlignmentCenter;
    self.fontMetrics.delegate = self;
    [self.headerView addSubview:self.fontMetrics];
    
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
    [self setTableView:nil];
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
            return NSLocalizedString(@"Font Name",@"Font Name");
            break;
        case 1:
            return NSLocalizedString(@"Font Metrics",@"Font Metrics");
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
    [cell.accessoryView setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                case (0):{
                    cell.textLabel.text = NSLocalizedString(@"Point Size",@"Point Size");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.pointSize] stringValue];
                    UIStepper * stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
                    stepper.minimumValue = MinFontSize;
                    stepper.maximumValue = MaxFontSize;
                    stepper.stepValue = 1.0;
                    stepper.value = fontSize;

                    [stepper addTarget:self action:@selector(sizeChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = stepper;}
                    break;
                case (1):
                    cell.textLabel.text = NSLocalizedString(@"Line Height",@"Line Height");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.lineHeight] stringValue];
                    break;
                case (2):
                    cell.textLabel.text = NSLocalizedString(@"Ascender",@"Ascender");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.ascender] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:MetricColorLabelSize];
                    cell.accessoryView.backgroundColor = self.fontMetrics.ascenderColor;
                    break;
                case (3):
                    cell.textLabel.text = NSLocalizedString(@"Cap Height",@"Cap Height");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.capHeight] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:MetricColorLabelSize];
                    cell.accessoryView.backgroundColor = self.fontMetrics.capColor;
                    break;
                case (4):
                    cell.textLabel.text = NSLocalizedString(@"x Height",@"x Height");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.xHeight] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:MetricColorLabelSize];
                    cell.accessoryView.backgroundColor = self.fontMetrics.xColor;                    
                    break;
                case (5):
                    cell.textLabel.text = NSLocalizedString(@"Descender",@"Descender");
                    cell.detailTextLabel.text = [[NSNumber numberWithFloat:self.font.descender] stringValue];
                    cell.accessoryView = [[UIView alloc] initWithFrame:MetricColorLabelSize];
                    cell.accessoryView.backgroundColor = self.fontMetrics.descenderColor;
                    break;
                
    
            }
            break;
        
        default:
            break;
    }
    return cell;
}

- (IBAction)sizeChanged:(UIStepper*)sender {
    fontSize = sender.value;
    
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
