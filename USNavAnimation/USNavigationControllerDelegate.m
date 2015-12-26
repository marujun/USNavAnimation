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

@interface USNavigationControllerDelegate ()

@property (strong, nonatomic) USNavFlipTransition *flipTransition;
@property (strong, nonatomic) USNavFadeTransition *fadeTransition;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactivePopTransition;

@end


@implementation USNavigationControllerDelegate

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        // init your code
        self.navigationController = navigationController;
        
//        [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(panGestureHandler:)];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        [self.navigationController.view addGestureRecognizer:panRecognizer];
        
        self.flipTransition = [USNavFlipTransition new];
        self.fadeTransition = [USNavFadeTransition new];
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
            self.interactivePopTransition = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.3) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.flipTransition.operation = operation;
    return self.flipTransition;
    
//    self.fadeTransition.operation = operation;
//    return self.fadeTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[USNavAnimationTransition class]]) {
        return self.interactivePopTransition;
    }
    return nil;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    
    return YES;
}

@end
