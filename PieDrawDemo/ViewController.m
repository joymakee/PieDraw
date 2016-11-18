//
//  ViewController.m
//  PieDrawDemo
//
//  Created by wangguopeng on 2016/11/14.
//  Copyright © 2016年 joymake. All rights reserved.
//

#import "ViewController.h"
#import "PieView.h"
#import "FeatherView.h"
#import "MealModel.h"

@interface ViewController ()<CAAnimationDelegate>{
    CGFloat _roatedValue ;
}
@property (nonatomic,strong)CABasicAnimation *transformAnimation;   //旋转动画
@property (nonatomic,strong)PieView *pie;   //转盘

@end

@implementation ViewController

#pragma mark lazyload method

-(PieView *)pie{
    return _pie = _pie?:[[PieView alloc]initWithFrame:CGRectMake(10, 120, CGRectGetWidth(self.view.bounds)-20, CGRectGetWidth(self.view.bounds)-20)];
}

-(CABasicAnimation *)transformAnimation{
    if (!_transformAnimation) {
        //设置旋转动画
        _transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _transformAnimation.delegate = self;
        _transformAnimation.fillMode = kCAFillModeForwards;
        _transformAnimation.removedOnCompletion = NO;
        _transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_transformAnimation setDuration:2];
    }
    return _transformAnimation;
}

#pragma mark life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"吃饭选择困难户";
    [self.view addSubview:self.pie];
    [self initDataSource];
    FeatherView *featherView = [[FeatherView alloc]initWithFrame:_pie.frame];
    __weak __typeof (&*self)weakSelf = self;
    [featherView drawFeatherViewTouchBlock:^{
        [weakSelf roate];
    }];
    [self.view addSubview:featherView];

}

#pragma mark initData
- (void)initDataSource{
    //数值代表所占比重
    NSArray *mealDicArray =@[@{@"宫保鸡丁":@1},@{@"西红柿炒鸡蛋":@1},@{@"干锅菜花":@1},@{@"鱼香肉丝":@1},@{@"麻辣香锅":@1},@{@"烩虾仁儿":@1},@{@"炸子蟹":@1},@{@"毛血旺":@1},@{@"麻婆豆腐":@1}];
    
    __block CGFloat totalRadius = 0.0;
    __block NSMutableArray *mealArrayM = [NSMutableArray arrayWithCapacity:mealDicArray.count];
    [mealDicArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
        MealModel *model = [[MealModel alloc]init];
        model.mealName = [dict allKeys][0];
        model.mealRadius = [[dict allValues][0] floatValue];
        [mealArrayM addObject:model];
        totalRadius +=model.mealRadius;
        }
    }];
    _pie.totalRadious = totalRadius;
    _pie.dataArrayM = mealArrayM;
}

#pragma mark animation
- (void)roate{
    _roatedValue = M_PI *(float)(arc4random()%314)/157;
    self.transformAnimation.toValue = @(6*M_PI +_roatedValue);
    [_pie.layer addAnimation:self.transformAnimation forKey:@"position"];
}

#pragma mark animation stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.transformAnimation.fromValue = @(_roatedValue);
    __block CGFloat totalValue = 0;
    __weak __typeof (&*self)weakSelf = self;
    [_pie.dataArrayM enumerateObjectsUsingBlock:^(MealModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        totalValue += model.mealRadius;
        if (2*M_PI * totalValue/weakSelf.pie.totalRadious + _roatedValue>=2*M_PI) {
        MealModel *model = weakSelf.pie.dataArrayM[idx];
        NSLog(@"你选中了%@",model.mealName);
        *stop = YES;
        }
    }];
}

@end
