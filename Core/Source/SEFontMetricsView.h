//
//  SEFontMetricsView.h
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
