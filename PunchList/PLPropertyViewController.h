//
//  PLPropertyViewController.h
//  PunchList
//
//  Created by Chip Cox on 7/5/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCExtras.h"
#import "KMCSimpleTableViewController.h"

@interface PLPropertyViewController : UIViewController <KMCSimpleTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadImageBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addContactsBarButton;
@end
