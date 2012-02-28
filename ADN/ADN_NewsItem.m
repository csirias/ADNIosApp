//
//  ADN_NewsItem.m
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-27.
//  Copyright (c) 2012 Jeremy Tregunna. All rights reserved.
//

#import "ADN_NewsItem.h"

@implementation ADN_NewsItem

@synthesize title = _title;
@synthesize tabId = _tabId;
@synthesize categoryId = _categoryId;
@synthesize imageURL = _imageURL;
@synthesize detailURL = _detailURL;

+ (ADN_NewsItem*)newWithDictionary:(NSDictionary*)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    if(!(self = [super init]))
        return nil;

    _title = [dict objectForKey:@"Title"];
    _tabId = [dict objectForKey:@"TabID"];
    _categoryId = [dict objectForKey:@"CategoryTabID"];
    _detailURL = [NSURL URLWithString:[dict objectForKey:@"DetailsURL"]];

    NSString* url = [dict objectForKey:@"ImageURL"];
    if(url && ![url isEqual: [NSNull null]])
        _imageURL = [NSURL URLWithString:url];

    return self;
}

@end
