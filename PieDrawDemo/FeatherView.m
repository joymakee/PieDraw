//
//  FeatherView.m
//  PieDrawDemo
//
//  Created by wangguopeng on 2016/11/14.
//  Copyright © 2016年 joymake. All rights reserved.
//

#import "FeatherView.h"
#import <objc/runtime.h>

@interface FeatherView ()
@property (nonatomic,strong)UIBezierPath *centerPath;
@end

@implementation FeatherView

- (UIBezierPath *)centerPath{
    return _centerPath = _centerPath?:[[UIBezierPath alloc]init];
}

- (void)drawFeatherViewTouchBlock:(VOIDBLOCK)touchBlock{
    objc_setAssociatedObject(self, @selector(touchesEnded:withEvent:), touchBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    CGPoint center = CGPointMake(self.center.x-(CGRectGetMaxX(self.frame)-CGRectGetMaxX(self.bounds)),self.center.y-(CGRectGetMaxY(self.frame)-CGRectGetMaxY(self.bounds)) );
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(center.x+CGRectGetWidth(self.bounds)/3, center.y)];
    [path addArcWithCenter:center radius:CGRectGetWidth(self.frame)/14 startAngle:M_PI/4 endAngle:M_PI*7/4 clockwise:YES];
    [path closePath];
    [path addArcWithCenter:CGPointMake(center.x+CGRectGetWidth(self.bounds)/3, center.y) radius:CGRectGetWidth(self.frame)/120 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor orangeColor].CGColor;
    layer.strokeColor = [[UIColor purpleColor] CGColor];
    [self.layer addSublayer:layer];
    
    [self.centerPath addArcWithCenter:center radius:CGRectGetWidth(self.frame)/30 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [self.centerPath addLineToPoint:CGPointMake(center.x+CGRectGetWidth(self.bounds)/3, center.y)];
    [self.centerPath closePath];
    CAShapeLayer *centerLayer = [CAShapeLayer layer];
    centerLayer.path = self.centerPath.CGPath;
    centerLayer.fillColor = [UIColor purpleColor].CGColor;
    centerLayer.strokeColor = [UIColor purpleColor].CGColor;
    [self.layer addSublayer:centerLayer];
    
    CATextLayer *txtLayer = [self textLayer:@"Go" rotate:0];
    [self.layer addSublayer:txtLayer];
}

- (CATextLayer*)textLayer:(NSString*)text rotate:(CGFloat)angel
{
    CATextLayer *txtLayer = [CATextLayer layer];

    txtLayer.frame = CGRectMake(0, 0, 25, 25);
    
    //设置锚点，绕中心点旋转
    txtLayer.anchorPoint = CGPointMake(0.5, 0.5);
    txtLayer.string = text;
    txtLayer.alignmentMode = [NSString stringWithFormat:@"right"];
    txtLayer.fontSize = 18;
    txtLayer.foregroundColor = [UIColor grayColor].CGColor;
    
    txtLayer.shadowColor = [UIColor yellowColor].CGColor;
    txtLayer.shadowOffset = CGSizeMake(5, 2);
    txtLayer.shadowRadius = 6;
    txtLayer.shadowOpacity = 0.6;
    
    //layer没有center，用Position
    [txtLayer setPosition:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2)];
    //旋转
    txtLayer.transform = CATransform3DMakeRotation(angel,0,0,1);
    return txtLayer;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    if ([self.centerPath containsPoint:point]) {
        VOIDBLOCK touchBlock = objc_getAssociatedObject(self, _cmd);
        touchBlock?touchBlock():nil;
        NSLog(@"touch (x, y) is (%d, %d)", x, y);
    }
}
@end
