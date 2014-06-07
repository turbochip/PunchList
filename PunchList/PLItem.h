//
//  PLItem.h
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLItem : NSObject
@property (nonatomic,strong) NSString *itemDescription;
@property (nonatomic,strong) NSMutableArray *itemPic;
@property (nonatomic) CGPoint itemLoc;
@end