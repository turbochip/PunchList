//
//  PLfloorView.m
//  PunchList
//
//  Created by Chip Cox on 6/8/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PLfloorView.h"
#import "PLItem.h"

@interface PLfloorView()
@property (nonatomic,strong) UIImageView * imgv;
@property (nonatomic,strong) UIBezierPath *path;
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

- (UIBezierPath *) path
{
    if(!_path) _path=[[UIBezierPath alloc] init];
    return _path;
}
- (void) setPloc:(CGPoint) p
{
    _ploc=CGPointMake(p.x, p.y);
    [self setNeedsDisplay];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawPoint:CGPointMake(self.ploc.x,self.ploc.y)];
    
}


- (void) drawPoint:(CGPoint) pointLoc
{
    [self.path moveToPoint:pointLoc];
    [self.path addArcWithCenter:CGPointMake(pointLoc.x-2, pointLoc.y-2) radius:5 startAngle:0 endAngle:(2*M_PI) clockwise:YES];
//    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(pointLoc.x-2, pointLoc.y-2, 5, 5)];
//    [self.path moveToPoint:pointLoc];
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];

    [self.path stroke];
    [self.path fill];
    [self setNeedsDisplay];
    [self.path closePath];
    
}
@end
