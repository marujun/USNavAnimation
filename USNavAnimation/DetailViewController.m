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
        [self snapshotViewWithScaleTransition:nil];
        [self.view addSubview:_transitionAnimationView];
        _transitionAnimationView.frame = [self endRectWithScaleTransition:nil];
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
    _lastDisplayView.frame = [self endRectWithScaleTransition:nil];
    [self.view addSubview:_lastDisplayView];
}

- (IBAction)bottomButtonAction:(UIButton *)sender
{
    TimelineViewController *timelineViewController = [TimelineViewController viewController];
    timelineViewController.transitionOption = USNavigationTransitionOptionFlip;
    [self.navigationController pushViewController:timelineViewController animated:YES];
}

#pragma mark - USScaleTransitionDataSource
- (CGRect)beginRectWithScaleTransition:(USNavScaleTransition *)transition {
    return _scaleBeginRect;
}

- (CGRect)endRectWithScaleTransition:(USNavScaleTransition *)transition {
    return CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 400);
}

- (NSArray<UIView *> *)fadeViewsWithScaleTransition:(USNavScaleTransition *)transition {
    return @[_bgLabel, _bottomButton];
}

- (UIView *)snapshotViewWithScaleTransition:(USNavScaleTransition *)transition {
    if (!_transitionAnimationView) {
        _transitionAnimationView = [[UIImageView alloc] init];
        _transitionAnimationView.backgroundColor = [UIColor redColor];
    }
    return _transitionAnimationView;
}

- (void)snapshotViewDidPresented:(USNavScaleTransition *)transition {
    _lastDisplayView.hidden = YES;
}

- (void)snapshotViewDidDismiss:(USNavScaleTransition *)transition {
    _lastDisplayView.hidden = NO;
}

@end
