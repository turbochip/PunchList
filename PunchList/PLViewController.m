//
//  PLViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLViewController.h"
#import "PLAppDelegate.h"
#import "PLIssueViewController.h"
#import "PLPropertySearchTVC.h"
#import "FloorPlans+addon.h"
#import "FloorPlans.h"
#import "Property+addon.h"
#import "Property.h"
#import "Photos+addon.h"
#import "Photos.h"

@interface PLViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) UIImage *propertyImage;
@property (nonatomic,strong) PLfloorView *propertyImageView;
@property (nonatomic,strong) UIView *propertyViewOverlay;
@property (nonatomic,strong) UIView *propertyView;
@property (nonatomic) NSInteger selectedIssue;
@property (nonatomic,strong) NSMutableArray *propertyArray; //of Property
@property (weak, nonatomic) IBOutlet UITextField *propertyNameTextField;
@property (nonatomic,strong) UIManagedDocument *document;
@property (nonatomic,strong) Property *property;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation PLViewController

- (NSMutableArray *) propertyArray
{
    if(!_propertyArray) _propertyArray=[[NSMutableArray alloc] init];
    return _propertyArray;
}

- (UIManagedDocument *)document
{
    if(!_document) {
        PLAppDelegate *delegate = (PLAppDelegate *)[[UIApplication sharedApplication] delegate];
        _document = delegate.document;
    }
    return _document;
}


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
}

- (void) viewWillAppear:(BOOL)animated
{
    CCLog(@"view will now appear %d",self.selectedIssue);
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
- (IBAction)pageControlTap:(UIPageControl *)sender
{
    CCLog(@"currentPage %d, numberOfPages %d", self.pageControl.currentPage,self.pageControl.numberOfPages);
//    if(self.pageControl.currentPage+1<=self.pageControl.numberOfPages-1) {
//        self.pageControl.currentPage++;
//        CCLog(@"currentPage=%d",self.pageControl.currentPage);
//    }
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
            CCLog(@"Point already exists");
            for(PLItem *issue in self.itemArray)
                if(((issue.itemLoc.x>=locationOfTap.x-5) && (issue.itemLoc.x<=locationOfTap.x+5)) &&
                   ((issue.itemLoc.y>=locationOfTap.y-5) && (issue.itemLoc.y<=locationOfTap.y+5))) {
                    self.selectedIssue=issue.itemNumber;
                    [self performSegueWithIdentifier:@"IssueSegue" sender:self];
                }
            // we need to segue to a new screen showing the information about the existing point.
        } else {
            //we need to segue to a new screen allowing us to enter the information about the new point.
            CCLog(@"Adding point");
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

- (void) loadProperty:(Property *) prop
{
    self.propertyNameTextField.text=prop.name;
    NSMutableDictionary *photoDict=[[NSMutableDictionary alloc] init];
    NSMutableArray *fpArray=[[NSMutableArray alloc] init];
    for(FloorPlans *fp in prop.floorPlan){
        [photoDict setValue:fp.sequence forKey:@"SEQUENCE"];
        [photoDict setValue:fp.drawings forKey:@"DRAWING"];
        [photoDict setValue:fp.title forKey:@"TITLE"];
        [fpArray addObject:photoDict];
    }
    self.pageControl.numberOfPages=prop.floorPlan.count;
    self.pageControl.currentPage=0;
    self.pageControl.enabled=YES;
    // build image
    self.itemArray=nil;
    // Now we need to query the database for the name returned in selectedName.  That will give us our floor plans.
    // if there is more than one image associated with the property, then we can use a page control to navigate between them.
    //self.propertyImage =[UIImage imageNamed:@"Winston 1st Floor"];

    
    
    
    //from here on down will probably go into a delegate for a page control.
    self.propertyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    [self.PropertyScrollView addSubview:self.propertyView];


    //propertyimageview is a UIView subview that will lay on top of the imageview subview.
    // Build the view at the same size as the scroll view contents.
    self.propertyImageView=[[PLfloorView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    Photos *fpImage=[fpArray[0] valueForKey:@"DRAWING"];
    // add the image subview
    UIImageView *pIV=[[UIImageView alloc] initWithFrame:self.propertyImageView.frame];
    CCLog(@"fpImage.photoURL=%@",fpImage.photoURL);
    [Photos displayImageFromURL:[NSURL URLWithString:fpImage.photoURL] inImageView:pIV];
    [self.propertyView addSubview:pIV];
    [self.propertyView setNeedsDisplay];
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
    CCLog(@"Destination view controller is %@",[[segue destinationViewController] description]);
    // Get the new view controller using [segue destinationViewController].
    if([segue.destinationViewController isKindOfClass:[PLIssueViewController class]]) {
        PLIssueViewController *pivc=(PLIssueViewController *) segue.destinationViewController;
        pivc.xIssue=self.itemArray[self.selectedIssue];
    } else {
        if([segue.destinationViewController isKindOfClass:[PLPropertySearchTVC class]]) {
            PLPropertySearchTVC *pstvc=segue.destinationViewController;
            pstvc.searchString=self.propertyNameTextField.text;
        }
    }
}

- (IBAction)searchReturn:(UIStoryboardSegue *)sender
{
    CCLog(@"in searchReturn returnProp=%@",self.returnProperty.name);
    self.property=self.returnProperty;
    [self loadProperty:self.property];
}

@end
