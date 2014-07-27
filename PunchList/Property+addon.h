//
//  Property+addon.h
//  PunchList
//
//  Created by Chip Cox on 7/20/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Property.h"
#import "CCExtras.h"

@interface Property (addon)

+(Property *) addProperty:(NSDictionary *) p onContext:(NSManagedObjectContext *) context;

+(void) deleteProperty:(NSDictionary *) p onContext:(NSManagedObjectContext *) context;

+(NSArray *) searchProperty:(NSString *)PropertyID onContext:(NSManagedObjectContext *) context;

@end
