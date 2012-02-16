//
//  ADN_NewsViewController.h
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNewsCellImageViewTag   3000
#define kNewsCellTitleTag       3001
#define kNewsCellDescriptionTag 3002
#define kNewsCellDateTag        3003

@interface ADN_NewsViewController : UIViewController
{
    UITableView* tableView;
    NSArray* details;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
