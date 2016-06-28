//
//  RootViewController.m
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

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
    DetailViewController *detailViewController = [DetailViewController viewController];
    detailViewController.scaleBeginRect = sender.frame;
    detailViewController.transitionOption = USNavigationTransitionOptionScale;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)fadeButtonAction:(UIButton *)sender
{
    DetailViewController *detailViewController = [DetailViewController viewController];
    detailViewController.transitionOption = USNavigationTransitionOptionFade;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)noneButtonAction:(UIButton *)sender
{
    DetailViewController *detailViewController = [DetailViewController viewController];
    detailViewController.transitionOption = USNavigationTransitionOptionNone;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
