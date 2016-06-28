//
//  USViewController.h
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AutoLayout.h"
#import "USTransitionAnimator.h"

@interface USViewController : UIViewController
{
    USNavigationTransitionOption _transitionOption;
}

@property (nonatomic, assign) USNavigationTransitionOption transitionOption;

/** 是否允许屏幕边缘侧滑手势 */
@property (nonatomic, assign) BOOL enableScreenEdgePanGesture;

- (void)updateDisplay;

+ (instancetype)viewController;

- (UIViewController *)viewControllerWillPushForLeftDirectionPan;

@end
