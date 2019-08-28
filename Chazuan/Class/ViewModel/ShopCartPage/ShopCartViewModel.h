//
//  ShopCartViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/19.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "CartItemViewModel.h"
#import "ShopCartModel.h"
#import "DollarRate.h"
#import "ShopOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartViewModel : BaseTableViewModel

@property (nonatomic, readwrite, strong) NSMutableArray *selectArray;
@property (nonatomic, readwrite, assign) BOOL goodIsNull;
@property (nonatomic, readwrite, strong) RACTuple *balanceTuple;

@property (nonatomic, readonly, strong) RACCommand *selectAllCommand;
@property (nonatomic, readonly, strong) RACCommand *balanceCommand;
@property (nonatomic, readonly, strong) RACCommand *deleteCommand;

@property (nonatomic, readonly, strong) RACCommand *requestRateCommand;

@property (nonatomic, readonly, strong) NSError *error; 

- (void)getAllPrices;

@end

NS_ASSUME_NONNULL_END
