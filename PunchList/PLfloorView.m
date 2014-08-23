//
//  PLfloorView.m
//  PunchList
//
//  Created by Chip Cox on 6/8/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLfloorView.h"
#import "Issue+addon.h"
#import "Issue.h"
#import "PLItem.h"

@interface PLfloorView()
@property (nonatomic,strong) UIImageView * imgv;

@end
@implementation PLfloorView
@synthesize ploc=_ploc;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (NSMutableArray *) issuePoints
{
    if(!_issuePoints) _issuePoints=[[NSMutableArray alloc] init];
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
//    [self setNeedsDisplay];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for(Issue *issue in self.issuePoints) {
        self.ploc=CGPointMake([issue.locationX floatValue],[issue.locationY floatValue]);
 //       [self drawPoint:CGPointMake(self.ploc.x,self.ploc.y)];
    }
    
}


- (void) drawPoint:(CGPoint) pointLoc
{
    //use move to point, this raises the pen to avoid drawing lines between points.
    [self.path moveToPoint:pointLoc];
    CCLog(@"path=%@",self.path);
    [self.path addArcWithCenter:CGPointMake(pointLoc.x-4, pointLoc.y-4)
                         radius:10 startAngle:0
                       endAngle:(2*M_PI)
                      clockwise:YES];
    
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];

    [self.path stroke];
    [self.path fill];
    CCLog(@"Leaving drawPoint");
//    [self setNeedsDisplay];
}
@end
