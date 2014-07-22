//
//  PLPropertyViewController.h
//  PunchList
//
//  Created by Chip Cox on 7/5/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCExtras.h"
#import "Property.h"


@interface PLPropertyViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadImageBarButton;
@property (strong,nonatomic) Property *returnProperty;
@end
