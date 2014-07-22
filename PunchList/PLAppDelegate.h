//
//  PLAppDelegate.h
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CONTACT_SECTION 0
#define CONTACT_REALTOR 0
#define CONTACT_LOAN_OFFICER 1
#define CONTACT_BUILDER 2
#define PHOTO_SECTION 1
#define PHOTO_FLOORPLAN 0
#define PHOTO_ELEVATION 1


@interface PLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIManagedDocument *document;

@end
