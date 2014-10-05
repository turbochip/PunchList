//
//  PLFloorIssueVC.m
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLFloorIssueVC.h"
#import "PLAppDelegate.h"
#import "PLIssueViewController.h"
#import "PLPropertySearchTVC.h"
#import "FloorPlans+addon.h"
#import "FloorPlans.h"
#import "Property+addon.h"
#import "Property.h"
#import "Photos+addon.h"
#import "Photos.h"
#import "Issue.h"
#import "Issue+addon.h"

@interface PLFloorIssueVC () <UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *issueArray;
@property (nonatomic,strong) UIImage *propertyImage;
@property (strong, nonatomic) UIImageView *pFPV;   // floorplan property view picture
@property (nonatomic,strong) PLfloorView *propertyIssueView;  // dots overlay over floor plan picture
@property (nonatomic,strong) UIView *propertyViewOverlay;
@property (nonatomic,strong) UIView *propertyView;
@property (nonatomic,strong) Issue *selectedIssue;
@property (nonatomic,strong) NSMutableArray *propertyArray; //of Property
@property (weak, nonatomic) IBOutlet UITextField *propertyNameTextField;
@property (nonatomic,strong) Property *property;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) NSManagedObjectContext *context;
@property (nonatomic,strong) NSMutableArray *fpArray;
@end

@implementation PLFloorIssueVC

#pragma mark Setters and Getters
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

- (NSManagedObjectContext *)context
{
    if(!_context) _context=self.document.managedObjectContext;
    return _context;
}

- (NSMutableArray *) issueArray
{
    if(!_issueArray) _issueArray= [[NSMutableArray alloc] init];
    return _issueArray;
}

#pragma mark screen setup

// we have a scorll view with a UIView for a subview
// The UIView has subviews for pIV (which holds the floor plans
// and a subview for propertyIssueView which holds the dots I think.
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
    
    // This is the subview that holds the floor plan image.
    self.pFPV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    [self.PropertyScrollView addSubview:self.pFPV];
    
    // This is the subview where we draw the issue dots.
    self.propertyIssueView=[[PLfloorView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
    [self.PropertyScrollView addSubview:self.propertyIssueView];
}

// required method for zooming
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // this gets called periodically while zooming occurs.
    // return the name of the view being zoomed.
    return self.pFPV;
//    return self.propertyView;
}

// handles switching between floorplans
- (IBAction)pageControlTap:(UIPageControl *)sender
{
    CCLog(@"currentPage %ld, numberOfPages %ld", (long)self.pageControl.currentPage,(long)self.pageControl.numberOfPages);
    [self loadFloorPlan:self.property];
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
        if([self.propertyIssueView.path containsPoint:locationOfTap])
        {
            CCLog(@"Point already exists");
            
            NSFetchRequest *fr=[NSFetchRequest fetchRequestWithEntityName:@"Issue"];
            
            fr.predicate=[NSPredicate predicateWithFormat:@"isOnFloorPlan=%@",[self.fpArray[self.pageControl.currentPage] objectForKey:@"FLOORPLAN"]];
            fr.sortDescriptors=nil;
            NSArray *rs=[self.context executeFetchRequest:fr error:nil];
            if((rs==nil) || (rs.count==0)) {
                CCLog(@"No issues found in database at all");
            } else {
                for(Issue *issue in rs) {
                    CCLog(@"lX=%f, lY=%f, tX=%f, tY=%f",issue.locationX.floatValue,issue.locationY.floatValue,locationOfTap.x,locationOfTap.y);
                    if(((issue.locationX.floatValue >=locationOfTap.x-5) && (issue.locationX.floatValue<=locationOfTap.x+5)) &&
                       ((issue.locationY.floatValue>=locationOfTap.y-5) && (issue.locationY.floatValue<=locationOfTap.y+5))) {
                        self.selectedIssue=issue;
                        [self performSegueWithIdentifier:@"IssueSegue" sender:self];
                        break;
                    }
                }
            }
        } else {
            CCLog(@"Adding point");
            NSMutableDictionary *newDict=[[NSMutableDictionary alloc] init];
            [newDict setObject:@"Issue Description" forKey:@"TITLE"];
            [newDict setObject:[NSNumber numberWithFloat:locationOfTap.x] forKey:@"LOCATIONX"];
            [newDict setObject:[NSNumber numberWithFloat:locationOfTap.y] forKey:@"LOCATIONY"];
            [newDict setObject:self.property forKey:@"PROPERTY"];
            for(FloorPlans *fpt in self.property.floorPlan) {
                CCLog(@"currentPage=%d, sequence=%d",self.pageControl.currentPage+1, [fpt.sequence integerValue]);
                if([fpt.sequence integerValue]==self.pageControl.currentPage+1) {
                    [newDict setObject:fpt forKey:@"FLOORPLAN"];
                    break;
                }
            }
            self.selectedIssue=[Issue addIssueFromDictionary:newDict toContext:self.context];
            [self.issueArray addObject:self.selectedIssue];
            [self performSegueWithIdentifier:@"IssueSegue" sender:self];
        }
    }
    [self updateUI];
}

// initialize screen with property information
- (void) loadProperty:(Property *) prop
{
    self.propertyNameTextField.text=prop.name;
    self.fpArray=nil;
    self.fpArray=[[NSMutableArray alloc] init];
    if(prop.floorPlan.count==0){
        CCLog(@"No floorplans available");
    } else {
        for(FloorPlans *fp in prop.floorPlan){
            NSMutableDictionary *photoDict=[[NSMutableDictionary alloc] init];
            [photoDict setValue:fp.sequence forKey:@"SEQUENCE"];
            [photoDict setValue:fp.drawings forKey:@"DRAWING"];
            [photoDict setValue:fp.title forKey:@"TITLE"];
            [photoDict setObject:fp forKey:@"FLOORPLAN"];
            [self.fpArray addObject:photoDict];
            photoDict=nil;
        }
        // sort fpArray on sequence just to make sure we have everything in order.
        NSSortDescriptor *sortSequence = [NSSortDescriptor sortDescriptorWithKey:@"SEQUENCE" ascending:YES];
        [self.fpArray sortUsingDescriptors:@[sortSequence]];
        // set page control based on the number of floorplans in the property returned.
        self.pageControl.numberOfPages=prop.floorPlan.count;
        self.pageControl.currentPage=0;
        self.pageControl.enabled=YES;
        [self loadFloorPlan:prop];
    }
}

- (void) loadFloorPlan:(Property *) prop
{
    // build image
    self.issueArray=nil;
    Photos *fpImage=[self.fpArray[self.pageControl.currentPage] valueForKey:@"DRAWING"];
    CCLog(@"fpImage.photoURL=%@",fpImage.photoURL);
    [Photos displayImageFromURL:[NSURL URLWithString:fpImage.photoURL] inImageView:self.pFPV];
    [self.propertyView setNeedsDisplay];
    
    NSFetchRequest *fr=[[NSFetchRequest alloc] initWithEntityName:@"Issue"];
    fr.predicate=[NSPredicate predicateWithFormat:@"isOnFloorPlan=%@",[self.fpArray[self.pageControl.currentPage] objectForKey:@"FLOORPLAN"]];
    fr.sortDescriptors=nil;
    //CCLog(@"fr.predicate=%@",fr.predicate);
    NSArray *rs=[self.context executeFetchRequest:fr error:nil];
    for (Issue *r in rs) {
        [self.issueArray addObject:r];
    }
    
    [self updateUI];

}

// updateUI is going to loop through all the issues for the active floorplan and display them.
- (void) updateUI
{
    self.propertyIssueView.issuePoints= self.issueArray;
    [self.propertyIssueView setNeedsDisplay];
}

#pragma mark segue processing
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCLog(@"Destination view controller is %@",[[segue destinationViewController] description]);
    // Get the new view controller using [segue destinationViewController].
    if([segue.destinationViewController isKindOfClass:[PLIssueViewController class]]) {
        PLIssueViewController *pivc=(PLIssueViewController *) segue.destinationViewController;
        pivc.document=self.document;
        pivc.xIssue=self.selectedIssue;
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
