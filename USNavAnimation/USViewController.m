//
//  USViewController.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USViewController.h"

@interface USViewController ()

@end

@implementation USViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)fInit
{
    NSLog(@"init 创建类 %@", NSStringFromClass([self class]));
}

- (void)updateDisplay
{
    
}

+ (instancetype)viewController
{
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@ viewWillAppear",  NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@ viewDidAppear",  NSStringFromClass([self class]));
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSLog(@"%@ viewDidLayoutSubviews",  NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ viewWillDisappear",  NSStringFromClass([self class]));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"%@ viewDidDisappear",  NSStringFromClass([self class]));
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc 释放类 %@",  NSStringFromClass([self class]));
}

@end
