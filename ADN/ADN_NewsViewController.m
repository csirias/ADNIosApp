//
//  ADN_NewsViewController.m
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADN_NewsViewController.h"
#import "ADN_DetailViewController.h"
#import "EasyTableView.h"

static NSUInteger kADNTableViewHeight = 70;
static NSUInteger kADNTableCellWidth  = 100;

static BOOL is_ipad()
{
    return [[[UIDevice currentDevice] model] isEqualToString:@"iPad"];
}

@interface ADN_NewsViewController ()
@property (nonatomic, readonly, strong) NSArray* details;
- (void)loadJSON:(NSError**)error;
- (EasyTableView*)setupEasyTableViewWithNumCells:(NSUInteger)count;
@end

@implementation ADN_NewsViewController
{
    NSUInteger selectedColumn;
}

@synthesize tableView, easyTableView, dateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setNavigationBarHidden:TRUE animated:YES];
        // Custom initialization
        NSError* error = nil;
        [self loadJSON:&error];
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
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:TRUE animated:YES];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    if(is_ipad())
    {
        kADNTableViewHeight = 140;
        kADNTableCellWidth = 200;
    }
    
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    NSDate* date = [NSDate date];
    NSString* dateFormat = @"h':'mm a' - 'dd/MM/yyyy";
    if(is_ipad())
        dateFormat = NSLocalizedString(@"Long Date Format", @"");
    [f setDateFormat:dateFormat];
    dateLabel.text = [f stringFromDate:date];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return [self.details count];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return is_ipad() ? 142.0f : 72.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* sections[4] = { NSLocalizedString(@"Actualidad", @""), NSLocalizedString(@"Deportes", @""), NSLocalizedString(@"Nacionales", @""), NSLocalizedString(@"Mundo", @"") };
    return sections[section];
}

- (UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* kNewsCellIdentifier = @"itemCell";
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:kNewsCellIdentifier];

    EasyTableView* et = (EasyTableView*)[cell.contentView viewWithTag:kNewsCellHorizontalTableViewTag];
    if(!et)
    {
        et = [self setupEasyTableViewWithNumCells:[[self.details objectAtIndex:indexPath.section] count]];
        [cell.contentView addSubview:et];
    }
    et.data = [self.details objectAtIndex:indexPath.section];

    return cell;
}


#pragma mark - EasyTableView


- (EasyTableView*)setupEasyTableViewWithNumCells:(NSUInteger)count
{
	CGRect frameRect               = CGRectMake(10, 0, self.view.bounds.size.width - 20, kADNTableViewHeight);
	EasyTableView *view            = [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:count ofWidth:kADNTableCellWidth];
	
    view.tag                       = kNewsCellHorizontalTableViewTag;
	view.delegate                  = self;
	view.tableView.backgroundColor = [UIColor clearColor];
	view.tableView.separatorColor  = [UIColor blackColor];
	view.cellBackgroundColor       = [UIColor blackColor];
	view.autoresizingMask          = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    
    return view;
}


- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect
{
    UIView* container = [[UIView alloc] initWithFrame:rect];
    
    CGRect imageViewRect = CGRectMake(19, 4, 64, 64);
    if(is_ipad())
        imageViewRect = CGRectMake(19, 4, 140, 130);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
    imageView.tag = kNewsCellImageViewTag;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:imageView];

    UILabel* titleLabel = nil;
    if(is_ipad())
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 67, 140, 67)];
        titleLabel.numberOfLines = 3;
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 34, 66, 36)];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    titleLabel.tag = kNewsCellTitleTag;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [container addSubview:titleLabel];

    return container;
}


- (void)easyTableView:(EasyTableView *)et setDataForView:(UIView *)view forIndex:(NSUInteger)index
{
    UIImageView* imageView = (UIImageView*)[view viewWithTag:kNewsCellImageViewTag];
    if([[et.data objectAtIndex:index] objectForKey:@"photo_url"] == [NSNull null])
        imageView.image = [UIImage imageNamed:@"adn_logo.png"];
    else
        imageView.image = [UIImage imageNamed:@"lauraChinchilla_1_thumb.jpg"];
    
    UILabel* titleLabel = (UILabel*)[view viewWithTag:kNewsCellTitleTag];
    titleLabel.text = [[et.data objectAtIndex: index] objectForKey:@"title"];
}


- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndex:(NSUInteger)index deselectedView:(UIView *)deselectedView
{
    selectedColumn = index;
    [self performSegueWithIdentifier:@"push" sender:self];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(selectedColumn != INT_MAX)
    {
        NSIndexPath* selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NSDictionary* d = [[self.details objectAtIndex:selectedRowIndex.section] objectAtIndex:selectedColumn];
        selectedColumn = INT_MAX;
        ADN_DetailViewController* detailVC = [segue destinationViewController];
        [[detailVC navigationItem] setTitle:[d objectForKey:@"title"]];
        [detailVC setDetails:d];
    }
}

#pragma mark - Dealing with JSON

#pragma mark -    REFACTOR THIS INTO ITS OWN MODEL

- (void)loadJSON:(NSError**)error
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"actualidad" ofType:@"json"];
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
        return [NSArray array]; // This should do something more constructive

    return details;
}

@end
