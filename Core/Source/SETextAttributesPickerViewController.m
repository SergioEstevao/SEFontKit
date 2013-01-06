//
//  SETextAttributesPickerViewController.h.m
//  SEFontKit
//
//  Created by Sergio Estevao on 18/11/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SETextAttributesPickerViewController.h"
#import "SEFontPickerViewController.h"

const NSInteger SE_MaxFontSize = 60;
const NSInteger SE_MinFontSize = 8;

@interface SETextAttributesPickerViewController () <SEFontPickerViewControllerDelegage>

@property  (strong, nonatomic) IBOutlet UITableViewCell * fontFamilyCell;
@property  (strong, nonatomic) IBOutlet UITableViewCell * fontSizeCell;
@property  (strong, nonatomic) IBOutlet UITableViewCell * fontTraitsStrokeCell;
@property  (strong, nonatomic) IBOutlet UITableViewCell * fontTraitsUnderlineCell;
@property  (strong, nonatomic) IBOutlet UILabel * fontSize;
@property  (strong, nonatomic) IBOutlet UISegmentedControl * fontSizeSegment;
@property  (strong, nonatomic) IBOutlet UITableView * tableView;

@property  (strong, nonatomic) UIFont * font;

@end

@implementation SETextAttributesPickerViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    
    _font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.view addSubview:self.tableView];
    
    self.fontFamilyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontFamily"];
    self.fontFamilyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.fontFamilyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.fontSizeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontSize"];
    [self.fontSizeCell.contentView addSubview: self.fontSize];
    self.fontSizeSegment = [[UISegmentedControl alloc] initWithItems:@[@"-",@"+"]];
    self.fontSizeSegment.momentary = YES;
    [self.fontSizeSegment addTarget:self action:@selector(sizeChanged:) forControlEvents:UIControlEventValueChanged];
    self.fontSizeCell.accessoryView = self.fontSizeSegment;
    self.fontSizeCell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    self.fontTraitsStrokeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontTraitsStroke"];
    self.fontTraitsStrokeCell.textLabel.text = @"Stroke";
    self.fontTraitsStrokeCell.accessoryType = UITableViewCellAccessoryNone;
    self.fontTraitsStrokeCell.selectionStyle = UITableViewCellSelectionStyleNone;

    self.fontTraitsUnderlineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontTraitsUnderline"];
    self.fontTraitsUnderlineCell.textLabel.text = @"Underline";
    self.fontTraitsUnderlineCell.accessoryType = UITableViewCellAccessoryNone;
    self.fontTraitsUnderlineCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView {
    self.font = [self.attributes objectForKey:NSFontAttributeName];
    if ( self.font == nil){
        self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    self.fontFamilyCell.textLabel.text = self.font.fontName;
    self.fontSizeCell.textLabel.text = [NSString stringWithFormat:@"Size: %i pt", (int)_font.pointSize ];
    
    self.fontTraitsUnderlineCell.accessoryType = [self.attributes objectForKey:NSUnderlineStyleAttributeName] == nil ? UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
    
    self.fontTraitsStrokeCell.accessoryType = [self.attributes objectForKey:NSStrikethroughStyleAttributeName] == nil ? UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
}

- (void)updateAttributes {
    NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:self.attributes];
    [attributes setObject:self.font forKey:NSFontAttributeName];
    
    if ( self.fontTraitsUnderlineCell.accessoryType == UITableViewCellAccessoryCheckmark){
        [attributes setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    } else {
        [attributes removeObjectForKey:NSUnderlineStyleAttributeName];
    }
    
    if ( self.fontTraitsStrokeCell.accessoryType == UITableViewCellAccessoryCheckmark){
        [attributes setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
    } else {
        [attributes removeObjectForKey:NSStrikethroughStyleAttributeName];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textAttributesPickerViewController:selectedAttributes:)]){
        [self.delegate textAttributesPickerViewController:self selectedAttributes:attributes];
    }
    self.attributes = attributes;
    [self refreshView];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:            
                return self.fontFamilyCell;
                break;
            case 1:
                return self.fontSizeCell;
                break;
            case 2:
                return self.fontTraitsStrokeCell;
                break;
            case 3:
                return self.fontTraitsUnderlineCell;
                break;
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Font Style";
            break;
        default:
            return nil;
            break;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section){
        case(0):
            switch (indexPath.row) {
                case(0):{
                        SEFontPickerViewController * fp = [[SEFontPickerViewController alloc] init];
                        fp.modalPresentationStyle = UIModalPresentationCurrentContext;
                        fp.delegate = self;
                        [self presentViewController:fp animated:YES completion:nil];
                        [tableView deselectRowAtIndexPath:indexPath animated:NO];
                    }
                    break;
                case(2):
                case(3):{
                    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
                    [self updateAttributes];
                }
                    break;
            }
            break;
    }
    
}

#pragma mark - fontPickerViewControllerDelegate

- (void) fontPickerViewController:(SEFontPickerViewController*) fontPicker selectedFont:(UIFont*)font{
    self.font = [UIFont fontWithName:font.fontName size:self.font.pointSize];
    [self updateAttributes];
}

#pragma mark - size button actions

- (IBAction)sizeChanged:(UISegmentedControl*)sender {
    NSInteger change = 0;
    CGFloat fontSize = [self.font pointSize];
    
    if ( [sender selectedSegmentIndex] == 0){
        change = -1;
    }
    if ( [sender selectedSegmentIndex] == 1){
        change = +1;
    }
    fontSize += change;
    
    if ( fontSize > SE_MaxFontSize){
        fontSize = SE_MaxFontSize;
    }
    
    if ( fontSize < SE_MinFontSize){
        fontSize = SE_MinFontSize;
    }
    
    self.font = [UIFont fontWithName:self.font.fontName size:fontSize];
    [self updateAttributes];
}

@end