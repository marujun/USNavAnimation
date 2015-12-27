//
//  USNavigationControllerDelegate.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

//http://dativestudios.com/blog/2013/09/29/interactive-transitions/

#import "USNavigationControllerDelegate.h"
#import "USNavAnimationTransition.h"
#import "USViewController.h"

@interface USNavigationControllerDelegate ()

@property (strong, nonatomic) USNavFlipTransition *flipTransition;
@property (strong, nonatomic) USNavFadeTransition *fadeTransition;
@property (strong, nonatomic) USNavScaleTransition *scaleTransition;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end


@implementation USNavigationControllerDelegate

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        // init your code
        _navigationController = navigationController;
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        [self.navigationController.view addGestureRecognizer:_panGestureRecognizer];
        
        _flipTransition = [USNavFlipTransition new];
        _fadeTransition = [USNavFadeTransition new];
        _scaleTransition = [USNavScaleTransition new];
    }
    return self;
}

- (void)panGestureHandler:(UIPanGestureRecognizer*)recognizer
{
    // Calculate how far the user has dragged across the view
    UIView *view = self.navigationController.view;
    CGPoint translation = [recognizer translationInView:view];
    CGFloat progress = translation.x / CGRectGetWidth(view.bounds);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
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
    USNavAnimationTransition *transition = nil;
    
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
                if ([targetVC conformsToProtocol:@protocol(USScaleTransitionDataSource)]) {
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
    if ([animationController isKindOfClass:[USNavAnimationTransition class]]) {
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
