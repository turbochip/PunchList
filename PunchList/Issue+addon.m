//
//  Issue+addon.m
//  PunchList
//
//  Created by Chip Cox on 8/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Issue+addon.h"
#import "CCExtras.h"
@implementation Issue (addon)

+(NSInteger)countIssuesOnContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fr=[[NSFetchRequest alloc] initWithEntityName:@"Issue"];
    fr.predicate=nil;
    fr.sortDescriptors=nil;
    NSArray *rs=[context executeFetchRequest:fr error:nil];
    return rs.count;
}

+(Issue *)addIssueFromDictionary:(NSDictionary *)dict toContext:(NSManagedObjectContext *)context
{
    Issue *i = [NSEntityDescription insertNewObjectForEntityForName:@"Issue" inManagedObjectContext:context];
    i.title =[dict valueForKey:@"TITLE"];
    i.locationX=[dict valueForKey:@"LOCATIONX"];
    i.locationY=[dict valueForKey:@"LOCATIONY"];
    i.isOnFloorPlan=[dict valueForKey:@"FLOORPLAN"];
    i.isForProperty=[dict valueForKey:@"PROPERTY"];
    i.itemNo=[NSNumber numberWithInteger:[Issue countIssuesOnContext:context]+1];
    return i;
}

+(Issue *)updateIssue:(Issue *)issue withDictionary:(NSDictionary *)dict onContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *fr=[[NSFetchRequest alloc] initWithEntityName:@"Issue"];
    fr.predicate=[NSPredicate predicateWithFormat:@"itemNo=%d",[issue.itemNo integerValue]];
    fr.sortDescriptors=nil;
    NSArray *rs=[context executeFetchRequest:fr error:nil];
    if((!rs) || (rs.count==0)) {
        CCLog(@"no issues found for issueNo %d",[issue.itemNo integerValue]);
    }
    Issue *i = [rs objectAtIndex:0];
    i.title=[dict valueForKey:@"DESCRIPTION"];
//    NSMutableSet *tset=[[NSMutableSet alloc] init];
//    [tset addobject:[dict valueForKey:@"PHOTOOF"]];
//    [i addHasPhotoObject:[dict valueForKey:@"PHOTOOF"]];
    return i;
}
+(void)deleteIssue:(Issue *) issue
{
    
}

@end
