//
//  PLPropertyDetailTVC.h
//  PunchList
//
//  Created by Chip Cox on 7/21/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCExtras.h"
#import "PLAppDelegate.h"
#import "Property.h"

@interface PLPropertyDetailTVC : UITableViewController
@property (nonatomic,strong) UIManagedDocument *document;
@property (nonatomic,strong) NSIndexPath *transferIndexPath;
@property (nonatomic,strong) NSString *transferContact;
@property (nonatomic,strong) NSString *transferFloorplan;
@property (nonatomic,strong) Property *transferProperty;

@end
