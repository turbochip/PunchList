//
//  Issue.h
//  PunchList
//
//  Created by Chip Cox on 7/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photos, Property;

@interface Issue : NSManagedObject

@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateResolved;
@property (nonatomic, retain) NSNumber * locationx;
@property (nonatomic, retain) NSNumber * locationY;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *photoOf;
@property (nonatomic, retain) Property *property;
@end

@interface Issue (CoreDataGeneratedAccessors)

- (void)addPhotoOfObject:(Photos *)value;
- (void)removePhotoOfObject:(Photos *)value;
- (void)addPhotoOf:(NSSet *)values;
- (void)removePhotoOf:(NSSet *)values;

@end
