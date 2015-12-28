//
//  USNavDelegateHandler.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

//http://dativestudios.com/blog/2013/09/29/interactive-transitions/

#import "USNavDelegateHandler.h"
#import "USTransitionAnimator.h"
#import "USViewController.h"

@interface USNavDelegateHandler ()

@property (strong, nonatomic) USFlipTransitionAnimator *flipTransition;
@property (strong, nonatomic) USFadeTransitionAnimator *fadeTransition;
@property (strong, nonatomic) USScaleTransitionAnimator *scaleTransition;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end


@implementation USNavDelegateHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        // init your code
        self.hidden = YES;
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        
        _flipTransition = [USFlipTransitionAnimator new];
        _fadeTransition = [USFadeTransitionAnimator new];
        _scaleTransition = [USScaleTransitionAnimator new];
    }
    return self;
}

- (void)setNavigationController:(UINavigationController *)navigationController
{
    _navigationController = navigationController;
    
    [_navigationController.view insertSubview:self atIndex:0];
    [_navigationController.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)panGestureHandler:(UIPanGestureRecognizer*)recognizer
{
    // Calculate how far the user has dragged across the view
    UIView *view = _navigationController.view;
    CGPoint translation = [recognizer translationInView:view];
    CGFloat progress = translation.x / CGRectGetWidth(view.bounds);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && _navigationController.viewControllers.count > 1) { // left half
            // Create a interactive transition and pop the view controller
            _interactivePopTransition = [UIPercentDrivenInteractiveTransition new];
            [_navigationController popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [_interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress < 0.4  || recognizer.state == UIGestureRecognizerStateCancelled) {
            [_interactivePopTransition cancelInteractiveTransition];
        } else {
            [_interactivePopTransition finishInteractiveTransition];
        }
        _interactivePopTransition = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    USTransitionAnimator *transition = nil;
    
    BOOL reversed = operation==UINavigationControllerOperationPop;
    USViewController *targetVC = (USViewController *)(reversed?fromVC:toVC);
    
    if ([targetVC respondsToSelector:@selector(transitionOption)]) {
        switch (targetVC.transitionOption) {
            case USNavigationTransitionOptionFade:
                transition = _fadeTransition;
                break;
            case USNavigationTransitionOptionFlip:
                transition = _flipTransition;
                break;
            case USNavigationTransitionOptionScale:
                if ([targetVC conformsToProtocol:@protocol(USScaleTransitionAnimatorDataSource)]) {
                    _scaleTransition.dataSource = (id)targetVC;
                    transition = _scaleTransition;
                } else {
                    targetVC.transitionOption = USNavigationTransitionOptionNone;
                }
                break;
            default:
                break;
        }
    }
    transition.reversed = reversed;
    
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[USTransitionAnimator class]]) {
        _panGestureRecognizer.enabled = YES;
        return self.interactivePopTransition;
    }
    
    _panGestureRecognizer.enabled = NO;
    return nil;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(USViewController *)viewController
                    animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(transitionOption)] &&
        viewController.transitionOption != USNavigationTransitionOptionNone) {
        _panGestureRecognizer.enabled = YES;
    }
    else {
        _panGestureRecognizer.enabled = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_navigationController.viewControllers.count == 1) {
        return NO;
    }
    
    return YES;
}

@end
