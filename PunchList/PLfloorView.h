//
//  PLfloorView.h
//  PunchList
//
//  Created by Chip Cox on 6/8/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLfloorView : UIView
@property (nonatomic) CGPoint ploc;
@property (nonatomic,strong) UIBezierPath *path;
- (void) drawPoint:(CGPoint) pointLoc;

@end
