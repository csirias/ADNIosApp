//
//  RoundedActivityIndicator.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/16/10.
//  Modified by Bryan Henry on 11/16/11

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
//
//

#import "RoundedActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "UIApplication+Windows.h"

@interface RoundedActivityIndicator ()
- (void)setRotation:(UIInterfaceOrientation)orientation animation:(BOOL)animated;
@end

@implementation RoundedActivityIndicator {
  UILabel *centerMessageLabel;
  UILabel *subMessageLabel;
  UIActivityIndicatorView *spinner;
  
  UIWindow *alertWindow;
  UIWindow *previousKeyWindow;
}

static RoundedActivityIndicator *currentIndicator = nil;
+ (RoundedActivityIndicator *)currentIndicator {
  if (currentIndicator == nil) {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGFloat width = 160 * 2;
    CGFloat height = 160 * 2;
    CGRect centeredFrame = CGRectMake(floor(frame.size.width / 2 - width / 2),
                                      floor(frame.size.height / 2 - height / 2),
                                      width,
                                      height);

    currentIndicator = [[RoundedActivityIndicator alloc] initWithFrame:centeredFrame];

    currentIndicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    currentIndicator.opaque = NO;
    currentIndicator.alpha = 0;

    currentIndicator.layer.cornerRadius = 10;

    currentIndicator.userInteractionEnabled = NO;
    currentIndicator.autoresizesSubviews = YES;
    currentIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;

    [currentIndicator setProperRotationAnimated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:currentIndicator
                                             selector:@selector(willChangeOrientation:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
  }

  return currentIndicator;
}

#pragma mark -

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

#pragma mark Creating Message

- (void)show {
  if (!alertWindow) {
    previousKeyWindow = [[UIApplication sharedApplication] frontmostNormalWindow];
    alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.backgroundColor = [UIColor clearColor];
    alertWindow.windowLevel = UIWindowLevelNormal + 1;
    [alertWindow addSubview:self];
    [alertWindow makeKeyAndVisible];
  }

  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];

  [UIView animateWithDuration:0.2 animations:^{
    self.alpha = 1;
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGFloat width = self.frame.size.width / 2;
    CGFloat height = self.frame.size.height / 2;
    CGRect centeredFrame = CGRectMake(floor(frame.size.width / 2 - width / 2),
                                      floor(frame.size.height / 2 - height / 2),
                                      width,
                                      height);
    self.frame = centeredFrame;
  }];
}

- (void)hideAfterDelay:(NSTimeInterval)delay {
  [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)hide {
  [UIView animateWithDuration:0.6 animations:^{
    self.alpha = 0;
  } completion:^(BOOL finished) {
    if (currentIndicator.alpha > 0) {
      return;
    }
    
    [currentIndicator removeFromSuperview];
    [previousKeyWindow makeKeyWindow];
    alertWindow = nil;
    currentIndicator = nil;
  }];
}

- (void)persist {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];

  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    self.alpha = 1;
  } completion:NULL];
}

- (void)showSpinnerAndMessage:(id)m {
  [self setSubMessage:m];
  [self showSpinner];
}

- (void)displayActivity:(NSString *)m {
  //[self setSubMessage:m];
  //[self showSpinner];

  [centerMessageLabel removeFromSuperview];
  centerMessageLabel = nil;

  if ([self superview] == nil) {
    [self show];
  } else {
    [self persist];
  }

  [self performSelector:@selector(showSpinnerAndMessage:) withObject:m afterDelay:0.2];
}

- (void)displayCompleted:(NSString *)m {
  [spinner removeFromSuperview];
  spinner = nil;

  [self setCenterMessage:@"✓"];
  centerMessageLabel.alpha = 1.0;
  [self setSubMessage:m];

  if ([self superview] == nil) {
    [self show];
  } else {
    [self persist];
  }

  [self hideAfterDelay:0.6];
}

- (void)displayFailed:(NSString *)m {
  [spinner removeFromSuperview];
  spinner = nil;
  
  [self setCenterMessage:@"✕"];
  centerMessageLabel.alpha = 1.0;
  [self setSubMessage:m];
  
  if ([self superview] == nil) {
    [self show];
  } else {
    [self persist];
  }

  [self hideAfterDelay:0.6];
}

- (void)setCenterMessage:(NSString *)message {
  if (message == nil && centerMessageLabel != nil) {
    centerMessageLabel = nil;
  } else if (message != nil) {
    if (centerMessageLabel == nil) {
      centerMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, round(self.bounds.size.height / 2 - 50 / 2), self.bounds.size.width - 24, 50)];
      centerMessageLabel.backgroundColor = [UIColor clearColor];
      centerMessageLabel.opaque = NO;
      centerMessageLabel.alpha = 0;
      centerMessageLabel.textColor = [UIColor whiteColor];
      centerMessageLabel.font = [UIFont boldSystemFontOfSize:40];
      centerMessageLabel.textAlignment = UITextAlignmentCenter;
      centerMessageLabel.shadowColor = [UIColor lightGrayColor];
      centerMessageLabel.shadowOffset = CGSizeMake(1, 1);
      centerMessageLabel.adjustsFontSizeToFitWidth = YES;

      [self addSubview:centerMessageLabel];
    }

    [spinner stopAnimating];
    centerMessageLabel.text = message;
  }
}

- (void)setSubMessage:(NSString *)message {
  if (message == nil && subMessageLabel != nil) {
    subMessageLabel = nil;
  } else if (message != nil) {
    if (subMessageLabel == nil) {
      subMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.bounds.size.height - 45, self.bounds.size.width - 24, 30)];
      subMessageLabel.backgroundColor = [UIColor clearColor];
      subMessageLabel.opaque = NO;
      subMessageLabel.textColor = [UIColor whiteColor];
      subMessageLabel.font = [UIFont boldSystemFontOfSize:17];
      subMessageLabel.textAlignment = UITextAlignmentCenter;
      subMessageLabel.shadowColor = [UIColor lightGrayColor];
      subMessageLabel.shadowOffset = CGSizeMake(1, 1);
      subMessageLabel.adjustsFontSizeToFitWidth = YES;

      [self addSubview:subMessageLabel];
    }

    subMessageLabel.text = message;
  }
}

- (void)showSpinner {
  if (spinner == nil) {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    spinner.frame = CGRectMake(round(self.bounds.size.width / 2 - spinner.frame.size.width / 2),
                               round(self.bounds.size.height / 2 - spinner.frame.size.height / 2),
                               spinner.frame.size.width,
                               spinner.frame.size.height);
    spinner.hidesWhenStopped = YES;
  }

  [self addSubview:spinner];
  [spinner startAnimating];
}

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation {
  [self setProperRotationAnimated:YES];
}

- (void)setProperRotationAnimated:(BOOL)animated {
  UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
  [self setRotation:orientation animation:animated];
}

- (void)setRotation:(UIInterfaceOrientation)orientation animation:(BOOL)animated {
  [UIView animateWithDuration:(animated) ? 0.3 : 0.0 animations:^{
    CGFloat rotateDegrees = 0;
    switch (orientation) {
      case UIInterfaceOrientationPortrait:            rotateDegrees =   0; break;
      case UIInterfaceOrientationPortraitUpsideDown:  rotateDegrees = 180; break;
      case UIInterfaceOrientationLandscapeLeft:       rotateDegrees = -90; break;
      case UIInterfaceOrientationLandscapeRight:      rotateDegrees =  90; break;
    }
    
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotateDegrees/180.0 * M_PI);
  }];
}

- (void)willChangeOrientation:(NSNotification *)notif {
  NSDictionary *userInfo = [notif userInfo];
  UIInterfaceOrientation orientation = [[userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey] intValue];
  [self setRotation:orientation animation:YES];
}

@end