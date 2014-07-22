//
//  PLFloorPlanAssociationVC.m
//  PunchList
//
//  Created by Chip Cox on 7/21/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLFloorPlanAssociationVC.h"
#import "PLAppDelegate.h"
#import "PLPropertyDetailTVC.h"

@interface PLFloorPlanAssociationVC ()

@end

@implementation PLFloorPlanAssociationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.destinationViewController isKindOfClass:[PLPropertyDetailTVC class]] ) {
         PLPropertyDetailTVC *pdtvc=segue.destinationViewController;
         pdtvc.transferIndexPath=self.transferIndexPath;
     }
 }

@end
