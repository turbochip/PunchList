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

@interface PLContactsTVC () <ABNewPersonViewControllerDelegate, UISearchBarDelegate>
@property (strong,nonatomic) UIManagedDocument *document;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[PLPropertyDetailTVC class]] ) {
        PLPropertyDetailTVC *pdtvc=segue.destinationViewController;
        UITableViewCell *senderCell=sender;
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
            request.predicate=[NSPredicate predicateWithFormat:@"name = %@",senderCell.textLabel.text];
            NSArray *propArray=[context executeFetchRequest:request error:&error];
            CCLog(@"propArray=%@",propArray);
            
            if(!propArray) {
                CCLog(@"Error no idea how you got here");
            } else {
                PLPropertyViewController *pdtvc=segue.destinationViewController;
                pdtvc.transferContact=[propArray objectAtIndex:0];
                pdtvc.transferIndexPath=self.transferIndexPath;
                CCLog(@"sender=%@",sender);
                CCLog(@"sender text=%@",senderCell.textLabel.text);
            }
        }
    }
}


@end
