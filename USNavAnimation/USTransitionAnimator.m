//
//  USTransitionAnimator.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USTransitionAnimator.h"

@implementation USTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

@end

@implementation USFadeTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    if (!_reversed) toViewController.view.frame = containerView.bounds;
    else [containerView bringSubviewToFront:fromViewController.view];
    
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.alpha = 1;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

@implementation USFlipTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

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
        toViewController.view.alpha = 1;
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
                        fromViewController.view.hidden = NO;
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                    }];
}

@end

@implementation USScaleTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    _cancel = NO;
    
    UIView *snapshotView = [_dataSource snapshotViewWithScaleAnimator:self];
    NSArray *fadeViews = [_dataSource fadeViewsWithScaleAnimator:self];
    CGRect beginRect = [_dataSource beginRectWithScaleAnimator:self];
    CGRect endRect = [_dataSource endRectWithScaleAnimator:self];
    
    NSAssert(snapshotView, @"过渡动画中的镜像视图不能为nil");
    
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft;
    if (!_reversed) {
        options = UIViewAnimationOptionTransitionFlipFromRight;
        toViewController.view.frame = containerView.bounds;
        for (UIView *itemView in fadeViews) itemView.alpha = 0;
    }
    else {
        toViewController.view.alpha = 1;
        [containerView bringSubviewToFront:fromViewController.view];
    }
    
    snapshotView.hidden = NO;
    snapshotView.translatesAutoresizingMaskIntoConstraints = YES;
    snapshotView.frame = _reversed?endRect:beginRect;
    
    if ([_dataSource respondsToSelector:@selector(snapshotViewDidPresented:)]) {
        [_dataSource snapshotViewDidPresented:self];
    }
    
    void (^completeBlock)(BOOL finished) = ^(BOOL finished){
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        snapshotView.hidden = YES;
        if ([_dataSource respondsToSelector:@selector(snapshotViewDidDismiss:)]) {
            [_dataSource snapshotViewDidDismiss:self];
        }
    };
    
    if (_cancel) {
        if (_reversed) {
            snapshotView.hidden = YES;
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.alpha = 0;
            } completion:completeBlock];
        }
        else {
            for (UIView *itemView in fadeViews) itemView.alpha = _reversed?0:1;
            completeBlock(YES);
        }
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            for (UIView *itemView in fadeViews) itemView.alpha = _reversed?0:1;
            snapshotView.frame = _reversed?beginRect:endRect;
        } completion:completeBlock];
    }
}

@end

@implementation USNormalTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    UIView *maskView = [[UIView alloc] initWithFrame:containerView.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor grayColor];
    shadowView.layer.shadowOffset =CGSizeMake(0.f, 0.f);
    shadowView.layer.shadowRadius = 6.f;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOpacity = 0.8;
    
    CGRect toRect = containerView.bounds;
    CGFloat xOffset = toRect.size.width*3.f/10.f;
    CGRect fromRect = fromViewController.view.frame;
    CGRect shadowRect = CGRectMake(0, 0, 10, toRect.size.height);
    
    if (!_reversed) {
        toRect.origin.x = toRect.size.width;
        toViewController.view.frame = toRect;
        
        shadowRect.origin.x = toRect.origin.x;
        shadowView.frame = shadowRect;
        [containerView insertSubview:maskView aboveSubview:fromViewController.view];
        
        toRect.origin.x = 0;
        fromRect.origin.x = -xOffset;
        shadowRect.origin.x = toRect.origin.x;
    }
    else {
        toRect.origin.x = -xOffset;
        toViewController.view.alpha = 1;
        toViewController.view.frame = toRect;
        
        shadowRect.origin.x = fromRect.origin.x;
        shadowView.frame = shadowRect;
        [containerView bringSubviewToFront:fromViewController.view];
        [containerView insertSubview:maskView belowSubview:fromViewController.view];
        
        toRect.origin.x = 0;
        fromRect.origin.x = fromRect.size.width;
        shadowRect.origin.x = fromRect.origin.x;
    }
    [containerView insertSubview:shadowView aboveSubview:maskView];
    
    maskView.alpha = _reversed?0.1:0;
    shadowView.alpha = _reversed?0.5:0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.frame = toRect;
        fromViewController.view.frame = fromRect;
        
        maskView.alpha = _reversed?0:0.1;
        shadowView.alpha = _reversed?0:0.5;
        shadowView.frame = shadowRect;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        [shadowView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
