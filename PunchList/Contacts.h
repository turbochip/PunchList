//
//  Contacts.h
//  PunchList
//
//  Created by Chip Cox on 8/13/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Property;

@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *builderFor;
@property (nonatomic, retain) NSSet *loanOfficerFor;
@property (nonatomic, retain) NSSet *realtorFor;
@end

@interface Contacts (CoreDataGeneratedAccessors)

- (void)addBuilderForObject:(Property *)value;
- (void)removeBuilderForObject:(Property *)value;
- (void)addBuilderFor:(NSSet *)values;
- (void)removeBuilderFor:(NSSet *)values;

- (void)addLoanOfficerForObject:(Property *)value;
- (void)removeLoanOfficerForObject:(Property *)value;
- (void)addLoanOfficerFor:(NSSet *)values;
- (void)removeLoanOfficerFor:(NSSet *)values;

- (void)addRealtorForObject:(Property *)value;
- (void)removeRealtorForObject:(Property *)value;
- (void)addRealtorFor:(NSSet *)values;
- (void)removeRealtorFor:(NSSet *)values;

@end
