//
//  SEFontMetrics.h
//  FontMetrics
//
//  Created by Sergio Estevao on 18/07/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

/** A extension to UITextField that allows to see the metrics of the font being used.

This view displays reference values for the following values:

- BaseLine:
- Ascender: The top y-coordinate, offset from the baseline, of the receiver’s longest ascender.
- Descender: The bottom y-coordinate, offset from the baseline, of the receiver’s longest descender.
- Cap Height: This value measures (in points) the maximum height of a capital character.
- X Height: This value measures (in points) the height of the lowercase character "x".
*/

@interface SEFontMetricsView : UITextField

@property (strong, nonatomic) UIFont * font;
@property (strong, nonatomic) UIColor * baseLineColor;
@property (strong, nonatomic) UIColor * ascenderColor;
@property (strong, nonatomic) UIColor * descenderColor;
@property (strong, nonatomic) UIColor * capColor;
@property (strong, nonatomic) UIColor * xColor;
@end
