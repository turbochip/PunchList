//
//  PLIssueViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLIssueViewController.h"
#import "Photos+addon.h"
#import "Photos.h"
#import "issue.h"
#import "Issue+addon.h"


@interface PLIssueViewController ()
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL cancel;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UITextView *activeField;
@property (nonatomic,strong) Photos *issuePhoto;

@end

@implementation PLIssueViewController

- (Photos *)issuePhoto
{
    if(!_issuePhoto) _issuePhoto=[[Photos alloc] init];
    return _issuePhoto;
}

- (NSManagedObjectContext *)context
{
    if(!_context) _context=self.document.managedObjectContext;
    return _context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cancel=NO;
    self.IssueImage.layer.borderWidth=1;
    // Do any additional setup after loading the view.
    self.IssueNumber.text=[[NSString alloc] initWithFormat:@"Issue : %d",[self.xIssue.itemNo integerValue] ];
    self.IssueDescription.text=[[NSString alloc] initWithFormat:@"%@",self.xIssue.title];
    
#warning fix this to get the correct photo not just any object
    Photos *photo=[self.xIssue.hasPhotos anyObject];
    self.issuePhoto=photo;
    [Photos displayImageFromURL:[NSURL URLWithString:photo.photoURL] inImageView:self.IssueImage];
    //    [self.IssueImage setImage: self.xIssue.photoOf[0]];
}


//Not sure if this is called
/*- (void) viewWillDisappear:(BOOL)animated
{
    if (!self.cancel)
    {
        CCLog(@"how did I get here");
    }
    
}
 */

// exit out by clicking cancel
- (void) closeScreenCancel: (BOOL) cancel
{
    self.cancel=cancel;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    // actually we do an update here to the issue information we already saved back in the main view controller
    NSMutableDictionary *updateDict=[[NSMutableDictionary alloc] init];
    [updateDict setObject:self.IssueDescription.text forKey:@"DESCRIPTION"];
    self.xIssue=[Issue updateIssue:self.xIssue withDictionary:updateDict onContext:self.document.managedObjectContext];
    //CCLog(@"xIssue.hasPhotos=%@, self.issuePhoto=%@",self.xIssue.hasPhotos,self.issuePhoto);
    BOOL found=NO;
    for(Photos *p in self.xIssue.hasPhotos) {
        //CCLog(@"p.photoURL=%@, self.issuePhoto.photoURL=%@",p.photoURL,self.issuePhoto.photoURL);
        if(p.photoURL==self.issuePhoto.photoURL) {
            found=YES;
            break;
        }
    }
    if(!found)
        [self.xIssue addHasPhotosObject:self.issuePhoto];
    [self closeScreenCancel:NO];
}

//Load pictures form photolibrary
- (IBAction)photoLibrary:(UIBarButtonItem *)sender {
    [self startPhotoLibraryFromViewController:self usingDelegate:self];
}

//Take a picture
- (IBAction)pictureButton:(UIBarButtonItem *)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];

}

//Cancel button to leave here
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
#warning need to add code to tell parent that it should remove place marker

    NSMutableDictionary *updateDict=[[NSMutableDictionary alloc] init];
    [updateDict setObject:self.IssueDescription.text forKey:@"DESCRIPTION"];
    [Issue deleteIssue:self.xIssue withDictionary:updateDict onContext:self.document.managedObjectContext];

    [self closeScreenCancel:YES];
}

// cancel button clicked either from taking picture or in the library
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//We have a picture coming back from the pickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // put url into issuePhoto which is a photo class object
    self.issuePhoto =[Photos addPhotoURL:[info objectForKey:UIImagePickerControllerReferenceURL] toContext:self.context];
    [self.issuePhoto setPhotoTitle:self.xIssue.title];
    //display the image on the screen.
    [self.IssueImage setImage:self.image];
    [self.IssueImage setNeedsDisplay];
    
    //close the pickercontroller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// show the camera controller view
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

// Show the photo library controller view
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



- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)textFieldDidBeginEditing:(UITextView *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextView *)textField
{
    self.activeField = nil;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.baseScrollView.contentInset = contentInsets;
    self.baseScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, CGPointMake(self.activeField.frame.size.width,self.activeField.frame.size.height)) ) {
        [self.baseScrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.baseScrollView.contentInset = contentInsets;
    self.baseScrollView.scrollIndicatorInsets = contentInsets;
}

@end
