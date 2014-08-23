//
//  Issue+addon.h
//  PunchList
//
//  Created by Chip Cox on 8/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Issue.h"
#import "CCExtras.h"

@interface Issue (addon)
+(Issue *)addIssueFromDictionary:(NSDictionary *)dict toContext:(NSManagedObjectContext *)context;
+(Issue *)updateIssue:(Issue *)issue withDictionary:(NSDictionary *)dict  onContext:(NSManagedObjectContext *) context;
+(void)deleteIssue:(Issue *) issue;
@end
