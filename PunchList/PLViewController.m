//
//  PLViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLViewController.h"
#import "PLIssueViewController.h"

@interface PLViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) UIImage *propertyImage;
@property (nonatomic,strong) PLfloorView *propertyImageView;
@property (nonatomic,strong) UIView *propertyViewOverlay;
@property (nonatomic,strong) UIView *propertyView;
@property (nonatomic) NSInteger selectedIssue;
@end

@implementation PLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.PropertyScrollView.contentSize=CGSizeMake(2000, 2000);
    [self.PropertyScrollView setDecelerationRate:0.0];
    [self.PropertyScrollView setBouncesZoom:NO];
    // we can't zoom in any more, but we can zoom out.
    [self.PropertyScrollView setMaximumZoomScale:1];
    [self.PropertyScrollView setMinimumZoomScale:0.05];
    [self.PropertyScrollView setDelegate:self];
    [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"view will now appear %d",self.selectedIssue);
}

// required method for zooming
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // this gets called periodically while zooming occurs.
    // return the name of the view being zoomed.
    return self.propertyView;
}

- (NSMutableArray *) itemArray
{
    if(!_itemArray) _itemArray= [[NSMutableArray alloc] init];
    return _itemArray;
}

// multiple functions based on state when tap is performed.
- (IBAction)scrollTap:(UITapGestureRecognizer *)sender {
    CGPoint locationOfTap=[sender locationInView:sender.view];
    CGFloat currentZoomScale=self.PropertyScrollView.zoomScale;
    // first if we are zoomed, we need to unzoom to the area where the tap was.
    if(currentZoomScale!=1 ) {
        //Figure out the screen size and divide by 2 so we know how much room on the left and top to offset to get the tap point in the middle of the screen.
        CGPoint screenCenter=CGPointMake(self.PropertyScrollView.frame.size.width/2, self.PropertyScrollView.frame.size.height/2);
        CGRect newRect = CGRectMake((locationOfTap.x/currentZoomScale)-screenCenter.x, (locationOfTap.y/currentZoomScale)-screenCenter.y, 200, 200);
        // zoom back to normal size
        [self.PropertyScrollView setZoomScale:1 animated:YES];
        //scroll to the center point animated.
        [self.PropertyScrollView scrollRectToVisible:newRect animated:YES];
    }
    else {
        // ok, we are zoomed at the normal level so are we clicking on an existing point or a new point
        if([self.propertyImageView.path containsPoint:locationOfTap])
        {
            NSLog(@"Point already exists");
            for(PLItem *issue in self.itemArray)
                if(((issue.itemLoc.x>=locationOfTap.x-5) && (issue.itemLoc.x<=locationOfTap.x+5)) &&
                   ((issue.itemLoc.y>=locationOfTap.y-5) && (issue.itemLoc.y<=locationOfTap.y+5))) {
                    self.selectedIssue=issue.itemNumber;
                    [self performSegueWithIdentifier:@"IssueSegue" sender:self];
                }
            // we need to segue to a new screen showing the information about the existing point.
        } else {
            //we need to segue to a new screen allowing us to enter the information about the new point.
            NSLog(@"Adding point");
            PLItem *newItem= [[PLItem alloc] init];
            newItem.itemDescription=@"Test Description";
            newItem.itemLoc=locationOfTap;
            newItem.itemPic=[[UIImage alloc] init];
            [self.itemArray addObject:newItem];
            [[self.itemArray lastObject] setItemNumber:self.itemArray.count-1];
            self.selectedIssue=self.itemArray.count-1;
            [self performSegueWithIdentifier:@"IssueSegue" sender:self];
        }
    }
    [self updateUI];
}

- (IBAction)loadProperty:(UIButton *)sender
{
    // build image
    self.itemArray=nil;
    // In the future we will build this name based on a selected text field.
    self.propertyImage =[UIImage imageNamed:@"Winston 1st Floor"];
    
    self.propertyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    [self.PropertyScrollView addSubview:self.propertyView];

    
    //propertyimageview is a UIView subview that will lay on top of the imageview subview.
    // Build the view at the same size as the scroll view contents.
    self.propertyImageView=[[PLfloorView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    // add the image subview
    [self.propertyView addSubview:[[UIImageView alloc] initWithImage:self.propertyImage]];
    // add the UIView subview to hold the bezier dots representing items.
    [self.propertyView addSubview:self.propertyImageView];
    
    
    [self updateUI];
    
}

- (void) updateUI
{
    for(PLItem *item in self.itemArray) {
        //redraw each item in the uiview subview
        self.propertyImageView.ploc=item.itemLoc;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    NSLog(@"Destination view controller is %@",[[segue destinationViewController] description]);
    PLIssueViewController *pivc=(PLIssueViewController *) segue.destinationViewController;
    pivc.xIssue=self.itemArray[self.selectedIssue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
