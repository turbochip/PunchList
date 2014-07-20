//
//  PLContactsTVC.m
//  PunchList
//
//  Created by Chip Cox on 7/4/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLContactsTVC.h"

@interface PLContactsTVC () <ABNewPersonViewControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchString;
@property (nonatomic,strong) NSMutableArray *aBook;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PLContactsTVC

- (NSMutableArray *) contacts
{
    if(!_contacts) _contacts=[[NSMutableArray alloc] init];
    return _contacts;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchString setDelegate:self];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                    target:self
                                    action:@selector(addContact:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        CCLog(@"Denied");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        CCLog(@"Authorized");
        [self loadAddressData];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        CCLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                //4
                CCLog(@"Just denied");
                return;
            }
            //5
            CCLog(@"Just authorized");
        });
    }

}
- (IBAction)refreshTable:(UIRefreshControl *)sender {
    [self loadAddressData];
}

- (void) loadAddressData
{
    ABAddressBookRef addressbook=ABAddressBookCreateWithOptions(nil, nil);
    CCLog(@"self.searchString=%@",self.searchString.text);
    if([self.searchString.text isEqual:@""]) {
        self.aBook= (__bridge NSMutableArray *)(ABAddressBookCopyArrayOfAllPeople(addressbook));
    } else {
        self.aBook= (__bridge NSMutableArray *)(ABAddressBookCopyPeopleWithName(addressbook, (__bridge CFStringRef)(self.searchString.text)));
    }
    [self.tableView reloadData];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self loadAddressData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self loadAddressData];
}

- (IBAction)addContact:(UIBarButtonItem *)sender
{
    CCLog(@"Add Contact clicked");
    ABNewPersonViewController *newPerson=[[ABNewPersonViewController alloc] init];
    newPerson.newPersonViewDelegate=self;
    UINavigationController *newNavigationController=[[UINavigationController alloc]
                                                     initWithRootViewController:newPerson];
    [self presentViewController:newNavigationController animated:YES completion:^{
        [self loadAddressData];
        }];
}

- (void) newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [self.aBook count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    // Configure the cell...
    ABRecordRef person=(__bridge ABRecordRef)([self.aBook objectAtIndex:indexPath.row]);
    if(ABRecordGetRecordType(person)==kABPersonType){
        CCLog(@"person=%@, %@",ABRecordCopyValue(person, kABPersonLastNameProperty),ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *addName=[[NSString alloc] initWithFormat:@"%@, %@",ABRecordCopyValue(person, kABPersonLastNameProperty),ABRecordCopyValue(person, kABPersonFirstNameProperty)];
        cell.textLabel.text=addName;
        cell.detailTextLabel.text=(__bridge NSString *)(ABRecordCopyValue(person, kABPersonOrganizationProperty));
    }

    return cell;
}




// OLD CODE
/*
- (IBAction)searchContacts:(UIButton *)sender {
    
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

@end
