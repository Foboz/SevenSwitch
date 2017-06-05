//
//  OCSevenSwitch.m
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

#import <QuartzCore/QuartzCore.h>
#import "OCSevenSwitch.h"

@interface OCSevenSwitch ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) UIImageView *onImageView;
@property (nonatomic, strong) UIImageView *offImageView;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic) BOOL isAnimating;
@end

@implementation OCSevenSwitch {
  BOOL switchValue;
  BOOL currentVisualValue;
  BOOL startTrackingValue;
  BOOL didChangeWhileTracking;
  BOOL userDidSpecifyOnThumbTintColor;
}

/*
 *   Initialization
 */
  
- (instancetype)init
{
  self = [super initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
  if (self) {
    [self setup];
  }
  return self;
}
  
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:CGRectIsEmpty(frame) ? CGRectMake(0.0, 0.0, 50.0, 30.0) : frame];
  if (self) {
    [self setup];
  }
  return self;
}
  
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}
  
#pragma mark - Override
  
- (BOOL)isOn
{
  return switchValue;
}
  
- (void)setOn:(BOOL)on
{
  [self setOn:on animated:NO];
}
  
- (void)setActiveColor:(UIColor *)activeColor
{
  if (self.on && !self.isTracking) {
    _backgroundView.backgroundColor = activeColor;
  }
  _activeColor = activeColor;
}
  
- (void)setInactiveColor:(UIColor *)inactiveColor
{
  if (!self.on && !self.isTracking) {
    _backgroundView.backgroundColor = inactiveColor;
  }
  _inactiveColor = inactiveColor;
}
  
- (void)setOnTintColor:(UIColor *)onTintColor
{
  if (self.on && !self.isTracking) {
    _backgroundView.backgroundColor = onTintColor;
  }
  _onTintColor = onTintColor;
}
  
- (void)setBorderColor:(UIColor *)borderColor
{
  if (!self.on) {
    _backgroundView.layer.borderColor = borderColor.CGColor;
  }
  _borderColor = borderColor;
}
  
- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
  if (!userDidSpecifyOnThumbTintColor) {
    _onThumbTintColor = thumbTintColor;
  }
  if ((userDidSpecifyOnThumbTintColor || !self.on) && !self.isTracking) {
    _thumbView.backgroundColor = thumbTintColor;
  }
  _thumbTintColor = thumbTintColor;
}
  
- (void)setOnThumbTintColor:(UIColor *)onThumbTintColor
{
  userDidSpecifyOnThumbTintColor = YES;
  if (self.on && !self.isTracking) {
    _thumbView.backgroundColor = onThumbTintColor;
  }
  _onThumbTintColor = onThumbTintColor;
}
  
- (void)setShadowColor:(UIColor *)shadowColor
{
  _thumbView.layer.shadowColor = shadowColor.CGColor;
  _shadowColor = shadowColor;
}
  
- (void)setRounded:(BOOL)rounded
{
  if (rounded) {
    _backgroundView.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
    _thumbView.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
  } else {
    _backgroundView.layer.cornerRadius = self.cornerRadius;
    _thumbView.layer.cornerRadius = self.cornerRadius;
  }
  _thumbView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
  _rounded = rounded;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
  if (!self.rounded) {
    _backgroundView.layer.cornerRadius = cornerRadius;
    _thumbView.layer.cornerRadius = cornerRadius;
  }
  _cornerRadius = cornerRadius;
}

- (void)setThumbOffset:(CGFloat)thumbOffset
{
  // thumb
  CGRect frame = self.frame;
  CGFloat normalKnobWidth = CGRectGetHeight(frame) - thumbOffset * 2.0;
  if (self.on) {
    _thumbView.frame = CGRectMake(CGRectGetWidth(frame) - (normalKnobWidth + thumbOffset), thumbOffset, CGRectGetHeight(frame) - thumbOffset * 2.0, normalKnobWidth);
    _thumbImageView.frame = CGRectMake(CGRectGetWidth(frame) - normalKnobWidth, 0.0, normalKnobWidth, normalKnobWidth);
  } else {
    _thumbView.frame = CGRectMake(thumbOffset, thumbOffset, normalKnobWidth, normalKnobWidth);
    _thumbImageView.frame = CGRectMake(0.0, 0.0, normalKnobWidth, normalKnobWidth);
  }
  _thumbOffset = thumbOffset;
}

- (void)setThumbImage:(UIImage *)thumbImage
{
  _thumbImageView.image = thumbImage;
  _thumbImage = thumbImage;
}
  
- (void)setOnImage:(UIImage *)onImage
{
  _onImageView.image = onImage;
  _onImage = onImage;
}
  
- (void)setOffImage:(UIImage *)offImage
{
  _offImageView.image = offImage;
  _offImage = offImage;
}
  
#pragma mark - Public
  
/*
 *   Set the state of the switch to on or off, optionally animating the transition.
 */
- (void) setOn:(BOOL)on animated:(BOOL)animated
{
  switchValue = on;
  if (on) {
    [self showOn:animated];
  } else {
    [self showOff:animated];
  }
}
  
#pragma mark - Private
  
- (void) setup
{
  self.activeColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
  self.inactiveColor = [UIColor clearColor];
  self.onTintColor = [UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1.0];
  self.borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0];
  self.shadowColor = [UIColor grayColor];
  self.thumbTintColor = [UIColor whiteColor];
  self.onThumbTintColor = [UIColor whiteColor];
  self.rounded = YES;
  self.cornerRadius = 2.0;
  self.thumbOffset = 1.0;
  
  // background
  self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
  _backgroundView.backgroundColor = [UIColor clearColor];
  _backgroundView.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
  _backgroundView.layer.borderColor = self.borderColor.CGColor;
  _backgroundView.layer.borderWidth = 1.0;
  _backgroundView.userInteractionEnabled = NO;
  _backgroundView.clipsToBounds = YES;
  [self addSubview:_backgroundView];

  // on/off images
  self.onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
  _onImageView.alpha = 1.0;
  _onImageView.contentMode = UIViewContentModeCenter;
  [_backgroundView addSubview:_onImageView];

  self.offImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.frame), 0.0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
  _offImageView.alpha = 1.0;
  _offImageView.contentMode = UIViewContentModeCenter;
  [_backgroundView addSubview:_offImageView];

  // labels
  self.onLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
  _onLabel.textAlignment = NSTextAlignmentCenter;
  _onLabel.textColor = [UIColor lightGrayColor];
  _onLabel.font = [UIFont systemFontOfSize:12.0];
  [_backgroundView addSubview:_onLabel];

  self.offLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.frame), 0.0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
  _offLabel.textAlignment = NSTextAlignmentCenter;
  _offLabel.textColor = [UIColor lightGrayColor];
  _offLabel.font = [UIFont systemFontOfSize:12.0];
  [_backgroundView addSubview:_offLabel];

  // thumb
  self.thumbView = [[UIView alloc] initWithFrame:CGRectMake(self.thumbOffset, self.thumbOffset, CGRectGetHeight(self.frame) - self.thumbOffset * 2.0, CGRectGetHeight(self.frame) - self.thumbOffset * 2.0)];
  _thumbView.backgroundColor = self.thumbTintColor;
  _thumbView.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5 + self.thumbOffset;
  _thumbView.layer.shadowColor = self.shadowColor.CGColor;
  _thumbView.layer.shadowRadius = 2.0;
  _thumbView.layer.shadowOpacity = 0.5;
  _thumbView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
  _thumbView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
  _thumbView.layer.masksToBounds = NO;
  _thumbView.userInteractionEnabled = NO;
  [self addSubview:_thumbView];

  // thumb image
  self.thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_thumbView.frame), CGRectGetHeight(_thumbView.frame))];
  _thumbImageView.contentMode = UIViewContentModeCenter;
  _thumbImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [_thumbView addSubview:_thumbImageView];
  
  self.on = NO;
}
  
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
  [super beginTrackingWithTouch:touch withEvent:event];
  
  startTrackingValue = self.on;
  didChangeWhileTracking = NO;
  
  CGFloat activeKnobWidth = CGRectGetHeight(self.bounds) - self.thumbOffset * 2.0 + 5.0;
  _isAnimating = YES;
  
  [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
    if (self.on) {
      self.thumbView.frame = CGRectMake(CGRectGetWidth(self.bounds) - (activeKnobWidth + self.thumbOffset), CGRectGetMinY(self.thumbView.frame), activeKnobWidth, CGRectGetHeight(self.thumbView.frame));
      self.backgroundView.backgroundColor = self.onTintColor;
      self.thumbView.backgroundColor = self.onThumbTintColor;
    } else {
      self.thumbView.frame = CGRectMake(CGRectGetMinX(self.thumbView.frame), CGRectGetMinY(self.thumbView.frame), activeKnobWidth, CGRectGetHeight(self.thumbView.frame));
      self.backgroundView.backgroundColor = self.activeColor;
      self.thumbView.backgroundColor = self.thumbTintColor;
    }
  } completion:^(BOOL finished) {
    self.isAnimating = NO;
  }];
  
  CABasicAnimation *shadowAnim = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
  shadowAnim.duration = 0.3;
  shadowAnim.fromValue = (id)(_thumbView.layer.presentationLayer.shadowPath);
  shadowAnim.toValue = (id)([UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath);
  shadowAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  _thumbView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
  [_thumbView.layer addAnimation:shadowAnim forKey:@"shadowPath"];
  
  return YES;
}
  
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
  [super continueTrackingWithTouch:touch withEvent:event];
  
  // Get touch location
  CGPoint lastPoint = [touch locationInView:self];

  // update the switch to the correct visuals depending on if
  // they moved their touch to the right or left side of the switch
  if (lastPoint.x > CGRectGetWidth(self.bounds) * 0.5) {
    [self showOn:YES];
    if (!startTrackingValue) {
      didChangeWhileTracking = YES;
    }
  } else {
    [self showOff:YES];
    if (startTrackingValue) {
      didChangeWhileTracking = YES;
    }
  }
  
  return YES;
}
  
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
  [super endTrackingWithTouch:touch withEvent:event];
  
  BOOL previousValue = self.on;

  if (didChangeWhileTracking) {
    [self setOn:currentVisualValue animated:YES];
  } else {
    [self setOn:!self.on animated:YES];
  }

  if (previousValue != self.on) {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
}
  
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
  [super cancelTrackingWithEvent:event];
  
  // just animate back to the original value
  if (self.on) {
    [self showOn:YES];
  } else {
    [self showOff:YES];
  }
}
  
- (void)layoutSubviews
{
  [super layoutSubviews];
  if (!self.isAnimating) {
    CGRect frame = self.frame;

    // background
    _backgroundView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _backgroundView.layer.cornerRadius = self.isRounded ? CGRectGetHeight(frame) * 0.5 : self.cornerRadius;

    // images
    _onImageView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame) - CGRectGetHeight(frame), CGRectGetHeight(frame));
    _offImageView.frame = CGRectMake(CGRectGetHeight(frame), 0.0, CGRectGetWidth(frame) - CGRectGetHeight(frame), CGRectGetHeight(frame));
    self.onLabel.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame) - CGRectGetHeight(frame), CGRectGetHeight(frame));
    self.offLabel.frame = CGRectMake(CGRectGetHeight(frame), 0.0, CGRectGetWidth(frame) - CGRectGetHeight(frame), CGRectGetHeight(frame));

    // thumb
    CGFloat normalKnobWidth = CGRectGetHeight(frame) - self.thumbOffset * 2.0;
    if (self.on) {
      _thumbView.frame = CGRectMake(CGRectGetWidth(frame) - (normalKnobWidth + self.thumbOffset), self.thumbOffset, CGRectGetHeight(frame) - self.thumbOffset * 2.0, normalKnobWidth);
      _thumbImageView.frame = CGRectMake(CGRectGetWidth(frame) - normalKnobWidth, 0.0, normalKnobWidth, normalKnobWidth);
    } else {
      _thumbView.frame = CGRectMake(self.thumbOffset, self.thumbOffset, normalKnobWidth, normalKnobWidth);
      _thumbImageView.frame = CGRectMake(0.0, 0.0, normalKnobWidth, normalKnobWidth);
    }

    _thumbView.layer.cornerRadius = self.isRounded ? CGRectGetHeight(frame) * 0.5 - self.thumbOffset : self.cornerRadius - 1.0;
    _thumbView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
  }
}

/*
 *   update the looks of the switch to be in the on position
 *   optionally make it animated
 */
- (void) showOn:(BOOL)animated
{
  CGFloat normalKnobWidth = CGRectGetHeight(self.bounds) - self.thumbOffset * 2.0;
  CGFloat activeKnobWidth = normalKnobWidth + 5.0;
  if (animated) {
    _isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
      if (self.isTracking) {
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.bounds) - (activeKnobWidth + self.thumbOffset), CGRectGetMinY(self.thumbView.frame), activeKnobWidth, CGRectGetHeight(self.thumbView.frame));
      } else {
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.bounds) - (normalKnobWidth + self.thumbOffset), CGRectGetMinY(self.thumbView.frame), normalKnobWidth, CGRectGetHeight(self.thumbView.frame));
      }
      self.backgroundView.backgroundColor = self.onTintColor;
      self.thumbView.backgroundColor = self.onThumbTintColor;
      self.onImageView.alpha = 1.0;
      self.offImageView.alpha = 0.0;
      self.onLabel.alpha = 1.0;
      self.offLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
      self.isAnimating = NO;
    }];
  
    CABasicAnimation *shadowAnim = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowAnim.duration = 0.3;
    shadowAnim.fromValue = (id)(_thumbView.layer.presentationLayer.shadowPath);
    shadowAnim.toValue = (id)[UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
    [_thumbView.layer addAnimation:shadowAnim forKey:@"shadowPath"];
    _thumbView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
  } else {
    if (self.isTracking) {
      self.thumbView.frame = CGRectMake(CGRectGetWidth(self.bounds) - (activeKnobWidth + self.thumbOffset), CGRectGetMinY(self.thumbView.frame), activeKnobWidth, CGRectGetHeight(self.thumbView.frame));
    } else {
      self.thumbView.frame = CGRectMake(CGRectGetWidth(self.bounds) - (normalKnobWidth + self.thumbOffset), CGRectGetMinY(self.thumbView.frame), normalKnobWidth, CGRectGetHeight(self.thumbView.frame));
    }

    _backgroundView.backgroundColor = self.onTintColor;
    _thumbView.backgroundColor = self.onThumbTintColor;
    _onImageView.alpha = 1.0;
    _offImageView.alpha = 0.0;
    _onLabel.alpha = 1.0;
    _offLabel.alpha = 0.0;
  }
  
  currentVisualValue = YES;
}
  
- (void) showOff:(BOOL)animated
{
  CGFloat normalKnobWidth = CGRectGetHeight(self.bounds) - self.thumbOffset * 2.0;
  CGFloat activeKnobWidth = normalKnobWidth + 5.0;
  
  if (animated) {
    _isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
      if (self.isTracking) {
        self.thumbView.frame = CGRectMake(self.thumbOffset, CGRectGetMinY(self.thumbView.frame), activeKnobWidth, CGRectGetHeight(self.thumbView.frame));
        self.backgroundView.backgroundColor = self.activeColor;
      } else {
        self.thumbView.frame = CGRectMake(self.thumbOffset, CGRectGetMinY(self.thumbView.frame), normalKnobWidth, CGRectGetHeight(self.thumbView.frame));
        self.backgroundView.backgroundColor = self.inactiveColor;
      }
      
      self.backgroundView.layer.borderColor = self.borderColor.CGColor;
      self.thumbView.backgroundColor = self.thumbTintColor;
      self.onImageView.alpha = 0.0;
      self.offImageView.alpha = 1.0;
      self.onLabel.alpha = 0.0;
      self.offLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
      self.isAnimating = NO;
    }];

    CABasicAnimation *shadowAnim = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowAnim.duration = 0.3;
    shadowAnim.fromValue = (id)(_thumbView.layer.presentationLayer.shadowPath);
    shadowAnim.toValue = (id)[UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
    [_thumbView.layer addAnimation:shadowAnim forKey:@"shadowPath"];
    _thumbView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_thumbView.bounds cornerRadius:_thumbView.layer.cornerRadius].CGPath;
  } else {
    if (self.isTracking) {
      self.thumbView.frame = CGRectMake(self.thumbOffset, CGRectGetMinY(self.thumbView.frame), activeKnobWidth, CGRectGetHeight(self.thumbView.frame));
      self.backgroundView.backgroundColor = self.activeColor;
    } else {
      self.thumbView.frame = CGRectMake(self.thumbOffset, CGRectGetMinY(self.thumbView.frame), normalKnobWidth, CGRectGetHeight(self.thumbView.frame));
      self.backgroundView.backgroundColor = self.inactiveColor;
    }
    _backgroundView.layer.borderColor = self.borderColor.CGColor;
    _thumbView.backgroundColor = self.thumbTintColor;
    _onImageView.alpha = 0.0;
    _offImageView.alpha = 1.0;
    _onLabel.alpha = 0.0;
    _offLabel.alpha = 1.0;
  }
  
  currentVisualValue = NO;
}

@end
