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
@property (strong, nonatomic) IBOutlet UIStepper *stepper;

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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // add vertical stepper next to imageview
    CGRect frame = CGRectMake(245.0, 490.0, 25.0, 25.0);
    self.stepper = [[UIStepper alloc] initWithFrame:frame];
    self.stepper.transform= CGAffineTransformMakeRotation(degreesToRadians(-90));
    [self.view addSubview:self.stepper];
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
    }
}

- (void)resetUI
{
    self.builderObject=nil;
    self.loanOfficerObject=nil;
    self.realtorObject=nil;
    [self updateUI:nil];
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
            
            [self resetUI];
            break;
        }
        default: {
            CCLog(@"Unknown tabbar item pressed =%d", sender.tag);
            break;
        }
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
                    PLLoadFloorviewVC *lfv=segue.destinationViewController;
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
            [self updateUI:self.property];
        } else {
            CCLog(@"Unknown sourceViewController - %@",sender.sourceViewController);
        }
    }
}

@end
