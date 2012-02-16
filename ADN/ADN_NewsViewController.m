//
//  ADN_NewsViewController.m
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADN_NewsViewController.h"

@interface ADN_NewsViewController ()
- (void)loadJSON;
@end

@implementation ADN_NewsViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setNavigationBarHidden:TRUE animated:YES];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadJSON];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:FALSE animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - Dealing with JSON

- (void)loadJSON:(NSError**)error
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"MyFile" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    details = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

- (NSArray*)details
{
    NSError* error;
    if(details)
        return details;

    [self loadJSON:&error];
    if(error)
        return NULL;
    return details;
}

@end
