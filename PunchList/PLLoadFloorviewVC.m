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
    [fpDict setObject:self.propertyTitle forKey:@"title"];
    [fpDict setObject:self.imageURL forKey:@"imageURL"];
    [fpDict setObject:self.imageTitle forKey:@"imageTitle"];
    [fpDict setObject:self.imageSequence forKey:@"imageSequence"];
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
//    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self displayImageFromURL:self.imageURL];
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    
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
            CCLog(@"urlIn=%@",urlIn);
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            __block UIImage *returnValue = nil;
            [library assetForURL:urlIn resultBlock:^(ALAsset *asset) {
                returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageDisplay setImage:returnValue];
                    [self.imageDisplay setNeedsDisplay];
                });
            } failureBlock:^(NSError *error) {
                NSLog(@"error : %@", error);
            }];
            //            [self.imageDisplay setImage:returnValue];
            //            [self.imageDisplay setNeedsDisplay];
            break;
        }
        default: {
            CCLog(@"Unknown hit default");
            break;
        }
            
    }

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
