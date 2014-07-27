//
//  PLLoadFloorviewVC.h
//  PunchList
//
//  Created by Chip Cox on 7/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CCExtras.h"
#import "Property+addon.h"
#import "Property.h"

@interface PLLoadFloorviewVC : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) Property *property;
@end
