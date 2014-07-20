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
//    PLAppDelegate *delegate = (PLAppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.document = delegate.document;

}

- (void)itemSelectedatRow:(NSInteger)row
{
    CCLog(@"row %lu selected", (unsigned long)row);
    //NSString *selectedName=[self.pArray objectAtIndex:row];

    //[self searchForProperty:selectedName];

//    // build image
//    self.itemArray=nil;
//    // Now we need to query the database for the name returned in selectedName.  That will give us our floor plans.
//    // if there is more than one image associated with the property, then we can use a page control to navigate between them.
//    self.propertyImage =[UIImage imageNamed:@"Winston 1st Floor"];
//    
//    
//    //from here on down will probably go into a delegate for a page control.
//    self.propertyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
//    [self.PropertyScrollView addSubview:self.propertyView];
//    
//    
//    //propertyimageview is a UIView subview that will lay on top of the imageview subview.
//    // Build the view at the same size as the scroll view contents.
//    self.propertyImageView=[[PLfloorView alloc] initWithFrame:CGRectMake(0, 0, self.PropertyScrollView.contentSize.width, self.PropertyScrollView.contentSize.height)];
//    // add the image subview
//    [self.propertyView addSubview:[[UIImageView alloc] initWithImage:self.propertyImage]];
//    // add the UIView subview to hold the bezier dots representing items.
//    [self.propertyView addSubview:self.propertyImageView];
//    
//    
//    [self updateUI];
    
}


//-(void) searchForProperty:(NSString *) searchName
//{
//    NSArray *propArray=[Property searchProperty:self.propertyNameField.text onContext:self.document.managedObjectContext];
//    
//    if((!propArray) || (propArray.count==0)) {
//        CCLog(@"No Properties matching %@ found",self.propertyNameField.text);
//    } else {
//        if(propArray.count==1) {
//            Property *prop=[propArray objectAtIndex:0];
//            CCLog(@"Only one property don't bother with tableview");
//            self.propertyNameField.text=prop.name;
//            self.StreetAddressField.text=prop.streetAddress;
//            self.CityAddressField.text=prop.city;
//            self.StateAddressField.text=prop.state;
//            self.zipAddressField.text=prop.zip;
//        } else {
//            CCLog(@"More than one property found, display tableview");
//            self.pArray=nil;
//            for(Property *prop in propArray) {
//                [self.pArray addObject:prop.name];
//            }
//            [self loadSTVCPropertyArray:self.pArray];
//        }
//    }
//}

//-(void) loadSTVCPropertyArray:(NSArray *)propertyArray
//{
//    UINavigationController *navigationController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SimpleTableVC"];
//    KMCSimpleTableViewController *tableViewController = (KMCSimpleTableViewController *)[[navigationController viewControllers] objectAtIndex:0];
//    tableViewController.tableData = propertyArray;
//    tableViewController.navigationItem.title = @"Property";
//    tableViewController.delegate = self;
//    [self presentViewController:navigationController animated:YES completion:nil];
//
//}
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
//            PLAppDelegate *delegate = (PLAppDelegate *)[[UIApplication sharedApplication] delegate];
//            self.document = delegate.document;
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
    if([segue.destinationViewController isKindOfClass:[PLPropertySearchTVC class]]) {
        PLPropertySearchTVC *ps= segue.destinationViewController;
        ps.searchString=self.propertyNameField.text;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
