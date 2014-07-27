//
//  PLContactsTVC.m
//  PunchList
//
//  Created by Chip Cox on 7/4/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLContactsTVC.h"
#import "PLPropertyDetailTVC.h"
#import "PLPropertyViewController.h"
#import "Contacts.h"
#import "Contacts+addon.h"

@interface PLContactsTVC () <UISearchBarDelegate, ABPeoplePickerNavigationControllerDelegate>
@property (strong,nonatomic) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet UISearchBar *searchString;
@property (nonatomic,strong) NSMutableArray *contactsArray;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL ABAuthorized;
@property (nonatomic,strong) NSString *personName;
@property (nonatomic,strong) NSString *activity;
@end

@implementation PLContactsTVC

- (NSMutableArray *) contacts
{
    if(!_contacts) _contacts=[[NSMutableArray alloc] init];
    return _contacts;
}

- (NSMutableArray *) contactsArray
{
    if(!_contactsArray) _contactsArray=[[NSMutableArray alloc] init];
    return _contactsArray;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIManagedDocument *)document
{
    if(!_document) {
        PLAppDelegate *delegate = (PLAppDelegate *)[[UIApplication sharedApplication] delegate];
        _document = delegate.document;
    }
    return _document;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self loadAddressData];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchString setDelegate:self];

    [self loadAddressData];
}

- (void) loadAddressData
{
    NSManagedObjectContext *context=self.document.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate =nil;
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    self.contactsArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if ((self.contactsArray == nil)||(self.contactsArray.count==0)) {
        CCLog(@"No records found");
    }
  
}

- (IBAction)refreshTable:(UIRefreshControl *)sender {
  //  [self loadAddressData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.contactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    // Configure the cell...
    Contacts *contact=[self.contactsArray objectAtIndex:indexPath.row];
    cell.textLabel.text=contact.name;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *senderCell=sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[PLPropertyDetailTVC class]] ) {
        PLPropertyDetailTVC *pdtvc=segue.destinationViewController;
        pdtvc.transferContact=senderCell.textLabel.text;
        pdtvc.transferIndexPath=self.transferIndexPath;
        CCLog(@"sender=%@",sender);
        CCLog(@"sender text=%@",senderCell.textLabel.text);
    } else {
        if([segue.destinationViewController isKindOfClass:[PLPropertyViewController class]]) {
            CCLog(@"Returning to plpropertyviewcontroller");
            NSManagedObjectContext *context=self.document.managedObjectContext;
            UITableViewCell *senderCell=sender;
            NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Contacts"];
            request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
            NSError *error;
            CCLog(@"senderCell.textlabel.text=%@",senderCell.textLabel.text);
            request.predicate=[NSPredicate predicateWithFormat:@"name = %@",senderCell.textLabel.text];
            NSArray *propArray=[context executeFetchRequest:request error:&error];
            CCLog(@"propArray=%@",propArray);
            
            if(!propArray) {
                CCLog(@"Error fetching contact for %@",senderCell.textLabel.text);
            } else {
                switch (propArray.count) {
                    case 0: {
                        CCLog(@"Adding new contact");
                        PLPropertyViewController *pdtvc=segue.destinationViewController;
                        pdtvc.transferIndexPath=self.transferIndexPath;
                        break;
                    }
                    case 1: {
                        CCLog(@"Updating contact");
                        PLPropertyViewController *pdtvc=segue.destinationViewController;
                        pdtvc.transferContact=[propArray objectAtIndex:0];
                        pdtvc.transferIndexPath=self.transferIndexPath;
                        break;
                    }
                    default: {
                        CCLog(@"Error somehow more than one record exists for %@",senderCell.textLabel.text);
                        break;
                    }
                }
            }
        }
    }
}

- (void) checkAddressBookAuthorization
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        CCLog(@"Denied");
        self.ABAuthorized=NO;
        return;
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        CCLog(@"Authorized");
        //[self loadAddressData];
        self.ABAuthorized=YES;
        return;
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        CCLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                //4
                CCLog(@"Just denied");
                self.ABAuthorized=NO;
                return;
            }
            //5
            CCLog(@"Just authorized");
            self.ABAuthorized=YES;
            return;
        });
    }
}

- (IBAction)AddressBookPeoplePicker:(UIBarButtonItem *)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}



// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NO];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    CCLog(@"person=%@",person);
    NSString *lastName= (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *firstName= (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    self.personName = [NSString stringWithFormat:@"%@, %@",lastName,firstName];
    NSMutableDictionary *c = [[NSMutableDictionary alloc] init];
    self.activity=@"";
    [c setObject:self.personName forKey:@"Name"];
    [Contacts addContact:c onContext:self.document.managedObjectContext];
    [self.document.managedObjectContext save:nil];
    [self dismissViewControllerAnimated:YES completion:NO];

    return NO;
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


@end
