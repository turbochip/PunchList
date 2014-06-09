//
//  PLViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLViewController.h"
//#import "PLItem.h"
//#import "PLfloorView.h"

@interface PLViewController ()
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) UIImage *propertyImage;
@property (nonatomic,strong) PLfloorView *propertyImageView;
@property (nonatomic,strong) UIView *propertyViewOverlay;
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
    [self updateUI];
}

- (IBAction)loadProperty:(UIBarButtonItem *)sender {
    // build image
    self.itemArray=nil;
    self.propertyImage =[UIImage imageNamed:@"Winston 1st Floor"];
    
    //propertyimageview is a uiview that will store the subview with the image.
    self.propertyImageView=[[PLfloorView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    [self.PropertyScrollView addSubview:[[UIImageView alloc] initWithImage:self.propertyImage]];
    [self.PropertyScrollView addSubview:self.propertyImageView];
    
    
    [self updateUI];
    
}

- (void) updateUI
{
    for(PLItem *item in self.itemArray) {
        self.propertyImageView.ploc=item.itemLoc;
        //[self.propertyImageView drawPoint:item.itemLoc];
    }
//    [self.PropertyScrollView addSubview:self.propertyImageView];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
