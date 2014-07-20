//
//  PLHomeVC.h
//  PunchList
//
//  Created by Chip Cox on 7/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCExtras.h"

@interface PLHomeVC : UIViewController
@property (nonatomic,strong) UIManagedDocument *document;


- (UIManagedDocument *)openDatabaseDocument:(NSString *)docName;
@end
