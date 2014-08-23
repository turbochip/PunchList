//
//  Property.h
//  PunchList
//
//  Created by Chip Cox on 8/22/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contacts, FloorPlans, Issue, Photos;

@interface Property : NSManagedObject

@property (nonatomic, retain) NSNumber * askingPrice;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * salesPrice;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) Contacts *builder;
@property (nonatomic, retain) NSSet *floorPlan;
@property (nonatomic, retain) NSSet *issues;
@property (nonatomic, retain) Contacts *loanOfficer;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Contacts *realtor;
@end

@interface Property (CoreDataGeneratedAccessors)

- (void)addFloorPlanObject:(FloorPlans *)value;
- (void)removeFloorPlanObject:(FloorPlans *)value;
- (void)addFloorPlan:(NSSet *)values;
- (void)removeFloorPlan:(NSSet *)values;

- (void)addIssuesObject:(Issue *)value;
- (void)removeIssuesObject:(Issue *)value;
- (void)addIssues:(NSSet *)values;
- (void)removeIssues:(NSSet *)values;

- (void)addPhotosObject:(Photos *)value;
- (void)removePhotosObject:(Photos *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
