//
//  PieView.m
//  PieDrawDemo
//
//  Created by wangguopeng on 2016/11/14.
//  Copyright © 2016年 joymake. All rights reserved.
//

#import "PieView.h"
#import "MealModel.h"

@implementation PieView

-(void)setDataArrayM:(NSMutableArray *)dataArrayM{
    _dataArrayM = dataArrayM;
    [self drawPie];
}
- (void)drawPie{
    __weak __typeof (&*self)weakSelf = self;
    NSArray *colorarray = @[[UIColor orangeColor],[UIColor purpleColor],[UIColor redColor],[UIColor brownColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor greenColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor darkGrayColor]];
    
    
    CGPoint center = CGPointMake(self.center.x-(CGRectGetMaxX(self.frame)-CGRectGetMaxX(self.bounds)),self.center.y-(CGRectGetMaxY(self.frame)-CGRectGetMaxY(self.bounds)) );
    
    __block CGFloat startAngle = 0.0;
    __block CGFloat endAngle = 0.0;

    [self.dataArrayM enumerateObjectsUsingBlock:^(MealModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        endAngle = M_PI*2*model.mealRadius/ weakSelf.totalRadious + startAngle;
       
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:CGRectGetWidth(self.bounds)/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = [(UIColor *)colorarray[idx%colorarray.count] CGColor];
        layer.strokeColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
        CATextLayer *txtLayer = [self textLayer:model.mealName rotate:(endAngle - (endAngle-startAngle)/2)];
        [self.layer addSublayer:txtLayer];
        startAngle = endAngle;

    }];
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    path.lineWidth = 10;
    [path addArcWithCenter:center radius:CGRectGetWidth(self.frame)/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.strokeColor = [UIColor purpleColor].CGColor;
    [self.layer addSublayer:layer];
    
    
}

- (CATextLayer*)textLayer:(NSString*)text rotate:(CGFloat)angel
{
    CATextLayer *txtLayer = [CATextLayer layer];
    //设置每个layer的长度都为转盘的直径
    txtLayer.frame = CGRectMake(0, 0, self.bounds.size.width-self.layer.borderWidth*2-48, 25);
    
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


@end
