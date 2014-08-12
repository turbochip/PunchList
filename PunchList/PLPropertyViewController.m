//
//  PLPropertyViewController.m
//  PunchList
//
//  Created by Chip Cox on 7/5/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLPropertyViewController.h"
#import "PLAppDelegate.h"
#import "Property+addon.h"
#import "Property.h"
#import "PLPropertySearchTVC.h"
#import "PLPropertyDetailTVC.h"
#import "PLContactsTVC.h"
#import "Contacts.h"
#import "PLLoadFloorviewVC.h"
#import "FloorPlans.h"
#import "FloorPlans+addon.h"
#import "Photos+addon.h"
#import "Photos.h"

@interface PLPropertyViewController ()
@property (strong,nonatomic) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet UITextField *propertyNameField;
@property (weak, nonatomic) IBOutlet UITextField *StreetAddressField;
@property (weak, nonatomic) IBOutlet UITextField *CityAddressField;
@property (weak, nonatomic) IBOutlet UITextField *StateAddressField;
@property (weak, nonatomic) IBOutlet UITextField *zipAddressField;
@property (weak, nonatomic) IBOutlet UIStepper *ImageNumber;
@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *ImageDisplay;
@property (weak, nonatomic) IBOutlet UITextField *loanOfficerField;
@property (strong,nonatomic) Contacts *loanOfficerObject;
@property (weak, nonatomic) IBOutlet UITextField *builderField;
@property (strong,nonatomic) Contacts *builderObject;
@property (weak, nonatomic) IBOutlet UITextField *realtorField;
@property (strong,nonatomic) Contacts *realtorObject;
@property (strong,nonatomic) Property *property;
@property (nonatomic) NSInteger ccStepper;
@property (strong, nonatomic) NSMutableArray *drawings;

@property (strong,nonatomic) NSMutableArray *pArray;

@end

@implementation PLPropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *) drawings
{
    if(!_drawings) _drawings=[[NSMutableArray alloc] init];
    return _drawings;
}

- (NSMutableArray *) pArray
{
    if(!_pArray) _pArray=[[NSMutableArray alloc] init];
    return _pArray;
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
    // Do any additional setup after loading the view.
    self.ImageDisplay.layer.borderWidth=1;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    self.ccStepper=0;
    
    // add vertical stepper next to imageview
}

- (void)updateUI:(Property *) prop
{
    if(prop==nil) {
        CCLog(@"prop is nil");
        self.propertyNameField.text=@"";
        self.StreetAddressField.text=@"";
        self.CityAddressField.text=@"";
        self.StateAddressField.text=@"";
        self.zipAddressField.text=@"";
        self.realtorField.text=@"";
        self.loanOfficerField.text=@"";
        self.builderField.text=@"";
    } else {
        CCLog(@"prop.name=%@",prop.name);
        self.propertyNameField.text=(prop.name=NULL ? @"" : prop.name);
        self.StreetAddressField.text=(prop.streetAddress=NULL ? @"" : prop.streetAddress);
        self.CityAddressField.text=(prop.city=NULL ? @"" : prop.city);
        self.StateAddressField.text=(prop.state=NULL ? @"" : prop.state);
        self.zipAddressField.text=(prop.zip=NULL ? @"" : prop.zip);
        self.realtorField.text=(prop.realtor.name=NULL ? @"" : prop.realtor.name);
        self.loanOfficerField.text=(prop.loanOfficer.name=NULL ? @"" : prop.loanOfficer.name);
        self.builderField.text=(prop.builder.name=NULL ? @"" : prop.builder.name);
        if(self.drawings.count!=0){
            Photos *photo=[self.drawings objectAtIndex:self.ccStepper];
            CCLog(@"photo url=%@",photo.photoURL);
            [self displayImageFromURL:[NSURL URLWithString:photo.photoURL]];
        }
    }
}

- (void) displayImageFromURL:(NSURL*)urlIn
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    switch(status){
        case ALAuthorizationStatusDenied: {
            CCLog(@"not authorized");
            break;
        }
        case ALAuthorizationStatusRestricted: {
            CCLog(@"Restricted");
            break;
        }
        case ALAuthorizationStatusNotDetermined: {
            CCLog(@"Undetermined");
            break;
        }
        case ALAuthorizationStatusAuthorized: {
            CCLog(@"Authorized");
            CCLog(@"urlIn=%@",urlIn.pathComponents);
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            __block UIImage *returnValue = nil;
            [library assetForURL:urlIn resultBlock:^(ALAsset *asset) {
                returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.ImageDisplay setImage:returnValue];
                    [self.ImageDisplay setNeedsDisplay];
                });
            } failureBlock:^(NSError *error) {
                NSLog(@"error : %@", error);
            }];
            break;
        }
        default: {
            CCLog(@"Unknown hit default");
            break;
        }
            
    }
    
}


- (void)resetUI
{
    self.builderObject=nil;
    self.loanOfficerObject=nil;
    self.realtorObject=nil;
    self.drawings=nil;
    self.ImageDisplay.image=nil;
    [self updateUI:nil];
}

- (IBAction)ccStepper:(UIButton *)sender
{
    switch (sender.tag) {
        case 0: {
            if(self.ccStepper<self.drawings.count-1)
                self.ccStepper++;
            break;
        }
        case 1: {
            if(self.ccStepper==0) {
                self.ccStepper=0;
            } else {
                self.ccStepper--;
            }
            break;
        }
        default:
            break;
    }
    [self updateUI:self.property];
}

- (IBAction)toolbarButtonClick:(UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 0: {
            CCLog(@"Associate Pictures");
            break;
        }
        case 1: {
            CCLog(@"Clear fields");
            [self resetUI];
            break;
        }
        case 2: {
            CCLog(@"Delete Property");
            break;
        }
        case 3: {
            CCLog(@"Save Property");
            [self saveProperty];
            
            [self resetUI];
            break;
        }
        default: {
            CCLog(@"Unknown tabbar item pressed =%d", sender.tag);
            break;
        }
    }
}

- (void) saveProperty
{
    NSManagedObjectContext *context=self.document.managedObjectContext;
    NSMutableDictionary *propertyDict=[[NSMutableDictionary alloc] init];
    
    [propertyDict setObject:self.propertyNameField.text forKey:@"Name"];
    [propertyDict setObject:self.StreetAddressField.text forKey:@"Street"];
    [propertyDict setObject:self.CityAddressField.text forKey:@"City"];
    [propertyDict setObject:self.StateAddressField.text forKey:@"State"];
    [propertyDict setObject:self.zipAddressField.text forKey:@"ZIP"];
    [propertyDict setObject:self.realtorObject==nil ? [NSNull null] :self.realtorObject forKey:@"Realtor"];
    [propertyDict setObject:self.loanOfficerObject==nil ? [NSNull null] :self.loanOfficerObject forKey:@"LoanOfficer"];
    [propertyDict setObject:self.builderObject==nil ? [NSNull null] :self.builderObject forKey:@"Builder"];
    
    
    if(!(self.property = [Property addProperty:propertyDict onContext:context])) {
        CCLog(@"Error adding or updating property");
    }
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCLog(@"segue destinationViewController=%@",segue.destinationViewController);
    CCLog(@"sender =%@",sender);
    if([segue.destinationViewController isKindOfClass:[PLPropertySearchTVC class]]) {
        PLPropertySearchTVC *ps= segue.destinationViewController;
        ps.searchString=self.propertyNameField.text;
    } else {
        if([segue.destinationViewController isKindOfClass:[PLPropertyDetailTVC class]]) {
            PLPropertyDetailTVC *pdtvc=segue.destinationViewController;
            pdtvc.transferProperty=self.returnProperty;
        } else {
            if([segue.destinationViewController isKindOfClass:[PLContactsTVC class]]) {
                PLContactsTVC *avc=segue.destinationViewController;
                avc.transferIndexPath=[[NSIndexPath alloc] init];
                UIButton *myButton=(UIButton *)sender;
                avc.transferIndexPath=[NSIndexPath indexPathForRow:myButton.tag inSection:0];
            } else {
                if([segue.destinationViewController isKindOfClass:[PLLoadFloorviewVC class]]) {
                    [self saveProperty];
                    PLLoadFloorviewVC *lfv=segue.destinationViewController;
                    lfv.document=self.document;
                    lfv.property=self.property;
                }
            }
        }
    }
}

- (IBAction)searchReturn:(UIStoryboardSegue *)sender
{
    CCLog(@"sender=%@",sender.sourceViewController);
    if([sender.sourceViewController isKindOfClass:[PLContactsTVC class]]) {
        CCLog(@"We came back from PLContactsTVC indexpath=%d",self.transferIndexPath.row);
        switch (self.transferIndexPath.row) {
            case 1: {
                self.realtorField.text=self.transferContact.name;
                self.realtorObject=self.transferContact;
                CCLog(@"realtorObject=%@",self.realtorObject);
                break;
            }
            case 2: {
                self.loanOfficerField.text=self.transferContact.name;
                self.loanOfficerObject=self.transferContact;
                CCLog(@"loanOfficerObject=%@",self.loanOfficerObject);
                break;
            }
            case 3: {
                self.builderField.text=self.transferContact.name;
                self.builderObject=self.transferContact;
                CCLog(@"builderObject=%@",self.builderObject);
                break;
            }
            default: {
                CCLog(@"Invalid indexpath %d",self.transferIndexPath.row);
            }
        }
    } else {
        if([sender.sourceViewController isKindOfClass:[PLPropertySearchTVC class]]) {
            CCLog(@"in searchReturn returnProp=%@",self.returnProperty.name);
            self.realtorObject=self.returnProperty.realtor;
            self.loanOfficerObject=self.returnProperty.loanOfficer;
            self.builderObject=self.returnProperty.builder;
            self.property=self.returnProperty;
            for (FloorPlans *fp in self.returnProperty.floorPlan) {
                CCLog(@"prop.floorplan = %@",fp.drawings);
                [self.drawings addObject:fp.drawings];
            }
            self.ccStepper=0;
            [self updateUI:self.property];
        } else {
            if([sender.sourceViewController isKindOfClass:[PLLoadFloorviewVC class]]) {
                CCLog(@"Back from PLLoadFloorviewVC");
                for (FloorPlans *fp in self.property.floorPlan) {
                    CCLog(@"prop.floorplan = %@",fp.drawings);
                    [self.drawings addObject:fp.drawings];
                }

                [self updateUI:self.property];
            }else {
            CCLog(@"Unknown sourceViewController - %@",sender.sourceViewController);
            }
        }
    }
}

@end
