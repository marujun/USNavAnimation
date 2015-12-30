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

@property (nonatomic, assign) USNavigationTransitionOption transitionOption;

- (void)updateDisplay;

+ (instancetype)viewController;

- (UIViewController *)viewControllerWillPushForLeftDirectionPan;

@end
