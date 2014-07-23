//
//  Contacts+addon.h
//  PunchList
//
//  Created by Chip Cox on 7/22/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Contacts.h"
#import "CCExtras.h"

@interface Contacts (addon)
+(BOOL) addContact:(NSDictionary *) c onContext:(NSManagedObjectContext *) context;

+(void) deleteContact:(NSDictionary *) c onContext:(NSManagedObjectContext *) context;

+(NSArray *) searchContact:(NSString *)ContactName onContext:(NSManagedObjectContext *) context;

@end
