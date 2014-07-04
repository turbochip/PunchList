//
//  Issue.h
//  PunchList
//
//  Created by Chip Cox on 7/4/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photos, Property;

@interface Issue : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateResolved;
@property (nonatomic, retain) NSNumber * locationx;
@property (nonatomic, retain) NSNumber * locationY;
@property (nonatomic, retain) Property *property;
@property (nonatomic, retain) Photos *photoOf;

@end
