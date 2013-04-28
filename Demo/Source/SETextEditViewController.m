//
//  SETextEditViewController.m
//  SEFontKit
//
//  Created by Sergio Estevao on 18/11/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SETextEditViewController.h"
#import "SETextAttributesPickerViewController.h"

@interface SETextEditViewController () {
    NSRange _editRange;
}
@property (nonatomic,strong) UIPopoverController * popOver;
@property (nonatomic,strong) IBOutlet UITextView * textView;
@end

@implementation SETextEditViewController

- (id)init
{
    self = [super initWithNibName:@"SETextEditViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Style Editor";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editorClick:)];
    if ( [self.textView respondsToSelector:@selector(setAttributedText:)]){
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) editorClick:(id)sender {
    
    _editRange = self.textView.selectedRange;
    SETextAttributesPickerViewController * textAttributes = [[SETextAttributesPickerViewController alloc] init];
    if ( [self.textView respondsToSelector:@selector(setAttributedText:)]){
        if (_editRange.length == 0 && _editRange.location == INT32_MAX){
            _editRange = NSMakeRange(0, self.textView.attributedText.length);
        }        
        textAttributes.delegate = self;
        textAttributes.attributes = [self.textView.attributedText attributesAtIndex:_editRange.location longestEffectiveRange:NULL inRange:_editRange];
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPad && self.popOver == nil ){
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:textAttributes];
        [self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popOver.delegate = self;
        
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:textAttributes animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popOver = nil;
}

- (void) textAttributesPickerViewController:(SETextAttributesPickerViewController*) fontPicker selectedAttributes:(NSDictionary*)attributes {
    
    if ( [self.textView respondsToSelector:@selector(setAttributedText:)]){
        NSMutableAttributedString * newText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        [newText setAttributes:attributes range:_editRange];

        self.textView.attributedText = newText;
    }
}

@end
