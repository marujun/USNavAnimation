//
//  USNavAnimationTransition.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USNavAnimationTransition.h"

@implementation USNavAnimationTransition

+ (instancetype)transitionWithOperation:(UINavigationControllerOperation)operation
{
    USNavAnimationTransition *transition = [[self alloc] init];
    transition.operation = operation;
    return transition;
}

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