//
//  StyleCenterViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "StyleItemViewModel.h"
#import "SiftSelectModel.h"
#import "StyleDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleCenterViewModel : BaseTableViewModel

@property (nonatomic, readwrite, assign) StyleType type;
@property (nonatomic, readwrite, assign) BOOL goodIsNull;
@property (nonatomic, readwrite, copy) NSString *orderBy;
@property (nonatomic, readwrite, copy) NSString *designNo;
@property (nonatomic, readwrite, copy) NSString *priceMin;
@property (nonatomic, readwrite, copy) NSString *priceMax;
@property (nonatomic, readwrite, copy) NSString *barCode;
@property (nonatomic, readwrite, copy) NSString *priceBtnTitle;

@property (nonatomic, readonly, strong) NSArray *sideTitle;
@property (nonatomic, readonly, strong) NSMutableArray *sideArray;
@property (nonatomic, readwrite, strong) NSMutableArray *sideSelectArray;
@property (nonatomic, readwrite, strong) SiftSelectModel *sideModel;
@property (nonatomic, readwrite, strong) SiftSelectModel *select;

@property (nonatomic, readonly, strong) RACCommand *designCommand;
@property (nonatomic, readonly, strong) RACCommand *shopcartCommand;

@property (nonatomic, readonly, strong) RACCommand *sideResetCommand;
@property (nonatomic, readonly, strong) RACCommand *sideConfirmCommand;
@property (nonatomic, readonly, strong) RACSubject *sideSelectSub;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
