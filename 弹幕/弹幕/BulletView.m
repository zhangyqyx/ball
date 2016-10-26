//
//  BulletView.m
//  弹幕
//
//  Created by tarena on 16/8/3.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "BulletView.h"

#define Padding 10
#define PhotoHeight 30

@interface BulletView ()

/** 弹幕label */
@property (nonatomic , strong)UILabel *lbComment;
/** 图片 */
@property (nonatomic , strong)UIImageView *photoImageView;
@end

@implementation BulletView

//初始化屏幕
- (instancetype)initWithComment:(NSString *)comment withImage:(NSString *)image{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        self.bounds = CGRectMake(0, 0, width + 2*Padding + PhotoHeight, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        self.photoImageView.frame = CGRectMake(-Padding, -Padding, Padding + PhotoHeight, Padding + PhotoHeight);
        self.photoImageView.layer.cornerRadius = (PhotoHeight + Padding) /2;
        self.photoImageView.layer.borderColor = [UIColor orangeColor].CGColor;
        self.photoImageView.layer.borderWidth = 1;
        if (image) {
             self.photoImageView.image = [UIImage imageNamed:image];
        }else {
            self.photoImageView.image = [UIImage imageNamed:@"1"];
        }
    }
    return self;
}

//开始动画
- (void)startAnimationWithDuration:(CGFloat)duration {
    //根据弹幕的长度执行动画效果
    //根据 v= s/t ，时间相同情况下，距离越长，速度越快
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (duration == 0.0f) {
        duration = 4.0f;
    }
  
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatusBloak) {
        self.moveStatusBloak(Start);
    }
    //t = s/v;
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = (CGRectGetWidth(self.bounds) + 100)/ speed;
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    //使用GCD的延迟方法没法暂停
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.moveStatusBloak) {
//            self.moveStatusBloak(Enter);
//        }
//    });
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBloak) {
            self.moveStatusBloak(End);
        }
    }];
    
}
//结束动画
- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    
}
- (UILabel *)lbComment {
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
        
    }
    return _lbComment;
}
- (void)enterScreen {
    if (self.moveStatusBloak) {
        self.moveStatusBloak(Enter);
    }
}
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoImageView];
    }
    return _photoImageView;
}

@end
