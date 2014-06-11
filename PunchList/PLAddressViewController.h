//
//  PLAddressViewController.h
//  PunchList
//
//  Created by Chip Cox on 6/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PLAddressViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@end
