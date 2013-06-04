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
#import "UIFont+SEExtensions.h"
#import "SEFontManager.h"

@interface SEMasterViewController () {
    NSMutableArray *_fontFamilies;
    NSMutableArray *_fonts;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation SEMasterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
        
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Fonts", @"Fonts");
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [self searchFont:@""];
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
    if ([self.tableView isEditing]){
        self.messageLabel.text = @"No custom fonts loaded.\nProvide an URL for a font and press Search.";
    } else {
        self.messageLabel.text = @"No fonts available with that criteria.";
    }
    if ([_fontFamilies count] == 0){
        [self.view bringSubviewToFront:self.messageLabel];
        [tableView setBackgroundColor:[UIColor colorWithWhite:0.88 alpha:1]];
    } else {
        [self.view sendSubviewToBack:self.messageLabel];
        [tableView setBackgroundColor:[UIColor whiteColor]];
    }
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
