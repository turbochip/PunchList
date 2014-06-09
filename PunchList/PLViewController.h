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

@interface PLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *PropertyName;
@property (weak, nonatomic) IBOutlet UIScrollView *PropertyScrollView;

@end
