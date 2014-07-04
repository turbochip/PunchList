//
//  PLIssueViewController.m
//  PunchList
//
//  Created by Chip Cox on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLIssueViewController.h"

@interface PLIssueViewController ()
@property (nonatomic) BOOL cancel;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UITextView *activeField;

@end

@implementation PLIssueViewController

- (void) closeScreenCancel: (BOOL) cancel
{
    self.cancel=cancel;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {
#warning Need to add save code in here.
    [self closeScreenCancel:NO];
}

- (IBAction)photoLibrary:(UIBarButtonItem *)sender {
    [self startPhotoLibraryFromViewController:self usingDelegate:self];
}

- (IBAction)pictureButton:(UIBarButtonItem *)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];

}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
#warning need to add code to tell parent that it should remove place marker
    [self closeScreenCancel:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cancel=NO;
    // Do any additional setup after loading the view.
    self.IssueNumber.text=[[NSString alloc] initWithFormat:@"Issue : %ld",(long)self.xIssue.itemNumber ];
    self.IssueDescription.text=[[NSString alloc] initWithFormat:@"%@",self.xIssue.itemDescription];
    [self.IssueImage setImage:self.xIssue.itemPic];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (!self.cancel)
    {
        self.xIssue.itemDescription=self.IssueDescription.text;
        self.xIssue.itemPic=self.image;
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [self.IssueImage setImage:self.image];
    [self.IssueImage setNeedsDisplay];
    
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
