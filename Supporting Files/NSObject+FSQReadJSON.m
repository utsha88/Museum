//
//  NSObject+FSQReadJSON.m
//  ios-interview
//
//  Created by Utsha Guha on 12-1-18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "NSObject+FSQReadJSON.h"

@implementation NSObject (FSQReadJSON)

- (void)doSomethingWithTheJson
{
    NSDictionary *dict = [self JSONFromFile];
    
//    NSArray *colours = [dict objectForKey:@"colors"];
//    
//    for (NSDictionary *colour in colours) {
//        NSString *name = [colour objectForKey:@"name"];
//        NSLog(@"Colour name: %@", name);
//        
//        if ([name isEqualToString:@"green"]) {
//            NSArray *pictures = [colour objectForKey:@"pictures"];
//            for (NSDictionary *picture in pictures) {
//                NSString *pictureName = [picture objectForKey:@"name"];
//                NSLog(@"Picture name: %@", pictureName);
//            }
//        }
//    }
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
