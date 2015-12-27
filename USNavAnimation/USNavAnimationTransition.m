//
//  USNavAnimationTransition.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USNavAnimationTransition.h"

@implementation USNavAnimationTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

@end

@implementation USNavFadeTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    if (!_reversed) {
        toViewController.view.frame = containerView.bounds;
        toViewController.view.alpha = 0;
    }
    else {
        [containerView bringSubviewToFront:fromViewController.view];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (_reversed) {
            fromViewController.view.alpha = 0;
        } else {
            toViewController.view.alpha = 1;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

@implementation USNavFlipTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft;
    if (!_reversed) {
        options = UIViewAnimationOptionTransitionFlipFromRight;
        toViewController.view.frame = containerView.bounds;
    }
    else {
        [containerView bringSubviewToFront:fromViewController.view];
    }
    
    [CATransaction flush];
    [UIView transitionWithView:containerView
                      duration:[self transitionDuration:transitionContext]
                       options:options
                    animations: ^{
                        fromViewController.view.hidden = YES;
                    }
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                        fromViewController.view.hidden = NO;
                    }];
}

@end

@implementation USNavScaleTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    UIView *snapshotView = [_dataSource snapshotViewWithScaleTransition:self];
    NSArray *fadeViews = [_dataSource fadeViewsWithScaleTransition:self];
    CGRect beginRect = [_dataSource beginRectWithScaleTransition:self];
    CGRect endRect = [_dataSource endRectWithScaleTransition:self];
    
    NSAssert(snapshotView, @"过渡动画中的镜像视图不能为nil");
    
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft;
    if (!_reversed) {
        options = UIViewAnimationOptionTransitionFlipFromRight;
        toViewController.view.frame = containerView.bounds;
        for (UIView *itemView in fadeViews) itemView.alpha = 0;
    }
    else {
        [containerView bringSubviewToFront:fromViewController.view];
    }
    
    snapshotView.translatesAutoresizingMaskIntoConstraints = YES;
    [snapshotView removeFromSuperview];
    [containerView addSubview:snapshotView];
    
    snapshotView.frame = _reversed?endRect:beginRect;
    
    if ([_dataSource respondsToSelector:@selector(snapshotViewDidPresented:)]) {
        [_dataSource snapshotViewDidPresented:self];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        for (UIView *itemView in fadeViews) itemView.alpha = _reversed?0:1;
        snapshotView.frame = _reversed?beginRect:endRect;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        [snapshotView removeFromSuperview];
        if ([_dataSource respondsToSelector:@selector(snapshotViewDidDismiss:)]) {
            [_dataSource snapshotViewDidDismiss:self];
        }
    }];
}

@end