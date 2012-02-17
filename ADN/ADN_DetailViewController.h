//
//  DetailViewController.h
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADN_DetailViewController : UIViewController <UIScrollViewDelegate>
{
    NSDictionary* details;
    CGPoint savedOffset;
}

@property (nonatomic, retain) NSDictionary* details;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@end
