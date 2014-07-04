//
//  Photos.h
//  PunchList
//
//  Created by Chip Cox on 7/4/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FloorPlans, Issue, Property;

@interface Photos : NSManagedObject

@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * photoTitle;
@property (nonatomic, retain) Property *ofProperty;
@property (nonatomic, retain) Issue *photoOf;
@property (nonatomic, retain) FloorPlans *ofFloorPlan;

@end
