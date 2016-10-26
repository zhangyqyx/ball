//
//  BulletView.h
//  弹幕
//
//  Created by tarena on 16/8/3.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , MoveStatus){
    
    Start,
    Enter,
    End
    
};
@interface BulletView : UIView
/** 弹道 */
@property (nonatomic , assign)int trajectory;
/** 弹幕状态的回调 */
@property (nonatomic , copy)void (^moveStatusBloak)(MoveStatus status);

//初始化屏幕
- (instancetype)initWithComment:(NSString *)comment withImage:(NSString *)image;

//开始动画
- (void)startAnimationWithDuration:(CGFloat)duration;
//结束动画
- (void)stopAnimation;


@end
