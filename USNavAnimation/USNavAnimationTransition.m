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
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    toViewController.view.alpha = 0;
    
    if (self.operation == UINavigationControllerOperationPush) {
        toViewController.view.frame = containerView.bounds;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.alpha = 1;
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
    if (self.operation == UINavigationControllerOperationPush) {
        options = UIViewAnimationOptionTransitionFlipFromRight;
        toViewController.view.frame = containerView.bounds;
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