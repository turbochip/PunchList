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
#import "PLPropertyViewController.h"
#import "PLFloorIssueVC.h"

@interface PLPropertySearchTVC ()
@property (nonatomic,strong) UIManagedDocument *document;
@property (nonatomic,strong) NSArray *propArray;
@property (nonatomic,strong) Property *returnProp;
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
    
    [self searchForProperty:self.searchString];
    [self.tableView setDelegate:self];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.returnProp = [self.propArray objectAtIndex:indexPath.row];
    CCLog(@"selected row %d = %@",indexPath.row,self.returnProp.name);
//    [self.navigationController popViewControllerAnimated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCLog(@"segue destinationViewController=%@",segue.destinationViewController);
    if([segue.destinationViewController isKindOfClass:[PLPropertyViewController class]]){
        self.returnProp=[self.propArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        PLPropertyViewController *pvc=segue.destinationViewController;
        pvc.returnProperty=self.returnProp;
    } else {
        if([segue.destinationViewController isKindOfClass:[PLFloorIssueVC class]]) {
            PLFloorIssueVC *plvc=segue.destinationViewController;
            //CCLog(@"Returning property %@",[self.propArray objectAtIndex:[self.tableView indexPathForSelectedRow].row]);
            plvc.returnProperty=[self.propArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        }
    }
}



@end
