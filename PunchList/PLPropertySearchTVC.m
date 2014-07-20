//
//  PLPropertySearchTVC.m
//  PunchList
//
//  Created by Chip Cox on 7/20/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLPropertySearchTVC.h"
#import "PLAppDelegate.h"
#import "Property.h"
#import "Property+addon.h"

@interface PLPropertySearchTVC ()
@property (nonatomic,strong) UIManagedDocument *document;
@property (nonatomic,strong) NSArray *propArray;
@end

@implementation PLPropertySearchTVC

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self searchForProperty:self.searchString];
}

-(void) searchForProperty:(NSString *) searchName
{
    self.propArray=[Property searchProperty:searchName onContext:self.document.managedObjectContext];
    
    if((!self.propArray) || (self.propArray.count==0)) {
        CCLog(@"No Properties matching %@ found",searchName);
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.propArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Property *prop = [self.propArray objectAtIndex:indexPath.row];
    cell.textLabel.text=prop.name;
    NSString *scsz=[NSString stringWithFormat:@"%@ / %@ / %@ / %@",prop.streetAddress,prop.city,
                    prop.state,prop.zip];
    cell.detailTextLabel.text=scsz;
    scsz=nil;
    
    return cell;
}

@end
