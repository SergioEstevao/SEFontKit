//
//  SEFontMetricsView.m
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

#import "SEFontMetricsView.h"

@implementation SEFontMetricsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupColors];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self){
        [self setupColors];
    }
    return self;
}

- (void) setupColors {
    // Initialization code
    self.ascenderColor = [UIColor redColor];
    self.descenderColor = [UIColor greenColor];
    self.baseLineColor = [UIColor lightGrayColor];
    self.capColor = [UIColor purpleColor];
    self.xColor = [UIColor blueColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext ();
    
    CGFloat baseLine = self.font.lineHeight + self.font.descender -1.0f;
    CGFloat ascender = ceilf(baseLine -  self.font.ascender);
    CGFloat descender = ceilf(baseLine - self.font.descender);
    CGFloat capHeight = ceilf(baseLine -  self.font.capHeight);
    CGFloat xHeight = ceilf(baseLine - self.font.xHeight);
    baseLine = ceilf(baseLine);
    //baseLine
    CGContextMoveToPoint(context, 0, baseLine);
    CGContextAddLineToPoint(context, self.frame.size.width, baseLine);
    CGContextSetStrokeColorWithColor(context, self.baseLineColor.CGColor);
    CGContextStrokePath(context);
    
    //ascender
    CGContextMoveToPoint(context, 0, ascender);
    CGContextAddLineToPoint(context, self.frame.size.width, ascender);
	CGContextSetStrokeColorWithColor(context, self.ascenderColor.CGColor);
    CGContextStrokePath(context);
    
    //descender
    CGContextMoveToPoint(context, 0, descender);
    CGContextAddLineToPoint(context, self.frame.size.width, descender);    
	CGContextSetStrokeColorWithColor(context, self.descenderColor.CGColor);
	CGContextStrokePath(context);
    
    //caps
    CGContextMoveToPoint(context, 0, capHeight);
    CGContextAddLineToPoint(context, self.frame.size.width, capHeight);
	CGContextSetStrokeColorWithColor(context, self.capColor.CGColor);
    CGContextStrokePath(context);
    
    //x
    CGContextMoveToPoint(context, 0, xHeight);
    CGContextAddLineToPoint(context, self.frame.size.width, xHeight);    
	CGContextSetStrokeColorWithColor(context, self.xColor.CGColor);
	CGContextStrokePath(context);
}


@end
