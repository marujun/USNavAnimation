//
//  USNavAnimationTransition.h
//  USNavAnimation
//
//  Created by marujun on 15/12/26.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface USNavAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface USNavFadeShowTransition : USNavAnimationTransition

@end


@interface USNavFadeHideTransition : USNavAnimationTransition

@end