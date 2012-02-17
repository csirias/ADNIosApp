//
//  DetailViewController.m
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADN_DetailViewController.h"
#import "ADN_NewsViewController.h"

@interface ADN_DetailViewController ()
- (void)resizeSubviews;
@end

@implementation ADN_DetailViewController

@synthesize details, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    NSString* title = [self.details objectForKey:@"title"];
    UILabel* titleLabel = (UILabel*)[self.view viewWithTag:kNewsCellTitleTag];
    [titleLabel setText:title];

    UILabel* dateLabel = (UILabel*)[self.view viewWithTag:kNewsCellDateTag];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [f setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate* date = [f dateFromString:[self.details objectForKey:@"date"]];
    [f setDateFormat:@"EEEE e 'de' MMMM 'del' yyyy"];
    //[f setDateFormat:@"h':'mm a' - 'dd/MM/yyyy"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    dateLabel.text = [f stringFromDate:date];

    [self resizeSubviews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resizeSubviews];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - Resizing subviews


- (void)resizeSubviews
{
    UILabel* titleLabel = (UILabel*)[self.view viewWithTag:kNewsCellTitleTag];
    UILabel* dateLabel = (UILabel*)[self.view viewWithTag:kNewsCellDateTag];
    UITextView* descTextView = (UITextView*)[self.view viewWithTag:kNewsCellWebviewTag];
    CGSize totalSize = CGSizeZero;

    totalSize.width = self.view.frame.size.width;

    // Size the title to the proper size.
    // TODO: Generalize this into a separate method.
    CGRect frame = [titleLabel frame];
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font
                              constrainedToSize:CGSizeMake(frame.size.width, 9999)
                                  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = size.height;
    [titleLabel setFrame:frame];
    totalSize.height += size.height + dateLabel.frame.size.height;
    
    descTextView.text = [self.details objectForKey:@"desc"];
    frame = [descTextView frame];
    size = [descTextView.text sizeWithFont:descTextView.font
                         constrainedToSize:CGSizeMake(frame.size.width, 9999)
                             lineBreakMode:UILineBreakModeWordWrap];
    totalSize.height += size.height + 8;
    frame.size.height = size.height + 8;
    frame.origin.y = dateLabel.frame.size.height + titleLabel.frame.size.height;
    [descTextView setFrame:frame];
    NSLog(@"totalSize = %@", NSStringFromCGSize(totalSize));
    
    [self.scrollView setContentSize:totalSize];
}

@end
