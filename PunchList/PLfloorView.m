//
//  PLfloorView.m
//  PunchList
//
//  Created by Chip Cox on 6/8/14.
//  Copyright (c) 2014 Home. All rights reserved.
//
// class to handle dots on the floor

#import "PLfloorView.h"
#import "Issue+addon.h"
#import "Issue.h"
#import "PLItem.h"

@interface PLfloorView()
@property (nonatomic,strong) UIImageView * imgv;

@end
@implementation PLfloorView
@synthesize ploc=_ploc;

#pragma mark    Setters & Getters
- (NSMutableArray *) issuePoints
{
    if(!_issuePoints) _issuePoints=[[NSMutableArray alloc] init];
    //we've got new points to display (this is set outside of this class)
    [self setNeedsDisplay];
    return _issuePoints;
}

- (UIBezierPath *) path
{
    if(!_path) _path=[[UIBezierPath alloc] init];
    return _path;
}

- (void) setPloc:(CGPoint) p
{
    _ploc=CGPointMake(p.x, p.y);
    [self drawPoint:_ploc];
    
}

#pragma mark    screen initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // re-initialize the path
    self.path=nil;
    //go through all the issuepoints and assign points for each issue
    for(Issue *issue in self.issuePoints) {
        self.ploc=CGPointMake([issue.locationX floatValue],[issue.locationY floatValue]);
    }
    
}


- (void) drawPoint:(CGPoint) pointLoc
{
    //use move to point, this raises the pen to avoid drawing lines between points.
    [self.path moveToPoint:pointLoc];
    //CCLog(@"path=%@",self.path);
    [self.path addArcWithCenter:CGPointMake(pointLoc.x-4, pointLoc.y-4)
                         radius:10 startAngle:0
                       endAngle:(2*M_PI)
                      clockwise:YES];
    
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];

    [self.path stroke];
    [self.path fill];
    //CCLog(@"Leaving drawPoint");
}
@end
