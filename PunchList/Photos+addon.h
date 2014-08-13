//
//  Photos+addon.h
//  PunchList
//
//  Created by Chip Cox on 7/27/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Photos.h"
#import "CCExtras.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface Photos (addon)

+(Photos *) addPhotoURL:(NSURL *)photoURL toContext:(NSManagedObjectContext *)context;
+(Photos *) doesPhotoExistWithURL:(NSURL *)photoURL inContext:(NSManagedObjectContext *)context;
+(void) displayImageFromURL:(NSURL*)urlIn inImageView: (UIImageView *)imageView;

@end
