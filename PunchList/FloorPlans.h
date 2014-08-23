//
//  FloorPlans.h
//  PunchList
//
//  Created by Chip Cox on 8/22/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Issue, Photos, Property;

@interface FloorPlans : NSManagedObject

@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Photos *drawings;
@property (nonatomic, retain) NSSet *hasIssues;
@property (nonatomic, retain) Property *property;
@end

@interface FloorPlans (CoreDataGeneratedAccessors)

- (void)addHasIssuesObject:(Issue *)value;
- (void)removeHasIssuesObject:(Issue *)value;
- (void)addHasIssues:(NSSet *)values;
- (void)removeHasIssues:(NSSet *)values;

@end
