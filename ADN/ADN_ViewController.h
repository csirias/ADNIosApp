//
//  ADN_ViewController.h
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADN_ViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
