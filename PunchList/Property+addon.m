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

+(Property *) addProperty:(NSDictionary *) p onContext:(NSManagedObjectContext *) context
{
    Property *property;
    BOOL status=NO;
    CCLog(@"property=%@,%@,%@,%@,%@,%@,%@,%@",[p valueForKey:@"Name"],
                                    [p valueForKey:@"Street"],
                                    [p valueForKey:@"City"],
                                    [p valueForKey:@"State"],
                                    [p valueForKey:@"ZIP"],
                                    [p valueForKey:@"Realtor"],
                                    [p valueForKey:@"LoanOfficer"],
                                    [p valueForKey:@"Builder"]);
    
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
                property = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
                [self setPropertyRecord:property withDictionary:p];
                [context save:NULL ];
                status=YES;
                break;
            }
            case 1: {
                CCLog(@"Record exists update it");
                property=[propArray objectAtIndex:0];
                [self setPropertyRecord:property withDictionary:p];               
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
    return property;
}

+(void) setPropertyRecord:(Property *)property withDictionary:(NSDictionary *)myDict
{
    property.name=[myDict valueForKey:@"Name"];
    property.streetAddress=[myDict valueForKey:@"Street"];
    property.city=[myDict valueForKey:@"City"];
    property.state=[myDict valueForKey:@"State"];
    property.zip=[myDict valueForKey:@"ZIP"];
    // property.contactData;
    Contacts *cr = [myDict valueForKey:@"Realtor"];
    Contacts *cl = [myDict valueForKey:@"LoanOfficer"];
    Contacts *cb = [myDict valueForKey:@"Builder"];
    if(cr==(id)[NSNull null]) {
        CCLog(@"Realtor being set to nil");
        property.realtor=nil;
    } else {
        CCLog(@"Realtor being set to %@",cr);
        property.realtor=cr;
    }
    if(cl==(id)[NSNull null]) {
        CCLog(@"LoanOfficer being set to nil");
        property.loanOfficer=nil;
    } else {
        CCLog(@"LoanOfficer being set to %@",cl);
        property.loanOfficer=cl;
    }
    if(cb==(id)[NSNull null]) {
        CCLog(@"Builder being set to nil");
        property.builder=nil;
    } else {
        CCLog(@"Builder being set to %@",cb);
        property.builder=cb;
    }
    CCLog(@"property realtor=%@, loanOfficer%@, builder%@",property.realtor,property.loanOfficer,property.builder);
}

+(void) setProperty:(Property *)p Contact:(Contacts *) pc To:(Contacts *) c
{
    if((c==nil) && (pc==nil)) {
        CCLog(@"Don't set relationshp");
    } else {
        if((![pc isEqual:nil]) && (c==nil)) {
            [pc removeRealtorForObject:p];
        } else {
            pc=c;
        }
        
    }

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
