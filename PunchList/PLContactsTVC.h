//
//  PLContactsTVC.h
//  PunchList
//
//  Created by Chip Cox on 7/4/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CCExtras.h"

@interface PLContactsTVC : UITableViewController
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong,nonatomic) NSIndexPath *transferIndexPath;


@end
