//
//  USTransitionAnimator.h
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, USNavigationTransitionOption) {
    USNavigationTransitionOptionNone = 0,   //系统默认动画
    USNavigationTransitionOptionFade,       //渐隐渐现动画
    USNavigationTransitionOptionFlip,       //3D翻转动画
    USNavigationTransitionOptionScale,      //类似相册的缩放动画
    USNavigationTransitionOptionNormal      //模拟系统的动画
};

@interface USTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
{
    BOOL _reversed;
}

@property (nonatomic, assign) BOOL reversed;

@end

@interface USFadeTransitionAnimator : USTransitionAnimator

@end

@interface USFlipTransitionAnimator : USTransitionAnimator

@end

@class USScaleTransitionAnimator;
@protocol USScaleTransitionAnimatorDataSource <NSObject>
@required
- (CGRect)beginRectWithScaleAnimator:(USScaleTransitionAnimator *)animator;
- (CGRect)endRectWithScaleAnimator:(USScaleTransitionAnimator *)animator;
- (NSArray<UIView *> *)fadeViewsWithScaleAnimator:(USScaleTransitionAnimator *)animator;
- (UIView *)snapshotViewWithScaleAnimator:(USScaleTransitionAnimator *)animator;

@optional
- (void)snapshotViewDidPresented:(USScaleTransitionAnimator *)animator;
- (void)snapshotViewDidDismiss:(USScaleTransitionAnimator *)animator;

@end

@interface USScaleTransitionAnimator : USTransitionAnimator

@property (nonatomic, assign) BOOL cancel;
@property (weak, nonatomic) id<USScaleTransitionAnimatorDataSource> dataSource;

@end

@interface USNormalTransitionAnimator : USTransitionAnimator

@end