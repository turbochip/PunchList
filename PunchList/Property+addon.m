//
//  Property+addon.m
//  PunchList
//
//  Created by Chip Cox on 7/20/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Property+addon.h"
#import "Contacts.h"

@implementation Property (addon)

+(BOOL) addProperty:(NSDictionary *) p onContext:(NSManagedObjectContext *) context
{
    BOOL status=NO;
    NSLog(@"property=%@,%@,%@,%@,%@",[p valueForKey:@"Name"],
                                    [p valueForKey:@"Street"],
                                    [p valueForKey:@"City"],
                                    [p valueForKey:@"State"],
                                    [p valueForKey:@"ZIP"]);
    
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Property"];
    request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    request.predicate=[NSPredicate predicateWithFormat:@"name = %@",[p valueForKey:@"Name" ]];
    NSArray *propArray=[context executeFetchRequest:request error:&error];
    
    if(!propArray) {
        CCLog(@"Error executing fetch %@",[p valueForKeyPath:@"Name"]);
        status=NO;
    }else {
        switch (propArray.count) {
            case 0: {
                CCLog(@"Add new record");
                Property *property = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
                property.name=[p valueForKey:@"Name"];
                property.streetAddress=[p valueForKey:@"Street"];
                property.city=[p valueForKey:@"City"];
                property.state=[p valueForKey:@"State"];
                property.zip=[p valueForKey:@"ZIP"];
                CCLog(@"property.contactData=%@",property.contactData);
                Contacts *c=property.contactData;
                [c addPropertiesObject:[p valueForKey:@"Realtor"]];
                [c addPropertiesObject:[p valueForKey:@"LoanOfficer"]];
                [c addPropertiesObject:[p valueForKey:@"Builder"]];
                [context save:NULL ];
                status=YES;
                break;
            }
            case 1: {
                CCLog(@"Record exists update it");
                Property *property=[propArray objectAtIndex:0];
                property.name=[p valueForKey:@"Name"];
                property.streetAddress=[p valueForKey:@"Street"];
                property.city=[p valueForKey:@"City"];
                property.state=[p valueForKey:@"State"];
                property.zip=[p valueForKey:@"ZIP"];
                Contacts *c=property.contactData;
                [c addPropertiesObject:[p valueForKey:@"Realtor"]];
                [c addPropertiesObject:[p valueForKey:@"LoanOfficer"]];
                [c addPropertiesObject:[p valueForKey:@"Builder"]];
               
                [context save:NULL ];
                status=YES;
                break;
            }
            default: {
                CCLog(@"Somehow more than one entity exists that the name %@",[p valueForKey:@"Name"]);
                status=NO;
                break;
            }
        }
    }
    return status;
}

+(void) deleteProperty:(NSString *) PropertyID onContext:(NSManagedObjectContext *) context
{
    
}

+(NSArray *) searchProperty:(NSString *)name onContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Property"];
    request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    if((!name)||([name length]==0)) {
        CCLog(@"Search string is empty searching for all properties");
        request.predicate=nil;
    }
    else {
        CCLog(@"Searching for %@",name);
        request.predicate=[NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",name];
    }
    
    NSArray *propArray=[context executeFetchRequest:request error:&error];
    
    if((!propArray) || (propArray.count==0)) {
        CCLog(@"No Properties matched search criteria %@",name);
    }else {
        CCLog(@"Found %d possible matches to search criteria %@",propArray.count,name);
    }
    
    return propArray;
}
@end
