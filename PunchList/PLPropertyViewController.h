//
//  PLPropertyViewController.h
//  PunchList
//
//  Created by Chip Cox on 7/5/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import "CCExtras.h"
#import "Property.h"
#import "Contacts.h"


@interface PLPropertyViewController : UIViewController //<UIImagePickerControllerDelegate>
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadImageBarButton;
@property (strong,nonatomic) Property *returnProperty;
@property (nonatomic,strong) Contacts *transferContact;
@property (nonatomic,strong) NSIndexPath *transferIndexPath;

@end
