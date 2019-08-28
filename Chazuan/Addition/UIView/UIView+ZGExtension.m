//
//  UIView+ZGExtension.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "UIView+ZGExtension.h"

@implementation UIView (ZGExtension)

- (void)zgc_solveUIWidgetFuzzy {
    CGRect frame = self.frame;
    int x = floor(frame.origin.x);
    int y = floor(frame.origin.y);
    int w = ceilf(frame.size.width);
    int h = ceilf(frame.size.height);
    self.frame = CGRectMake(x, y, w, h);
}

+ (CAKeyframeAnimation *)zgc_zoomoutAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.01, 1.01, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         ];
    animation.keyTimes = @[ @0, @0.25, @0.5, @0.75, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.1;
    
    return animation;
}

+ (CAKeyframeAnimation *)zgc_zoominAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.01, 1.01, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.25, @0.5, @0.75, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.4;
    
    return animation;
}


@end
