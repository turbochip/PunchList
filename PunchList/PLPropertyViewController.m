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
    if([segue.destinationViewController isKindOfClass:[PLPropertySearchTVC class]]) {
        PLPropertySearchTVC *ps= segue.destinationViewController;
        ps.searchString=self.propertyNameField.text;
    } else {
        if([segue.destinationViewController isKindOfClass:[PLPropertyDetailTVC class]]) {
            PLPropertyDetailTVC *pdtvc=segue.destinationViewController;
            pdtvc.transferProperty=self.returnProperty;
        }
    }
}

- (IBAction)searchReturn:(UIStoryboardSegue *)sender
{
    CCLog(@"in searchReturn returnProp=%@",self.returnProperty.name);
    self.propertyNameField.text=self.returnProperty.name;
    self.StreetAddressField.text=self.returnProperty.streetAddress;
    self.CityAddressField.text=self.returnProperty.city;
    self.StateAddressField.text=self.returnProperty.state;
    self.zipAddressField.text=self.returnProperty.zip;
    
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
