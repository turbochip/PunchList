//
//  PLViewController.h
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLItem.h"
#import "PLfloorView.h"
#import "Property+addon.h"
#import "Property.h"
#import "CCExtras.h"

@interface PLViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIScrollView *PropertyScrollView;
@property (nonatomic,strong) Property *returnProperty;

@end
