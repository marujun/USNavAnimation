//
//  DetailViewController.h
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USViewController.h"

@interface DetailViewController : USViewController <USScaleTransitionDataSource>

@property (nonatomic, assign) CGRect scaleBeginRect;

@end
