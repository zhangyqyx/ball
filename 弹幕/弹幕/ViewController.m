//
//  ViewController.m
//  弹幕
//
//  Created by tarena on 16/8/3.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITextFieldDelegate>

/** 管理者 */
@property (nonatomic , strong)BulletManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.manager = [[BulletManager alloc] init];
    __weak typeof(self) myself = self;
    self.manager.generateViewBlock = ^(BulletView * view){
        [myself addBulletView:view];
    };
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"stop" forState:UIControlStateNormal];
    btn.frame = CGRectMake(250, 100, 100, 40);
    [btn addTarget:self action:@selector(clickStopBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)clickBtn {
    self.manager.contentArray = @[@{@"image":@"1" , @"title":@"评论123" },@{@"image":@"2" , @"title":@"这就是一个坑" },@{@"image":@"3" , @"title":@"文明发言" },@{@"image":@"1" , @"title":@"66666" },@{@"image":@"2" , @"title":@"骚男快跑吧，打不过了" },@{@"image":@"4" , @"title":@"你这样好吗？"},@{@"image":@"1" , @"title":@"你们大家都好有才的呀!"}];
    //是否重复
    self.manager.isRepeat = YES;
    [self.manager startWithDuration:4.0];
}
- (void)clickStopBtn {
    [self.manager stop];
}
- (void)addBulletView:(BulletView *)view {
    view.frame = CGRectMake(screenWidth, 300 + view.trajectory * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
}

@end
