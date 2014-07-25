//
//  Contacts+addon.m
//  PunchList
//
//  Created by Chip Cox on 7/22/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Contacts+addon.h"

@implementation Contacts (addon)

+(BOOL) addContact:(NSDictionary *) c onContext:(NSManagedObjectContext *) context
{
    BOOL status=NO;
    CCLog(@"Contact=%@,%@,%@",[c valueForKey:@"Name"],
          [c valueForKey:@"Activity"],
          [c valueForKey:@"Property"]);
    
    CCLog(@"building fetch request");
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Contacts"];
    request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    request.predicate=[NSPredicate predicateWithFormat:@"name = %@",[c valueForKey:@"Name" ]];
    CCLog(@"About to execute fetch request fetch=%@",request);
    NSArray *contactArray=[context executeFetchRequest:request error:&error];
    
    if(!contactArray) {
        CCLog(@"Error executing fetch %@",[c valueForKeyPath:@"Name"]);
        status=NO;
    }else {
        switch (contactArray.count) {
            case 0: {
                CCLog(@"Add new record");
                Contacts *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:context];
                contact.name=[c valueForKey:@"Name"];
                contact.activity=[c valueForKey:@"Activity"];
                
                [contact addPropertiesObject:[c valueForKey:@"Property"]];

                
                [context save:NULL ];
                status=YES;
                break;
            }
            case 1: {
                CCLog(@"Record exists update it");
                Contacts *contact=[contactArray objectAtIndex:0];
                contact.name=[c valueForKey:@"Name"];
                contact.activity=[c valueForKey:@"Activity"];
                [contact addPropertiesObject:[c valueForKey:@"Property"]];
                
                [context save:NULL ];
                status=YES;
                break;
            }
            default: {
                CCLog(@"Somehow more than one entity exists that the name %@",[c valueForKey:@"Name"]);
                status=NO;
                break;
            }
        }
    }
    return status;
}

+(void) deleteContact:(NSString *) ContactName onContext:(NSManagedObjectContext *) context
{
    
}

+(NSArray *) searchContact:(NSString *)contactName onContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Contacts"];
    request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    if((!contactName)||([contactName length]==0)) {
        CCLog(@"Search string is empty searching for all properties");
        request.predicate=nil;
    } else {
        CCLog(@"Searching for %@",contactName);
        request.predicate=[NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",contactName];
    }
    
    NSArray *contactArray=[context executeFetchRequest:request error:&error];
    
    if((!contactArray) || (contactArray.count==0)) {
        CCLog(@"No Properties matched search criteria %@",contactName);
    }else {
        CCLog(@"Found %d possible matches to search criteria %@",contactArray.count,contactName);
    }
    
    return contactArray;
}

@end
