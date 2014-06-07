//
//  PLItem.m
//  PunchList
//
//  Created by Chip Cox on 6/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLItem.h"

@implementation PLItem

- (NSMutableArray *) itemPic
{
    if(!_itemPic) _itemPic=[[NSMutableArray alloc] init];
    return _itemPic;
}

- (NSString *) itemDescription
{
    if(!_itemDescription) _itemDescription=@"";
    return _itemDescription;
}

@end
