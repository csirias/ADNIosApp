//
//  ADN_NewsItem.h
//  ADN
//
//  Created by Jeremy Tregunna on 12-02-27.
//  Copyright (c) 2012 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADN_NewsItem : NSObject
@property (readonly, nonatomic, copy) NSString* title;
@property (readonly, nonatomic, strong) NSNumber* tabId;
@property (readonly, nonatomic, strong) NSNumber* categoryId;
@property (readonly, nonatomic, strong) NSURL* imageURL;
@property (readonly, nonatomic, strong) NSURL* detailURL;

+ (ADN_NewsItem*)newWithDictionary:(NSDictionary*)dict;
- (id)initWithDictionary:(NSDictionary*)dict;

@end
