//
//  FloorPlans+addon.m
//  PunchList
//
//  Created by Chip Cox on 7/27/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "FloorPlans+addon.h"
#import "photos.h"
#import "Photos+addon.h"


/*
 @property (nonatomic, retain) NSString * title;
 @property (nonatomic, retain) NSNumber * sequence;
 @property (nonatomic, retain) Photos *drawings;
 @property (nonatomic, retain) Property *property;

 [fpDict setObject:self.propertyTitle forKey:@"title"];
 [fpDict setObject:self.imageURL forKey:@"imageURL"];
 [fpDict setObject:self.imageTitle forKey:@"imageTitle"];
 [fpDict setObject:self.imageSequence forKey:@"imageSequence"];

 */

@implementation FloorPlans (addon)

+(FloorPlans *) addFloorPlan:(NSDictionary *)floorPlan toProperty:(Property *) property onContext:(NSManagedObjectContext *)context
{
    FloorPlans *fp;
    if((fp=[self doesFloorPlanExist:[floorPlan objectForKey:@"imageTitle"] inContext:context])!=Nil) {
        CCLog(@"Update existing floor plan");
        fp.title=[floorPlan objectForKey:@"imageTitle"];
        fp.sequence= [floorPlan objectForKey:@"imageSequence"];
        fp.drawings=[Photos addPhotoURL:[floorPlan objectForKey:@"imageURL" ] toContext:context];
        fp.property=property;
    } else {
        CCLog(@"Add new floor plan");
        fp=[NSEntityDescription insertNewObjectForEntityForName:@"FloorPlans" inManagedObjectContext:context];
        NSLog(@"imageTitle=%@",[floorPlan objectForKey:@"imageTitle"]);
        fp.title=[floorPlan objectForKey:@"imageTitle"];
        fp.sequence=[floorPlan objectForKey:@"sequence"];
        fp.drawings=[Photos addPhotoURL:[floorPlan objectForKey:@"imageURL" ] toContext:context];
        fp.property=property;
    }
    [context save:nil];
    return fp;
}

+(FloorPlans *) doesFloorPlanExist:(NSString *)floorPlanTitle inContext:(NSManagedObjectContext *)context
{
    FloorPlans *floorPlanExists=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FloorPlans" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title=%@", floorPlanTitle];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = nil;
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        CCLog(@"Error searching for floorplan %@",floorPlanTitle);
    } else {
        if(fetchedObjects.count==0) {
            floorPlanExists=Nil;
        } else {
            floorPlanExists=fetchedObjects[0];
        }
    }
    return floorPlanExists;
}

@end
