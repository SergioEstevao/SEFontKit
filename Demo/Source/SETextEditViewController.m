//
//  SETextEditViewController.m
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
    NSDictionary * attributes = nil;
    if ( [self.textView respondsToSelector:@selector(setAttributedText:)]){
        if (_editRange.length == 0 ){
            _editRange = NSMakeRange(0, self.textView.attributedText.length);
        }
        attributes = [self.textView.attributedText attributesAtIndex:_editRange.location longestEffectiveRange:NULL inRange:_editRange];
    } else {
        attributes = @{NSFontAttributeName:self.textView.font, NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone), NSStrikethroughStyleAttributeName:@(NSUnderlineStyleNone)};
    }
    textAttributes.delegate = self;
    textAttributes.attributes = attributes;

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
