//
//  SEFontAnalyser.m
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

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
