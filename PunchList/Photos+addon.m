//
//  Photos+addon.m
//  PunchList
//
//  Created by Chip Cox on 7/27/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Photos+addon.h"

@implementation Photos (addon)

+(Photos *) addPhotoURL:(NSURL *)photoURL toContext:(NSManagedObjectContext *)context
{
    Photos *photo;
    if((photo=[self doesPhotoExistWithURL:photoURL inContext:context])==Nil) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photos" inManagedObjectContext:context];
        photo.photoURL=photoURL.path;
        photo.photoTitle=@"Unknown";
    } else {
        CCLog(@"Update existing photo");
        photo.photoURL=photoURL.path;
    }
    [context save:Nil];
    return photo;
}

+(Photos *) doesPhotoExistWithURL:(NSURL *)photoURL inContext:(NSManagedObjectContext *)context
{
    Photos *photoExists;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photos" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoURL=%@", photoURL.path];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = nil;
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        CCLog(@"Error searching for photo %@",photoURL);
    } else {
        if(fetchedObjects.count == 0) {
            photoExists=nil;
        } else {
            photoExists=fetchedObjects[0];
        }
    }
    return photoExists;
}


@end
