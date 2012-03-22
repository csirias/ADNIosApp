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
#import "AsyncImageView.h"
#import "ADN_NewsItem.h"

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
    NSArray*   selectedData;
    BOOL       radioPlaying;
}

@synthesize tableView, dateLabel, radioStatusLabel, radioButton, lastUpdatedLabel;

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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for(int i = 0; i < 4; i++)
    {
        CGRect frame = easyTableView[i].frame;
        frame.size.width = self.view.bounds.size.width;
        easyTableView[i].frame = frame;
    }
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
    if([self.details count] == 3)
    {
        NSString* sections[3] = { NSLocalizedString(@"Actualidad", @""), NSLocalizedString(@"Deportes", @""), NSLocalizedString(@"Noticias", @"") };
        return sections[section];
    }
    else
    {
        NSString* sections[4] = { NSLocalizedString(@"Actualidad", @""), NSLocalizedString(@"Deportes", @""), NSLocalizedString(@"Nacionales", @""), NSLocalizedString(@"Mundo", @"") };
        return sections[section];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* kNewsCellIdentifier = @"itemCell";
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:kNewsCellIdentifier];

    UIView* v = [cell.contentView viewWithTag:kNewsCellHorizontalTableViewTag];
    [v removeFromSuperview];

    if(!easyTableView[indexPath.section])
    {
        EasyTableView* et = [self setupEasyTableViewWithNumCells:[[self.details objectAtIndex:indexPath.section] count]];
        easyTableView[indexPath.section] = et;
    }

    easyTableView[indexPath.section].data = [self.details objectAtIndex:indexPath.section];
    
    [cell.contentView addSubview:easyTableView[indexPath.section]];

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
    AsyncImageView* imageView = [[AsyncImageView alloc] initWithFrame:imageViewRect];
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
    AsyncImageView* imageView = (AsyncImageView*)[view viewWithTag:kNewsCellImageViewTag];
    NSURL* imageURL = [[et.data objectAtIndex:index] imageURL];
    if(imageURL && [[imageURL absoluteString] isEqualToString:@"http://www.adn.fm"])
        imageView.image = [UIImage imageNamed:@"adn_logo.png"];
    else
        imageView.imageURL = imageURL;
    imageView.crossfadeImages = NO;
    
    UILabel* titleLabel = (UILabel*)[view viewWithTag:kNewsCellTitleTag];
    titleLabel.text = [[et.data objectAtIndex: index] title];
}


- (void)easyTableView:(EasyTableView *)et selectedView:(UIView *)selectedView atIndex:(NSUInteger)index deselectedView:(UIView *)deselectedView
{
    selectedColumn = index;
    selectedData = et.data;
    [self performSegueWithIdentifier:@"push" sender:self];
}


#pragma mark - Buttons


- (IBAction)termsOfService:(id)sender
{
    [self performSegueWithIdentifier:@"terms" sender:self];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if(selectedColumn != INT_MAX && [segue.identifier isEqualToString:@"push"])
    {
        ADN_NewsItem* d = [selectedData objectAtIndex:selectedColumn];
        selectedColumn = INT_MAX;
        ADN_DetailViewController* detailVC = [segue destinationViewController];
        [[detailVC navigationItem] setTitle:d.title];
        detailVC.url = d.detailURL;
        NSLog(@"Loading webview with URL %@", d.detailURL);
    }
    else if([segue.identifier isEqualToString:@"terms"])
    {
        ADN_DetailViewController* detailVC = [segue destinationViewController];
        [[detailVC navigationItem] setTitle:NSLocalizedString(@"Terms of Service Label", @"")];
        detailVC.url = [NSURL URLWithString:NSLocalizedString(@"Terms of Service Link", @"")];
    }
}

#pragma mark - AudioStreamer


- (void)destroyStreamer
{
    NSLog(@"streamer = %@", streamer);
	if(streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		
		[streamer stop];
		streamer = nil;
	}
}

- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (__bridge CFStringRef)NSLocalizedString(@"http://www.fm.net.ve:9000/ADNRADIO", @""),
                                                         NULL,
                                                         NULL,
                                                                  kCFStringEncodingUTF8);
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
#ifdef SHOUTCAST_METADATA
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(metadataChanged:)
	 name:ASUpdateMetadataNotification
	 object:streamer];
#endif
}


- (void)startListening:(id)sender
{
    if(![streamer isPlaying] && ![streamer isWaiting])
    {
        self.radioButton.enabled = NO;
        [self createStreamer];
        [streamer start];
    }
    else
    {
        [self destroyStreamer];
        self.radioStatusLabel.text = NSLocalizedString(@"Radio Status Stopped", @"");
    }
}


- (void)playbackStateChanged:(NSNotification *)aNotification
{
    if([streamer isWaiting])
        self.radioStatusLabel.text = NSLocalizedString(@"Radio Status Loading", @"");
    else if([streamer isPaused])
        self.radioStatusLabel.text = NSLocalizedString(@"Radio Status Stopped", @"");
    else if([streamer isPlaying])
    {
        self.radioStatusLabel.text = NSLocalizedString(@"Radio Status Playing", @"");
        self.radioButton.enabled = YES;
    }
    else if([streamer isIdle])
    {
        self.radioStatusLabel.text = NSLocalizedString(@"Radio Status Stopped", @"");
        self.radioButton.enabled = YES;
    }
}


- (void)metadataChanged:(NSNotification *)aNotification
{
}


#pragma mark - Dealing with JSON

#pragma mark -    REFACTOR THIS INTO ITS OWN MODEL

- (void)activateNetworkActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)deactivateNetworkActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)reloadMenu:(id)sender
{
    [self refreshMenu];
    [self.tableView reloadData];
}

- (void)refreshMenu
{
    [self performSelectorInBackground:@selector(loadJSON:) withObject:nil];
}

- (void)loadJSON:(NSError**)error
{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:self];
    [self performSelectorOnMainThread:@selector(activateNetworkActivityIndicator) withObject:nil waitUntilDone:YES];
    NSData* returnedData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:NSLocalizedString(@"MainJSONFeed", @"")]];
    NSArray* array = [NSJSONSerialization JSONObjectWithData:returnedData options:kNilOptions error:error];
    NSMutableArray* tmp = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    NSUInteger sectionId = 0;

    for(NSDictionary* d in array)
    {
        switch([[d objectForKey:@"CategoryTabID"] intValue])
        {
            case 84:
                sectionId = 0;
                break;
            case 81:
                sectionId = 1;
                break;
            case 61:
                sectionId = 2;
                break;
            default:
                break;
        }

        ADN_NewsItem* item = [[ADN_NewsItem alloc] initWithDictionary:d];
        [[tmp objectAtIndex:sectionId] addObject: item];
    }
    
    if([[tmp objectAtIndex:3] count] == 0)
        [tmp removeObjectAtIndex:3];

    details = [tmp copy];
    [self performSelectorOnMainThread:@selector(deactivateNetworkActivityIndicator) withObject:nil waitUntilDone:YES];
    
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    NSDate* date = [NSDate date];
    NSString* dateFormat = @"h':'mm a";
    [f setDateFormat:dateFormat];
    self.lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last Updated", @""), [f stringFromDate:date]];
}

- (NSArray*)details
{
    NSError* error;
    if(details)
        return details;

    [self loadJSON:&error];
    if(error)
    {
        NSLog(@"Error: %@", error);
        return [NSArray array]; // This should do something more constructive
    }

    return details;
}

@end
