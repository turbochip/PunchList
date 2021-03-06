//
//  PLIssueViewController.h
//  PunchList
//
//  Created by Chip Cox on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLItem.h"
#import "Issue.h"
#import "CCExtras.h"

@interface PLIssueViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong,nonatomic) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet UILabel *IssueNumber;
@property (weak, nonatomic) IBOutlet UITextView *IssueDescription;

@property (weak, nonatomic) IBOutlet UIImageView *IssueImage;
@property (strong,nonatomic) NSURL *issueImageURL;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@property (nonatomic,strong) Issue *xIssue;
@end
