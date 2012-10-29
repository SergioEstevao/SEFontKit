//
//  SEMasterViewController.m
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SEMasterViewController.h"
#import "NSString+SEExtension.h"
#import "SEDetailViewController.h"

@interface SEMasterViewController () {
    NSArray *_fontFamilies;
    NSMutableArray *_fonts;
        
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SEMasterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Fonts", @"Fonts");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        _fontFamilies = [[UIFont familyNames] sortedArrayUsingComparator:
        ^(NSString * obj1, NSString * obj2){ 
            return [obj1 compare:obj2];
        } ];
 
        _fonts = [NSMutableArray arrayWithCapacity:_fontFamilies.count];
        for (NSString * fontFamily in _fontFamilies){
            [_fonts addObject:[UIFont fontNamesForFamilyName:fontFamily]];
        }    
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fontFamilies.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_fonts objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_fontFamilies objectAtIndex:section];    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    NSString *fontName = [[_fonts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = fontName;
    cell.textLabel.font = [UIFont fontWithName:fontName size:[UIFont systemFontSize]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *object = [[_fonts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[SEDetailViewController alloc] initWithNibName:@"SEDetailViewController" bundle:nil];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}


#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if( ![NSString se_isNullOrWhiteSpaces:searchBar.text]) {
        NSPredicate * predicate = [NSPredicate
                                   predicateWithFormat:@"(%K CONTAINS[cd] %@)", @"description",
                                   searchBar.text];
        _fontFamilies = [[UIFont familyNames] filteredArrayUsingPredicate:predicate];
    } else {
        _fontFamilies = [UIFont familyNames];
    }
    
    _fontFamilies = [_fontFamilies sortedArrayUsingComparator:
                     ^(NSString * obj1, NSString * obj2){ 
                         return [obj1 compare:obj2];
                     } ];
    _fonts = [NSMutableArray arrayWithCapacity:_fontFamilies.count];
    
    for (NSString * fontFamily in _fontFamilies){
        [_fonts addObject:[UIFont fontNamesForFamilyName:fontFamily]];
    }
    
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    _fontFamilies = [UIFont familyNames];

    _fontFamilies = [_fontFamilies sortedArrayUsingComparator:
                     ^(NSString * obj1, NSString * obj2){
                         return [obj1 compare:obj2];
                     } ];
    _fonts = [NSMutableArray arrayWithCapacity:_fontFamilies.count];

    for (NSString * fontFamily in _fontFamilies){
        [_fonts addObject:[UIFont fontNamesForFamilyName:fontFamily]];
    }

    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

@end