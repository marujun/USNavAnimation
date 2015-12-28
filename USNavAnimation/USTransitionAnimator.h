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
    USNavigationTransitionOptionNone = 0,
    USNavigationTransitionOptionFade,
    USNavigationTransitionOptionFlip,
    USNavigationTransitionOptionScale
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

@property (weak, nonatomic) id<USScaleTransitionAnimatorDataSource> dataSource;

@end