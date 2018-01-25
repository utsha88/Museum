//
//  NSDictionary+FSQReadJSON.m
//  ios-interview
//
//  Created by Utsha Guha on 12-1-18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "NSDictionary+FSQReadJSON.h"

@implementation NSDictionary (FSQReadJSON)

/***************    Get the visitor list from JSON  *********************/
- (NSArray *)doSomethingWithTheJson
{
    NSArray *visitorList = [self JSONFromFile][@"venue"][@"visitors"];
    return visitorList;
}

/***************    Get the closing time from JSON  *********************/
- (int)getClosingTime{
    return [[self JSONFromFile][@"venue"][@"closeTime"] intValue];
}

/***************    Get the opening time from JSON  *********************/
- (int)getOpeningTime{
    return [[self JSONFromFile][@"venue"][@"openTime"] intValue];
}

/***************    Read JSON  *********************/
- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"people-here" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
