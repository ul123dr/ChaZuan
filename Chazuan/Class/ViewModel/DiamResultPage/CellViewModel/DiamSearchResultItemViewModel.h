//
//  DiamSearchResultItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiamResultModel.h"
#import "DiamSupplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamSearchResultItemViewModel : NSObject

@property (nonatomic, readwrite, strong) DiamResultList *list;
@property (nonatomic, readwrite, strong) DiamSupplyList *supplyList;
@property (nonatomic, readwrite, assign) NSUInteger index;
@property (nonatomic, readwrite, assign) BOOL selected;
@property (nonatomic, readwrite, assign) BOOL opened;

@property (nonatomic, readwrite, strong) RACSubject *discSub;
@property (nonatomic, readwrite, strong) RACSubject *moneySub;
@property (nonatomic, readwrite, strong) RACSubject *clickSub;

@property (nonatomic, readwrite, strong) RACSubject *detailSub;
@property (nonatomic, readwrite, copy) VoidBlock_Bool selectOperation;
@property (nonatomic, readwrite, copy) VoidBlock_Bool clickOperation;

@property (nonatomic, readwrite, assign) NSInteger discType;
@property (nonatomic, readwrite, assign) NSInteger moneyType;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, assign) CGFloat rowHeight;

/// init title
+ (instancetype)itemViewModel;

@end

NS_ASSUME_NONNULL_END
