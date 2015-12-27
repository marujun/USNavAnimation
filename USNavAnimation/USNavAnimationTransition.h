//
//  USNavAnimationTransition.h
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

@interface USNavAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning>
{
    BOOL _reversed;
}

@property (nonatomic, assign) BOOL reversed;

@end

@interface USNavFadeTransition : USNavAnimationTransition

@end

@interface USNavFlipTransition : USNavAnimationTransition

@end

@class USNavScaleTransition;
@protocol USScaleTransitionDataSource <NSObject>
@required
- (CGRect)beginRectWithScaleTransition:(USNavScaleTransition *)transition;
- (CGRect)endRectWithScaleTransition:(USNavScaleTransition *)transition;
- (NSArray<UIView *> *)fadeViewsWithScaleTransition:(USNavScaleTransition *)transition;
- (UIView *)snapshotViewWithScaleTransition:(USNavScaleTransition *)transition;

@optional
- (void)snapshotViewDidPresented:(USNavScaleTransition *)transition;
- (void)snapshotViewDidDismiss:(USNavScaleTransition *)transition;

@end

@interface USNavScaleTransition : USNavAnimationTransition

@property (weak, nonatomic) id<USScaleTransitionDataSource> dataSource;

@end