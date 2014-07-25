//
//  Contacts.h
//  PunchList
//
//  Created by Chip Cox on 7/24/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Property;

@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *properties;
@end

@interface Contacts (CoreDataGeneratedAccessors)

- (void)addPropertiesObject:(Property *)value;
- (void)removePropertiesObject:(Property *)value;
- (void)addProperties:(NSSet *)values;
- (void)removeProperties:(NSSet *)values;

@end
