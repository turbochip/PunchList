//
//  PLIssueViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLIssueViewController.h"

@interface PLIssueViewController ()
@property (nonatomic) BOOL cancel;
@end

@implementation PLIssueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)CancelButton:(UIBarButtonItem *)sender {
    self.cancel=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cancel=NO;
    // Do any additional setup after loading the view.
    self.IssueNumber.text=[[NSString alloc] initWithFormat:@"Issue : %d",self.xIssue.itemNumber ];
    self.IssueDescription.text=[[NSString alloc] initWithFormat:@"%@",self.xIssue.itemDescription];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (!self.cancel)
        self.xIssue.itemDescription=self.IssueDescription.text;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
