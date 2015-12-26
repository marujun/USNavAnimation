//
//  RootViewController.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"

@interface RootViewController ()


@end

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"首页";
    
//    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
//    popRecognizer.edges = UIRectEdgeRight;
//    [self.view addGestureRecognizer:popRecognizer];
}

- (IBAction)pushButtonAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[HomeViewController viewController] animated:YES];
}


@end
