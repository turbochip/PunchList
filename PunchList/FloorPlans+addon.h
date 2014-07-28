//
//  FloorPlans+addon.h
//  PunchList
//
//  Created by Chip Cox on 7/27/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "FloorPlans.h"
#import "CCExtras.h"

@interface FloorPlans (addon)


+(FloorPlans *) addFloorPlan:(NSDictionary *)floorPlan toProperty:(Property *) property onContext:(NSManagedObjectContext *)context;
+(FloorPlans *) doesFloorPlanExist:(NSString *)floorPlanTitle inContext:(NSManagedObjectContext *)context;

@end
