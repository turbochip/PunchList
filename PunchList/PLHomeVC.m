//
//  PLHomeVC.m
//  PunchList
//
//  Created by Chip Cox on 7/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//
// basically this is our splash screen but we do some stuff in here like opening the database, etc

#import "PLHomeVC.h"
#import "PLAppDelegate.h"


@interface PLHomeVC ()
//@property (nonatomic,strong) NSURL *url;
@end

@implementation PLHomeVC

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
    self.document=[self openDatabaseDocument:@"PunchListDB"];
    
    PLAppDelegate *delegate = (PLAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delegate.document = self.document;
}

- (UIManagedDocument *)openDatabaseDocument:(NSString *)docName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory =[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = docName;
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    CCLog(@"url=%@",url.path);
    
    // Setup my document here
    UIManagedDocument *doc = [[UIManagedDocument alloc] initWithFileURL:url];
    // print out the url path just for fun.
    CCLog(@"url=%@ \n filePathURL=%@",[url path], [url pathComponents]);
    
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if(fileExists){
        // open file
        [doc openWithCompletionHandler:^(BOOL success) {
            if(success) [self documentIsReady];
        }];
    } else { // create file and open it at the same time.
        [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success)
                [self documentIsReady];
            else
                CCLog(@"Couldn't create document %@",url);
        }];
    }

    
    return doc;
}

- (void) documentIsReady
{
    CCLog(@"Database is open.");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCLog(@"Prepayring to segue");
}


@end
