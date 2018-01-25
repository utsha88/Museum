//
//  FSQPeopleHereTableViewController.m
//  ios-interview
//
//  Created by Samuel Grossberg on 3/17/16.
//  Copyright © 2016 Foursquare. All rights reserved.
//

#import "FSQPeopleHereTableViewController.h"
#import "FSQVisitorTableViewCell.h"
#import "NSDictionary+FSQReadJSON.h"

/********************   String Constants    ********************/
NSString *const FSQVisitorArrivalTime = @"arriveTime";
NSString *const FSQVisitorLeavingTime = @"leaveTime";
NSString *const FSQNoVisitorMessage = @"No Visitors";
NSString *const FSQVisitorCellIdentifier = @"visitorIdentifier";
NSString *const FSQVisitorName = @"name";
NSString *const FSQVisitorID = @"id";
NSString *const FSQTimeFormat = @"%d:%02d";
NSString *const FSQTimespanFormat = @"%@ - %@";
/***************************************************************/

/********************   Integer Constants    ********************/
NSInteger const FSQOneDayInSeconds = 86400;
NSInteger const FSQSecondsInHour = 3600;
NSInteger const FSQSecondsInMin = 60;
/***************************************************************/

@interface FSQPeopleHereTableViewController ()

@end

@implementation FSQPeopleHereTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = [NSDictionary dictionary];
    _openTime = [dict getOpeningTime];
    _closeTime = [dict getClosingTime];
    
    self.visitorList = [self generateSortedArrayFromJSON];  // Convert JSON into Array
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/********************** Table View Datasource   ******************/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.visitorList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSQVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSQVisitorCellIdentifier forIndexPath:indexPath];
    
    // Disable rows with 'No Visitors'
    if ([self.visitorList[indexPath.row][FSQVisitorName] isEqualToString:FSQNoVisitorMessage]) {
        cell.visitorName.enabled = NO;
        cell.visitorTime.enabled = NO;
    }
    
    // Populate Visitor Name and Timing in TableView
    cell.visitorName.text = self.visitorList[indexPath.row][FSQVisitorName];
    cell.visitorTime.text = [self generateTimeInProperFormatFor:self.visitorList[indexPath.row][FSQVisitorArrivalTime] and:self.visitorList[indexPath.row][FSQVisitorLeavingTime]];
    return cell;
}
/***************************************************************/

/***************************************************************/

//  Method Name:    generateSortedArrayFromJSON
//  Description:    Generate array in ascending order from JSON

/***************************************************************/
-(NSArray *)generateSortedArrayFromJSON{
    NSDictionary *dict = [NSDictionary dictionary];
    NSArray *inputVisitorArray = [dict doSomethingWithTheJson];
    NSSortDescriptor *sortDescriptorOne,*sortDescriptorTwo;
    sortDescriptorOne = [[NSSortDescriptor alloc] initWithKey:FSQVisitorArrivalTime
                                                    ascending:YES];
    sortDescriptorTwo = [[NSSortDescriptor alloc] initWithKey:FSQVisitorLeavingTime
                                                    ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptorOne,sortDescriptorTwo, nil];
    NSArray *sortedVisitorList = [inputVisitorArray sortedArrayUsingDescriptors:sortDescriptors];
    NSArray *resultArray = [[self calculateIdleHours:sortedVisitorList] sortedArrayUsingDescriptors:sortDescriptors];
    return resultArray;
}

/***************************************************************/

//  Method Name:    calculateIdleHours:
//  Description:    Logic to generate the time span with 'No Visitors'

/***************************************************************/

-(NSArray *)calculateIdleHours:(NSArray *)visitorArray{
    NSMutableArray *finalArray  = [NSMutableArray arrayWithArray:visitorArray];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    int lowerBoundary = _openTime;
    int higherBoundary = 0;
    int closingTime = _closeTime;
    
    // Logic to retrieve the idle time.
    for (int i = 0; i<visitorArray.count; i++) {
        if ([visitorArray[i][FSQVisitorArrivalTime] intValue]>lowerBoundary) {
            if (lowerBoundary>=higherBoundary) {
                if (lowerBoundary != [visitorArray[i][FSQVisitorArrivalTime] intValue]) {
                    [tempArray addObject:[NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:lowerBoundary],FSQNoVisitorMessage,[NSNumber numberWithInt:[visitorArray[i][FSQVisitorArrivalTime] intValue]],FSQNoVisitorMessage] forKeys:@[FSQVisitorArrivalTime,FSQVisitorID,FSQVisitorLeavingTime,FSQVisitorName]]];
                }
            }
            else{
                if (higherBoundary != [visitorArray[i][FSQVisitorArrivalTime] intValue]) {
                    [tempArray addObject:[NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:higherBoundary],FSQNoVisitorMessage,[NSNumber numberWithInt:[visitorArray[i][FSQVisitorArrivalTime] intValue]],FSQNoVisitorMessage] forKeys:@[FSQVisitorArrivalTime,FSQVisitorID,FSQVisitorLeavingTime,FSQVisitorName]]];
                }
            }
    
        }
        lowerBoundary = [visitorArray[i][FSQVisitorLeavingTime] intValue];
        if ([visitorArray[i][FSQVisitorLeavingTime] intValue]>higherBoundary) {
            higherBoundary = [visitorArray[i][FSQVisitorLeavingTime] intValue];
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FSQVisitorLeavingTime
                                                    ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortedVisitorArray = [visitorArray sortedArrayUsingDescriptors:sortDescriptors];
    
    // Logic to retrieve the closing time if closing time is greater than 24hours.
    if (closingTime>[[sortedVisitorArray firstObject][FSQVisitorLeavingTime] intValue]) {
        
        int finalClosingTime = closingTime;
        if (closingTime>FSQOneDayInSeconds) {
            finalClosingTime = finalClosingTime - FSQOneDayInSeconds;
        }
        
    // Add the idle time between the last guest exit time to closing time.
    [tempArray addObject:[NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:[[sortedVisitorArray firstObject][FSQVisitorLeavingTime] intValue]],FSQNoVisitorMessage,[NSNumber numberWithInt:finalClosingTime],FSQNoVisitorMessage] forKeys:@[FSQVisitorArrivalTime,FSQVisitorID,FSQVisitorLeavingTime,FSQVisitorName]]];
    }
    [finalArray addObjectsFromArray:tempArray];
    return finalArray;
}

/***************************************************************/

//  Method Name:    calculateIdleHours:
//  Description:    Convert seconds into proper time format(HH:MM - HH:MM)

/***************************************************************/
-(NSString *)generateTimeInProperFormatFor:(NSString *)arriveTime and:(NSString *)leaveTime{
    NSString *resultString = [NSString string];
    
    int arriveHour = [arriveTime intValue] / FSQSecondsInHour;
    int arriveMin = ([arriveTime intValue] / FSQSecondsInMin) % FSQSecondsInMin;
    
    int leaveHour = [leaveTime intValue] / FSQSecondsInHour;
    int leaveMin = ([leaveTime intValue] / FSQSecondsInMin) % FSQSecondsInMin;

    NSString *arrivalTime = [NSString stringWithFormat:FSQTimeFormat,arriveHour, arriveMin];
    NSString *leavingTime = [NSString stringWithFormat:FSQTimeFormat,leaveHour, leaveMin];
    
    resultString = [NSString stringWithFormat:FSQTimespanFormat,arrivalTime,leavingTime];
    
    return resultString;
}

@end
