//
//  PLPropertyDetailTVC.m
//  PunchList
//
//  Created by Chip Cox on 7/21/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLPropertyDetailTVC.h"
#import "PLAppDelegate.h"
//#import "PLContactAssociationVC.h"
//#import "PLFloorPlanAssociationVC.h"
#import "PLContactsTVC.h"
#import "Property+addon.h"
#import "Property.h"
#import "Contacts+addon.h"
#import "Contacts.h"

@interface PLPropertyDetailTVC ()

@end

@implementation PLPropertyDetailTVC

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

    CCLog(@"Segue to %d:%d",indexPath.section,indexPath.row );
    
/*    if([segue.destinationViewController isKindOfClass:[PLContactsTVC class]]) {
        PLContactAssociationVC *avc=segue.destinationViewController;
        avc.transferIndexPath=indexPath;
    } else {
        if([segue.destinationViewController isKindOfClass:[PLFloorPlanAssociationVC class]]) {
            PLFloorPlanAssociationVC *fpvc=segue.destinationViewController;
            fpvc.transferIndexPath=indexPath;
        } else {
            CCLog(@"Unknown segue destination");
        }
    }
 */
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)returnSegue:(UIStoryboardSegue *)sender
{
    CCLog(@"sender=%@",sender);
    CCLog(@"indexpath=%d, %d",self.transferIndexPath.section,self.transferIndexPath.row);
    NSManagedObjectContext *context=self.document.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Property"];
    request.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    request.predicate=[NSPredicate predicateWithFormat:@"name = %@",[self.transferProperty valueForKey:@"Name" ]];
    NSArray *propArray=[context executeFetchRequest:request error:&error];
    
    if((!propArray) || (propArray.count!=1)){
        CCLog(@"Error executing fetch %@",[self.transferProperty valueForKeyPath:@"Name"]);
    }else {
        Property *p=[propArray objectAtIndex:0];
        switch (self.transferIndexPath.section) {
            case CONTACT_SECTION: {
                switch (self.transferIndexPath.row) {
                    case CONTACT_REALTOR: {
                        CCLog(@"Store realtor %@",self.transferContact);
                        // store realtor contact in database
                        NSMutableDictionary *cDict=[[NSMutableDictionary alloc] init];
                        [cDict setObject:p forKey:@"Property"];
                        [cDict setObject:self.transferContact forKey:@"Name"];
                        [cDict setObject:@"Realtor" forKey:@"Activity"];
                        [Contacts addContact:cDict onContext:context];
                        break;
                    }
                    case CONTACT_LOAN_OFFICER: {
                        CCLog(@"Store loan officer %@",self.transferContact);
                        NSMutableDictionary *cDict=[[NSMutableDictionary alloc] init];
                        [cDict setObject:p forKey:@"Property"];
                        [cDict setObject:self.transferContact forKey:@"Name"];
                        [cDict setObject:@"Loan Officer" forKey:@"Activity"];
                        [Contacts addContact:cDict onContext:context];
                        // store loan officer contact in database
                        break;
                    }
                    case CONTACT_BUILDER: {
                        CCLog(@"Store builder %@",self.transferContact);
                        NSMutableDictionary *cDict=[[NSMutableDictionary alloc] init];
                        [cDict setObject:p forKey:@"Property"];
                        [cDict setObject:self.transferContact forKey:@"Name"];
                        [cDict setObject:@"Builder" forKey:@"Activity"];
                        [Contacts addContact:cDict onContext:context];
                        // store builder contact in database
                        break;
                    }
                    default: {
                        CCLog(@"Unknown contact type");
                        break;
                    }
                }
                break; // contact section break;
            }
            case PHOTO_SECTION: {
                switch (self.transferIndexPath.row) {
                    case PHOTO_FLOORPLAN: {
                        CCLog(@"Store floorplan");
                        // store floorplan photos in database
                        break;
                    }
                    case PHOTO_ELEVATION: {
                        CCLog(@"Store elevation photos");
                        // store elevation photos in database
                        break;
                    }
                    default: {
                        CCLog(@"Unknow photo type");
                        break;
                    }
                }
                break; // photo section break
            }
            default: {
                CCLog(@"Unknow section");
                break;
            }
        }
    }
}

@end
