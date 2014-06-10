//
//  PLIssueViewController.h
//  PunchList
//
//  Created by Chip Cox on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLItem.h"

@interface PLIssueViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *IssueNumber;
@property (weak, nonatomic) IBOutlet UITextView *IssueDescription;

@property (weak, nonatomic) IBOutlet UIImageView *IssueImage;

@property (nonatomic) PLItem * xIssue;
@end
