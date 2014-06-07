//
//  PLViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLViewController.h"
#import "PLItem.h"

@interface PLViewController ()
@property (nonatomic,strong) NSMutableArray *itemArray;
@end

@implementation PLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.PropertyScrollView.contentSize=CGSizeMake(2000, 2000);
    [self.PropertyScrollView setDecelerationRate:0.0];
    [self.PropertyScrollView setBouncesZoom:NO];
    [self updateUI];
    
}

- (NSMutableArray *) itemArray
{
    if(!_itemArray) _itemArray= [[NSMutableArray alloc] init];
    return _itemArray;
}

- (IBAction)scrollTap:(UITapGestureRecognizer *)sender {
    CGPoint locationOfTap=[sender locationInView:sender.view];
    NSLog(@"tap at location %f,%f",locationOfTap.x,locationOfTap.y);
    PLItem *newItem= [[PLItem alloc] init];
    newItem.itemDescription=@"Test Description";
    newItem.itemLoc=locationOfTap;
    [self.itemArray addObject:newItem];
}

- (void) updateUI
{
    UIImage *propertyName =[UIImage imageNamed:@"Winston 1st Floor"];
    UIImageView *propertyImageView = [[UIImageView alloc] initWithImage:propertyName];
    [self.PropertyScrollView addSubview:propertyImageView];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
