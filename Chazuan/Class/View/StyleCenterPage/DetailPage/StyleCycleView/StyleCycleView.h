//
//  StyleCycleView.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StyleCycleView : UIView

+ (instancetype)cycleView;

- (void)setModels:(NSArray *)models;

- (void)setTimerInvalidate;

- (void)startTimer;

@property (nonatomic, readwrite, strong) VoidBlock_int actionBlock;

@end

NS_ASSUME_NONNULL_END
