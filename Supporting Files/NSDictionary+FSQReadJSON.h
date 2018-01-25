//
//  NSDictionary+FSQReadJSON.h
//  ios-interview
//
//  Created by Utsha Guha on 12-1-18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FSQReadJSON)

- (NSArray *)doSomethingWithTheJson;
- (int)getClosingTime;
- (int)getOpeningTime;

@end
