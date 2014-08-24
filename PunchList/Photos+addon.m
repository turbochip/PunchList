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
        photo.photoURL=[photoURL absoluteString];
        photo.photoTitle=@"Unknown";
    } else {
        CCLog(@"Update existing photo");
        photo.photoURL=[photoURL absoluteString];
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
    //CCLog(@"Checking for photo with url %@",[photoURL absoluteString]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoURL=%@", [photoURL absoluteString]];
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

+(void) displayImageFromURL:(NSURL*)urlIn inImageView: (UIImageView *)imageView
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    switch(status){
        case ALAuthorizationStatusDenied: {
            CCLog(@"not authorized");
            break;
        }
        case ALAuthorizationStatusRestricted: {
            CCLog(@"Restricted");
            break;
        }
        case ALAuthorizationStatusNotDetermined: {
            CCLog(@"Undetermined");
            break;
        }
        case ALAuthorizationStatusAuthorized: {
            CCLog(@"Authorized");
            //CCLog(@"urlIn=%@",urlIn.pathComponents);
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            __block UIImage *returnValue = nil;
            [library assetForURL:urlIn resultBlock:^(ALAsset *asset) {
                returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:returnValue];
                    [imageView setNeedsDisplay];
                });
            } failureBlock:^(NSError *error) {
                CCLog(@"error : %@", error);
            }];
            break;
        }
        default: {
            CCLog(@"Unknown hit default");
            break;
        }
    }
}

@end
