//
//  LQAnimationBackView.m
//  LQTouchableAnimation
//
//  Created by renren on 16/3/4.
//  Copyright © 2016年 luqiang. All rights reserved.
//

#import "LQAnimationBackView.h"

@implementation LQAnimationBackView

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if ([self.animatedView.layer.presentationLayer hitTest:point]) {
        return YES;
    } else {
        return NO;
    }
}

@end
