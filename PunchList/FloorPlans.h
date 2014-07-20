//
//  FloorPlans.h
//  PunchList
//
//  Created by Chip Cox on 7/20/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photos, Property;

@interface FloorPlans : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Photos *drawings;
@property (nonatomic, retain) Property *property;

@end
