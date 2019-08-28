//
//  MainViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "BannerItemViewModel.h"
#import "MainItemViewModel.h"
#import "LoginViewModel.h"
#import "PersonalCenterViewModel.h"
#import "OrderCenterViewModel.h"
#import "SearchViewModel.h"
#import "StyleCenterViewModel.h"
#import "CertSearchViewModel.h"
#import "DiamSearchViewModel.h"
#import "FancySearchViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewModel : BaseTableViewModel

@property (nonatomic, readonly, strong) NSArray *cycleData;
@property (nonatomic, readonly, strong) NSArray *funcData;

@property (nonatomic, readonly, strong) RACCommand *shopCartCommand;
@property (nonatomic, readonly, strong) RACCommand *searchCommand;

@end

NS_ASSUME_NONNULL_END
