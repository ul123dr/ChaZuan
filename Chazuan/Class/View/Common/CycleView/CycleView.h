//
//  CycleView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CycleView : UIView

+ (instancetype)cycleView;

- (void)setModels:(NSArray *)models;

- (void)setTimerInvalidate;

- (void)startTimer;

@property (nonatomic, readwrite, strong) VoidBlock_int actionBlock;

@end

NS_ASSUME_NONNULL_END
