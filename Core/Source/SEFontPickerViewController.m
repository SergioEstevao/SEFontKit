//
//  SEFontPickViewController.m
//  SEFontKit
//
//  Created by Sergio Estevao on 19/11/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SEFontPickerViewController.h"

@interface SEFontPickerViewController () {
    NSArray *_fontFamilies;
    NSMutableArray *_fonts;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar * searchBar;
@end

@implementation SEFontPickerViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,44,320,480)];
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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"Search Font";
    [self.view addSubview:self.searchBar];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *object = [[_fonts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIFont * font = [UIFont fontWithName:object size:[UIFont systemFontSize]];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(fontPickerViewController:selectedFont:)]){
        [self.delegate fontPickerViewController:self selectedFont:font];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Search Bar

- (void)searchFont:(NSString *)searchText {
    if( searchText.length > 0) {
        NSPredicate * predicate = [NSPredicate
                                   predicateWithFormat:@"(%K CONTAINS[cd] %@)", @"description",
                                   searchText];
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

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchFont:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchFont:searchBar.text];
    [searchBar resignFirstResponder];
}

	

@end
