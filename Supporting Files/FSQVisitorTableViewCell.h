//
//  FSQVisitorTableViewCell.h
//  ios-interview
//
//  Created by Utsha Guha on 12-1-18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSQVisitorTableViewCell : UITableViewCell

// Visitor name and time outlets
@property (weak) IBOutlet UILabel *visitorName;
@property (weak) IBOutlet UILabel *visitorTime;

@end
