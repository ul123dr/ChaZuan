//
//  OrderCenterViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "OrderGroupViewModel.h"
#import "OrderItemViewModel.h"
#import "OrderModel.h"
#import "SearchViewModel.h"
#import "SiftList.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderCenterViewModel : BaseTableViewModel

@property (nonatomic, readwrite, assign) BOOL goodIsNull;
@property (nonatomic, readonly, strong) NSArray *titleArray;
@property (nonatomic, readonly, copy) NSString *titleViewTitle;
@property (nonatomic, readwrite, assign) NSInteger orderType;
@property (nonatomic, readonly, strong) NSArray *segmentArr;
@property (nonatomic, readwrite, assign) NSInteger segmentIndex;

@property (nonatomic, readonly, strong) RACCommand *searchCommand;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
