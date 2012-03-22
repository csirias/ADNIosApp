//
//  UIApplication+Windows.m
//  ADN
//
//  Created by Jeremy Tregunna on 12-03-22.
//  Copyright (c) 2012 Jeremy Tregunna. All rights reserved.
//

#import "UIApplication+Windows.h"

@implementation UIApplication (Windows)

- (UIWindow*)frontmostNormalWindow
{
    UIWindow* frontmostNormalWindow = nil;
    if([[UIApplication sharedApplication] keyWindow].windowLevel == UIWindowLevelNormal)
        frontmostNormalWindow = [[UIApplication sharedApplication] keyWindow];
    else
    {
        NSArray* appWindows = [[UIApplication sharedApplication] windows];
        for(UIWindow *window in [appWindows reverseObjectEnumerator])
        {
            if(window.windowLevel == UIWindowLevelNormal)
            {
                frontmostNormalWindow = window;
                break;
            }
        }
    }

    return frontmostNormalWindow;
}

@end
