//
//  DetailViewController.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "DetailViewController.h"
#import "TimelineViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) UIImageView *transitionAnimationView;
@property (strong, nonatomic) UIImageView *lastDisplayView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详情";
   
    if (self.transitionOption != USNavigationTransitionOptionScale) {
        [self snapshotViewWithScaleAnimator:nil];
        [self.view insertSubview:_transitionAnimationView belowSubview:_bottomButton];
        _transitionAnimationView.frame = [self endRectWithScaleAnimator:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupDisplayView];
}

- (void)setupDisplayView
{
    if (_lastDisplayView) {
        return;
    }
    
    _lastDisplayView = [[UIImageView alloc] init];
    _lastDisplayView.backgroundColor = [UIColor redColor];
    _lastDisplayView.frame = [self endRectWithScaleAnimator:nil];
    [self.view insertSubview:_lastDisplayView belowSubview:_bottomButton];
}

- (IBAction)bottomButtonAction:(UIButton *)sender
{
    TimelineViewController *timelineViewController = [TimelineViewController viewController];
    timelineViewController.transitionOption = USNavigationTransitionOptionFlip;
    [self.navigationController pushViewController:timelineViewController animated:YES];
}

#pragma mark - USScaleTransitionAnimatorDataSource
- (CGRect)beginRectWithScaleAnimator:(USScaleTransitionAnimator *)animator {
    return _scaleBeginRect;
}

- (CGRect)endRectWithScaleAnimator:(USScaleTransitionAnimator *)animator {
    return CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 400);
}

- (NSArray<UIView *> *)fadeViewsWithScaleAnimator:(USScaleTransitionAnimator *)animator {
    return @[_bgLabel, _bottomButton];
}

- (UIView *)snapshotViewWithScaleAnimator:(USScaleTransitionAnimator *)animator {
    if (!_transitionAnimationView) {
        _transitionAnimationView = [[UIImageView alloc] init];
        _transitionAnimationView.backgroundColor = [UIColor redColor];
        [self.view insertSubview:_transitionAnimationView belowSubview:_bottomButton];
    }
    return _transitionAnimationView;
}

- (void)snapshotViewDidPresented:(USScaleTransitionAnimator *)animator {
    _lastDisplayView.hidden = YES;
}

- (void)snapshotViewDidDismiss:(USScaleTransitionAnimator *)animator {
    _lastDisplayView.hidden = NO;
}

@end
