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

@interface PLPropertyViewController ()
@property (strong,nonatomic) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet UITextField *propertyNameField;
@property (weak, nonatomic) IBOutlet UITextField *StreetAddressField;
@property (weak, nonatomic) IBOutlet UITextField *CityAddressField;
@property (weak, nonatomic) IBOutlet UITextField *StateAddressField;
@property (weak, nonatomic) IBOutlet UITextField *zipAddressField;
@property (weak, nonatomic) IBOutlet UIStepper *ImageNumber;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toolbarButtonClick:(UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 0: {
            CCLog(@"Associate Pictures");
            break;
        }
        case 1: {
            CCLog(@"Associate Contacts");
            break;
        }
        case 2: {
            CCLog(@"Edit Property");
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

@end
