//
//  DetailViewController.h
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADN_DetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) IBOutlet UIWebView* webView;

- (IBAction)closeDetail:(id)sender;

@end
