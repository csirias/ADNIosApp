//
//  ADN_NewsViewController.h
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyTableView.h"
#import "AudioStreamer.h"

#define kNewsCellImageViewTag           3000
#define kNewsCellTitleTag               3001
#define kNewsCellDescriptionTag         3002
#define kNewsCellDateTag                3003
#define kNewsCellWebviewTag             3004
#define kNewsCellHorizontalTableViewTag 4000

@interface ADN_NewsViewController : UIViewController <EasyTableViewDelegate>
{
    UITableView* tableView;
    NSArray* details;
    AudioStreamer* streamer;
    EasyTableView* easyTableView[4];
}

@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UILabel* dateLabel;
@property (nonatomic, strong) IBOutlet UILabel* radioStatusLabel;

- (IBAction)startListening:(id)sender;

@end
