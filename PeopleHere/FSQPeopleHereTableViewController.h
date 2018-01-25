//
//  FSQPeopleHereTableViewController.h
//  ios-interview
//
//  Created by Samuel Grossberg on 3/17/16.
//  Copyright © 2016 Foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSQPeopleHereTableViewController : UITableViewController

@property (nonatomic, assign)                int             openTime;
@property (nonatomic, assign)                int             closeTime;

@property (strong) NSArray	*visitorList;   // Visitor list array

@end
