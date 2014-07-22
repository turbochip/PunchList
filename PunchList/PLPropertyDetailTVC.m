//
//  PLPropertyDetailTVC.m
//  PunchList
//
//  Created by Chip Cox on 7/21/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLPropertyDetailTVC.h"
#import "PLContactAssociationVC.h"
#import "PLFloorPlanAssociationVC.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

    CCLog(@"Segue to %d:%d",indexPath.section,indexPath.row );
    
    if([segue.destinationViewController isKindOfClass:[PLContactAssociationVC class]]) {
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)returnSegue:(UIStoryboardSegue *)sender
{
    switch (self.transferIndexPath.section) {
        case CONTACT_SECTION: {
            switch (self.transferIndexPath.row) {
                case CONTACT_REALTOR: {
                    CCLog(@"Store realtor");
                    // store realtor contact in database
                    break;
                }
                case CONTACT_LOAN_OFFICER: {
                    CCLog(@"Store loan officer");
                    // store loan officer contact in database
                    break;
                }
                case CONTACT_BUILDER: {
                    CCLog(@"Store builder");
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

@end
