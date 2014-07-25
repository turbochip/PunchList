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
#import "PLContactAssociationVC.h"
#import "Contacts.h"

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
@property (weak,nonatomic) Contacts *loanOfficerObject;
@property (weak, nonatomic) IBOutlet UITextField *builderField;
@property (weak,nonatomic) Contacts *builderObject;
@property (weak, nonatomic) IBOutlet UITextField *realtorField;
@property (weak,nonatomic) Contacts *realtorObject;

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
    CGRect frame = CGRectMake(235.0, 500.0, 25.0, 25.0);
    self.stepper = [[UIStepper alloc] initWithFrame:frame];
    self.stepper.transform= CGAffineTransformMakeRotation(degreesToRadians(-90));
    [self.view addSubview:self.stepper];
}

- (IBAction)realtorSearch:(UIButton *)sender {
}

- (IBAction)loanOfficerSearch:(UIButton *)sender {
}

- (IBAction)builderSearch:(UIButton *)sender {
}

- (IBAction)toolbarButtonClick:(UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 0: {
            CCLog(@"Associate Pictures");
            [self startPhotoLibraryFromViewController:self usingDelegate:self];
            break;
        }
        case 1: {
            CCLog(@"Associate Contacts");
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
            [propertyDict setObject:self.realtorObject forKey:@"Realtor"];
            [propertyDict setObject:self.loanOfficerObject forKey:@"LoanOfficer"];
            [propertyDict setObject:self.builderObject forKey:@"Builder"];
            
            
            if(![Property addProperty:propertyDict onContext:context]) {
                CCLog(@"Error adding or updating property");
            }
            
            self.propertyNameField.text=@"";
            self.StreetAddressField.text=@"";
            self.CityAddressField.text=@"";
            self.StateAddressField.text=@"";
            self.zipAddressField.text=@"";
            
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
                PLContactAssociationVC *avc=segue.destinationViewController;
                avc.transferIndexPath=[[NSIndexPath alloc] init];
                UIButton *myButton=(UIButton *)sender;
                avc.transferIndexPath=[NSIndexPath indexPathForRow:myButton.tag inSection:0];
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
                break;
            }
            case 2: {
                self.loanOfficerField.text=self.transferContact.name;
                self.loanOfficerObject=self.transferContact;
                break;
            }
            case 3: {
                self.builderField.text=self.transferContact.name;
                self.builderObject=self.transferContact;
                break;
            }
            default: {
                CCLog(@"Invalid indexpath %d",self.transferIndexPath.row);
            }
        }
    } else {
        if([sender.sourceViewController isKindOfClass:[PLPropertySearchTVC class]]) {
            CCLog(@"in searchReturn returnProp=%@",self.returnProperty.name);
            CCLog(@"contactData=%@",self.returnProperty.contactData);
            self.propertyNameField.text=self.returnProperty.name;
            self.StreetAddressField.text=self.returnProperty.streetAddress;
            self.CityAddressField.text=self.returnProperty.city;
            self.StateAddressField.text=self.returnProperty.state;
            self.zipAddressField.text=self.returnProperty.zip;
            for (Contacts *c in self.returnProperty.contactData) {
                if([c.activity isEqualToString:@"Realtor"]) {
                    self.realtorField.text=c.name;
                } else {
                    if ([c.activity isEqualToString:@"Loan Officer"]) {
                        self.loanOfficerField.text=c.name;
                    } else {
                        if ([c.activity isEqualToString:@"Builder"]) {
                            self.builderField.text=c.name;
                        } else {
                            CCLog(@"Invalid activity");
                        }
                    }
                }
            }
        } else {
            CCLog(@"Unknown sourceViewController - %@",sender.sourceViewController);
        }
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    CCLog(@"Image =%@",[info objectForKey:UIImagePickerControllerReferenceURL]);
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.ImageDisplay setImage:self.image];
    [self.ImageDisplay setNeedsDisplay];
    
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) startPhotoLibraryFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

@end
