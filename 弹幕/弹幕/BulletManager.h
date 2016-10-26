//
//  BulletManager.h
//  弹幕
//
//  Created by tarena on 16/8/3.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BulletView;
@interface BulletManager : NSObject
/** 控制器回调view */
@property (nonatomic , copy)void (^generateViewBlock)(BulletView *view);
/** 设置加入的内容 */
@property (nonatomic , strong)NSArray *contentArray;
/** 是否重复 */
@property (nonatomic , assign)BOOL isRepeat;
//弹幕开始执行
- (void)startWithDuration:(float)duration;
//弹幕停止执行
- (void)stop;


@end
