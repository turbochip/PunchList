//
//  Issue.h
//  PunchList
//
//  Created by Chip Cox on 8/13/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FloorPlans, Photos;

@interface Issue : NSManagedObject

@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateResolved;
@property (nonatomic, retain) NSNumber * locationX;
@property (nonatomic, retain) NSNumber * locationY;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * itemNo;
@property (nonatomic, retain) NSSet *photoOf;
@property (nonatomic, retain) FloorPlans *isOnFloorPlan;
@end

@interface Issue (CoreDataGeneratedAccessors)

- (void)addPhotoOfObject:(Photos *)value;
- (void)removePhotoOfObject:(Photos *)value;
- (void)addPhotoOf:(NSSet *)values;
- (void)removePhotoOf:(NSSet *)values;

@end
