//
//  Issue.h
//  PunchList
//
//  Created by Chip Cox on 8/22/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FloorPlans, Photos, Property;

@interface Issue : NSManagedObject

@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateResolved;
@property (nonatomic, retain) NSNumber * itemNo;
@property (nonatomic, retain) NSNumber * locationX;
@property (nonatomic, retain) NSNumber * locationY;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Property *isForProperty;
@property (nonatomic, retain) FloorPlans *isOnFloorPlan;
@property (nonatomic, retain) NSSet *hasPhotos;
@end

@interface Issue (CoreDataGeneratedAccessors)

- (void)addHasPhotosObject:(Photos *)value;
- (void)removeHasPhotosObject:(Photos *)value;
- (void)addHasPhotos:(NSSet *)values;
- (void)removeHasPhotos:(NSSet *)values;

@end
