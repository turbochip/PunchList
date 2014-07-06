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
#import "KMCSimpleTableViewController.h"

@interface PLViewController : UIViewController <KMCSimpleTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *PropertyScrollView;

@end
