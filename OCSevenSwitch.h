//
//  OCSevenSwitch.h
//  SevenSwitchExample
//
//  Created by Mikhail Nikanorov on 05/06/2017.
//  Copyright © 2017 Mikhail Nikanorov. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface OCSevenSwitch : UIControl
#pragma mark - Public
/*
 *   Set (without animation) whether the switch is on or off
 */
@property (nonatomic, getter=isOn) IBInspectable BOOL on;
/*
 *	Sets the background color that shows when the switch off and actively being touched.
 *   Defaults to light gray.
 */
@property (nonatomic, strong) IBInspectable UIColor *activeColor;
/*
 *	Sets the background color when the switch is off.
 *   Defaults to clear color.
 */
@property (nonatomic, strong) IBInspectable UIColor *inactiveColor;
/*
 *   Sets the background color that shows when the switch is on.
 *   Defaults to green.
 */
@property (nonatomic, strong) IBInspectable UIColor *onTintColor;
/*
 *   Sets the border color that shows when the switch is off. Defaults to light gray.
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/*
 *	Sets the knob color. Defaults to white.
 */
@property (nonatomic, strong) IBInspectable UIColor *thumbTintColor;
/*
 *	Sets the knob color that shows when the switch is on. Defaults to white.
 */
@property (nonatomic, strong) IBInspectable UIColor *onThumbTintColor;
/*
 *	Sets the shadow color of the knob. Defaults to gray.
 */
@property (nonatomic, strong) IBInspectable UIColor *shadowColor;
/*
 *	Sets whether or not the switch edges are rounded.
 *   Set to NO to get a stylish square switch.
 *   Defaults to YES.
 */
@property (nonatomic, getter=isRounded) IBInspectable BOOL rounded;
/*
 *  Using while rounded is NO to control cornerRadius
 *  Default is 2.0
 */
@property (nonatomic) IBInspectable CGFloat cornerRadius;
/*
 *  Offset between control border and thumb border. Also used as cornerRadius of thumb
 *  Default is 1.0
 */
@property (nonatomic) IBInspectable CGFloat thumbOffset;
/*
 *   Sets the image that shows on the switch thumb.
 */
@property (nonatomic, strong) IBInspectable UIImage *thumbImage;
/*
 *   Sets the image that shows when the switch is on.
 *   The image is centered in the area not covered by the knob.
 *   Make sure to size your images appropriately.
 */
@property (nonatomic, strong) IBInspectable UIImage *onImage;
/*
 *	Sets the image that shows when the switch is off.
 *   The image is centered in the area not covered by the knob.
 *   Make sure to size your images appropriately.
 */
@property (nonatomic, strong) IBInspectable UIImage *offImage;
/*
 *	Sets the text that shows when the switch is on.
 *   The text is centered in the area not covered by the knob.
 */
@property (nonatomic, strong) UILabel *onLabel;
/*
 *	Sets the text that shows when the switch is off.
 *   The text is centered in the area not covered by the knob.
 */
@property (nonatomic, strong) UILabel *offLabel;
- (void) setOn:(BOOL)on animated:(BOOL)animated;
@end
