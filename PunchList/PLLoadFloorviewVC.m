//
//  PLLoadFloorviewVC.m
//  PunchList
//
//  Created by Chip Cox on 7/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//
//  Allows user to select image from library, associate it with property, add a title and sequence to it.
//
#import "PLLoadFloorviewVC.h"
#import "PLPropertyViewController.h"
#import "Photos.h"
#import "Photos+addon.h"
#import "FloorPlans.h"
#import "FloorPlans+addon.h"

@interface PLLoadFloorviewVC ()
@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageDisplay;
@property (weak, nonatomic) IBOutlet UILabel *propertyTitle;
@property (weak, nonatomic) IBOutlet UITextField *imageTitle;
@property (weak, nonatomic) IBOutlet UITextField *imageSequence;
@property (nonatomic,strong) NSURL *imageURL;
@end

@implementation PLLoadFloorviewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.propertyTitle.text=self.property.name;
}

- (IBAction)saveButton:(UIBarButtonItem *)sender
{
    NSMutableDictionary *fpDict=[[NSMutableDictionary alloc] init];
    [fpDict setObject:self.propertyTitle.text forKey:@"title"];
    [fpDict setObject:self.imageURL forKey:@"imageURL"];
    CCLog(@"self.imageURL=%@",self.imageURL);
    [fpDict setObject:self.imageTitle.text forKey:@"imageTitle"];
    [fpDict setObject:[NSNumber numberWithInteger:[self.imageSequence.text integerValue]] forKey:@"imageSequence"];
    NSManagedObjectContext *context=[self.document managedObjectContext];
    [FloorPlans addFloorPlan:fpDict toProperty:self.property onContext:context];
}

- (IBAction)deleteButton:(UIBarButtonItem *)sender
{

}

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Camera Library Processing

- (IBAction)selectImageFromLibrary:(UIButton *)sender
{
    [self startPhotoLibraryFromViewController:self usingDelegate:self];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageURL=[info objectForKey:UIImagePickerControllerReferenceURL];
    CCLog(@"Image =%@",[info objectForKey:UIImagePickerControllerReferenceURL]);
    [Photos displayImageFromURL:self.imageURL inImageView:self.imageDisplay];
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

#pragma mark Segue Processing


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[PLPropertyViewController class]]) {
        CCLog(@"Preparing for segue to %@",segue.destinationViewController);
        
    } else {
        CCLog(@"Preparing to segue to unknown destination view controller %@",segue.destinationViewController);
    }
}


@end
