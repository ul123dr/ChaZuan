//
//  DiamInfoView.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/12.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DiamResultList, DiamSupplyList;
@interface DiamInfoView : UIView

@property (nonatomic, readwrite, assign) NSInteger selectTag;
@property (nonatomic, readwrite, strong) DiamResultList *list;
@property (nonatomic, readwrite, strong) DiamSupplyList *supplyList;
@property (nonatomic, readwrite, copy) NSString *addNum;
@property (nonatomic, readwrite, copy) NSString *rate;
@property (nonatomic, readwrite, assign) NSUInteger index;
@property (nonatomic, readwrite, strong) RACSubject *clickSub;

@end

NS_ASSUME_NONNULL_END
