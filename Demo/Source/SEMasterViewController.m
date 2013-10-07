//
//  SEMasterViewController.m
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

#import "SEMasterViewController.h"
#import "NSString+SEExtension.h"
#import "SEDetailViewController.h"
#import "UIFont+SEExtensions.h"
#import "SEFontManager.h"

@interface SEMasterViewController () {
    NSMutableArray *_fontFamilies;
    NSMutableArray *_fonts;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SEMasterViewController


- (void) loadView {
    self.view = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), self.view.bounds.size.width, self.view.bounds.size.height-self.searchBar.frame.size.height)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Fonts", @"Fonts");
    
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //        //self.clearsSelectionOnViewWillAppear = NO;
    //        self.contentSizeForViewInPopover = CGSizeMake(320.0, self.view.frame.size.height);
    //    }
    [self searchFont:@""];
}

- (void) viewWillLayoutSubviews {
    self.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    UIScrollView * scrollView = (UIScrollView*)self.view;
    CGFloat extra = scrollView.contentInset.top+scrollView.contentInset.bottom;
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), self.view.bounds.size.width, self.view.frame.size.height-self.searchBar.frame.size.height-extra);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.tableView.editing = editing;
    if ( editing){
        [self searchUserFonts:@""];
        self.searchBar.placeholder = @"Enter an url to load a font";
        self.searchBar.keyboardType = UIKeyboardTypeURL;
    } else {
        [self searchFont:@""];
        self.searchBar.placeholder = @"Search font";
        self.searchBar.keyboardType = UIKeyboardTypeDefault;
    }
    
}

#pragma mark - Table View

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_fontFamilies count] == 0){
        return 1;
    }
    return _fontFamilies.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_fontFamilies count] == 0) return 0;
    return [[_fonts objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_fontFamilies count] == 0){
        if ([self.tableView isEditing]){
            return @"No custom fonts loaded.\nProvide an URL for a font and press Search.";
        } else {
            return @"No fonts available with that criteria.";
        }
    }
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[SEDetailViewController alloc] init];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontName = [[_fonts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[SEFontManager sharedFontManager] isUserFont:fontName]){
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *fontName = [[_fonts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [[SEFontManager sharedFontManager] removeFontByName:fontName];
        [self searchFont:self.searchBar.text];
    }
}

- (void) findFont:(NSString *) fontName {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self setEditing:NO animated:NO];
    [self searchFont:@""];
    int section = 0;
    NSUInteger row = NSNotFound;
    for (NSArray * fonts in _fonts){
        row = [fonts indexOfObject:fontName];
        if (row != NSNotFound) break;
        section++;
    }
    
    if (row == NSNotFound) return;
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

#pragma mark - Search Bar

- (void)searchFont:(NSString *)searchText {
    if( searchText.length > 0) {
        NSPredicate * predicate = [NSPredicate
                                   predicateWithFormat:@"(%K CONTAINS[cd] %@)", @"description",
                                   searchText];
        _fontFamilies = [NSMutableArray arrayWithArray:[[UIFont familyNames] filteredArrayUsingPredicate:predicate]];
    } else {
        _fontFamilies = [NSMutableArray arrayWithArray:[UIFont familyNames]];
    }
    
    [_fontFamilies sortUsingSelector:@selector(compare:)];
    
    _fonts = [NSMutableArray arrayWithCapacity:_fontFamilies.count];
    
    for (NSString * fontFamily in _fontFamilies){
        [_fonts addObject:[UIFont fontNamesForFamilyName:fontFamily]];
    }
    
    [self.tableView reloadData];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ( !self.editing){
        [self searchFont:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString * searchText = searchBar.text;
    if (self.editing){
        NSURL * url = [NSURL URLWithString:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if (!url) {
            UIAlertView * message = [[UIAlertView alloc] initWithTitle:@"Font Loading"
                                                               message:[NSString stringWithFormat:@"Problems loading font:%@", @"Invalid URL"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [message show];
            return;
        }
        NSError * error = nil;
        [[SEFontManager sharedFontManager] addFontFromURL:url error:&error];
        if (error){
            UIAlertView * message = [[UIAlertView alloc] initWithTitle:@"Font Loading"
                                                               message:[NSString stringWithFormat:@"Problems loading font:%@", [error localizedDescription]]
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [message show];
        } else {
            UIAlertView * message = [[UIAlertView alloc] initWithTitle:@"Font Loading"
                                                               message:@"Font added sucessfully."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [message show];
            [self searchUserFonts:@""];
        }
    } else {
        [self searchFont:searchBar.text];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self searchFont:@""];
}

- (void)searchUserFonts:(NSString *)searchText {
    _fontFamilies = [NSMutableArray array];
    _fonts = [NSMutableArray array];
    
    NSMutableArray * fontFamilies = [NSMutableArray arrayWithArray:[UIFont familyNames]];
    [fontFamilies sortUsingSelector:@selector(compare:)];
    for (NSString * fontFamily in fontFamilies){
        NSMutableArray * fonts = [NSMutableArray arrayWithArray:[UIFont fontNamesForFamilyName:fontFamily]];
        NSMutableArray * resultArray = [NSMutableArray array];
        for (NSString * font in fonts){
            if ([[SEFontManager sharedFontManager] isUserFont:font]){
                [resultArray addObject:font];
            }
        }
        if ( resultArray.count > 0){
            [_fontFamilies addObject:fontFamily];
            [_fonts addObject:resultArray];
        }
    }
    
    [self.tableView reloadData];
    
}

@end
