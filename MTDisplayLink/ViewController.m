//
//  ViewController.m
//  MTDisplayLink
//
//  Created by mtt0150 on 15/9/7.
//  Copyright (c) 2015年 MT. All rights reserved.
//

#import "ViewController.h"
#define IMAGECOUNT 10
@interface ViewController ()
//图片下标
@property (assign, nonatomic) int index;
@property (strong, nonatomic) CALayer *fishLayer;
//存储图片的数组
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = [UIScreen mainScreen].bounds;
    _imageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:_imageView];
    //创建一个子图层，用来显示这条鱼
    self.fishLayer = [CALayer layer];
    _fishLayer.bounds = CGRectMake(0, 0, 87, 32);
    _fishLayer.position = CGPointMake(160, 500);
    [self.view.layer addSublayer:_fishLayer];
    //创建一个数组用来存储鱼儿的图片缓存
    self.imageArray = [NSMutableArray array];
    for (int i = 0; i < IMAGECOUNT; i++) {
        NSString *imageString = [NSString stringWithFormat:@"fish%i.png",i];
        //取出一张图片放入数组进行保存
        UIImage *image = [UIImage imageNamed:imageString];
        [_imageArray addObject:image];
    }
    
    //定义一个时钟对象
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImage)];
    //将时钟加入到主循环中
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    //添加一个动画组
    [self animationGroup];
    //添加一个手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGesture];
    
}
- (void)tap{
    //为背景添加一个水波纹
    [self backTransitionAnimation];
}
- (void)animationGroup{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //添加一个关键帧动画，这个动画负责可以让鱼儿在一个圆圈里面游动
    CAKeyframeAnimation *ellipseAnimation = [self ellipseAnimation];
    animationGroup.animations = @[ellipseAnimation
                                  ];
    animationGroup.duration = 5;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.autoreverses = YES;
    [self.fishLayer addAnimation:animationGroup forKey:@"animationGroup"];
}
- (CAKeyframeAnimation *)ellipseAnimation{
    CAKeyframeAnimation *ellipseAnimation = [CAKeyframeAnimation animation];
    ellipseAnimation.keyPath = @"position";
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.fishLayer.position.x, self.fishLayer.position.y);
    CGPathAddCurveToPoint(path, NULL, 300, 400, 20, 300, 200, 100);
    ellipseAnimation.path = path;
    CGPathRelease(path);
    return ellipseAnimation;
}
- (void)backTransitionAnimation{
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.duration = 2;
    transition.repeatCount = 2;
    [_imageView.layer addAnimation:transition forKey:@"transition"];
}
//因为iOS屏幕每一秒会去更新60次，所以每一次的刷新都会去调用这个函数，但是这里我打算减少他的更新次数
- (void)updateImage{
    static int number = 0;
    if (++number % 6 == 0) {
        UIImage *image = _imageArray[_index];
        self.fishLayer.contents = (id)image.CGImage;
        self.index = (++_index) % IMAGECOUNT;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
