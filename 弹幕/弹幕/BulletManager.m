//
//  BulletManager.m
//  弹幕
//
//  Created by tarena on 16/8/3.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

/** 弹幕的数据来源 */
@property (nonatomic , strong)NSMutableArray *dataSource;
/** 弹幕使用过程中的数组变量 */
@property (nonatomic , strong)NSMutableArray *bulletComments;
/** 存储过程中的view数组变量 */
@property (nonatomic , strong)NSMutableArray *bulletViews;
/** 是否停止动画 */
@property(nonatomic , assign)BOOL isStopAnimation;


@end

@implementation BulletManager
- (instancetype)init {
    if (self = [super init]) {
        self.isStopAnimation = YES;
    }
    
    return self;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        if (self.contentArray) {
            _dataSource = [NSMutableArray arrayWithArray:_contentArray];
        }else {
        _dataSource  = [NSMutableArray arrayWithArray:@[@{@"image":@"1" , @"title":@"评论123" },@{@"image":@"2" , @"title":@"这就是一个坑" },@{@"image":@"3" , @"title":@"文明发言" },@{@"image":@"1" , @"title":@"66666" },@{@"image":@"2" , @"title":@"骚男快跑吧，打不过了" },@{@"image":@"2" , @"title":@"你这样好吗？" }]];
        }
    }
    return _dataSource;
}
- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments  = [NSMutableArray array];
    }
    
    
    return _bulletComments;
}
- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews  = [NSMutableArray array];
    }
    
    
    return _bulletViews;
}
#pragma mark -- 真正的方法
- (void)startWithDuration:(float)duration {
    if (!self.isStopAnimation) {
        return;
    }
    
    self.isStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletCommentWithDuration:duration ];

}
- (void)stop {
    if (self.isStopAnimation) {
        return;
    }
    self.isStopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}
//取出下一个弹幕
- (NSDictionary *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSDictionary *dic = [self.bulletComments firstObject];
    if (dic) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return dic;
}
//初始化弹幕 随机分配弹幕轨迹
- (void)initBulletCommentWithDuration:(float)duration {
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        if (self.bulletComments.count > 0) {
            //通过随机数获取弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            //从弹幕数组中逐一的取出弹幕数据
            NSDictionary *dic = [self.bulletComments firstObject];
            NSString *comment = dic[@"title"];
            NSString *image = dic[@"image"];
            [self.bulletComments removeObjectAtIndex:0];
            //创建弹幕view
            [self creatBulletView:comment withImage:image trajectory:trajectory withDuration:duration];
        }
    }
}
#pragma mark -- 创建弹幕view
- (void)creatBulletView:(NSString *)comment withImage:(NSString *)image trajectory:(int)trajectory withDuration:(float)duration{
    if (self.isStopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc] initWithComment:comment withImage:image];
    
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    view.moveStatusBloak = ^ (MoveStatus status){
        if (weakSelf.isStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:
                //弹幕开始进入屏幕 ，将创建的view加入到bulletViews
                [weakSelf.bulletViews addObject:weakView];
                break;
            case Enter:
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中创建一个弹幕
            {
                NSDictionary *dic = [weakSelf nextComment];;
                NSString *comment = dic[@"title"];
                NSString *image = dic[@"image"];
                if (comment) {
                    [weakSelf creatBulletView:comment withImage:image trajectory:trajectory withDuration:duration];
                }
                break;
            }
            case End: {
                //弹幕飞出屏幕
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                if (weakSelf.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕了，开始循环滚动了
                    self.isStopAnimation = YES;
                    if (self.isRepeat) {
                        [weakSelf startWithDuration:duration];
                    }
                    
                }
                
            }
                break;
                
            default:
                break;
        }
    
    };
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
     [view startAnimationWithDuration:duration];
}

@end
