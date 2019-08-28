//
//  DiamSearchResultViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewModel.h"
#import "DiamSearchResultItemViewModel.h"
#import "QuoteViewModel.h"
#import "CertSearchViewModel.h"
#import "PdfViewModel.h"
#import "ShopCartViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamSearchResultViewModel : BaseViewModel

@property (nonatomic, readwrite, assign) BOOL goodIsNull;
@property (nonatomic, readonly, copy) NSString *searchText;
@property (nonatomic, readonly, assign) CGFloat headerHeight;
@property (nonatomic, readonly, strong) NSArray *dataSource;

@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

@property (nonatomic, readwrite, assign) NSUInteger page; ///< 分页，默认 1
@property (nonatomic, readwrite, assign) NSUInteger perPage; ///< 每页请求数量，默认 10

@property (nonatomic, readonly, assign) NSInteger type;

@property (nonatomic, readonly, strong) RACSubject *discSub;
@property (nonatomic, readonly, strong) RACSubject *moneySub;
@property (nonatomic, readonly, strong) RACSubject *reloadSub;

@property (nonatomic, readwrite, strong) RACSubject *showPicSub;
@property (nonatomic, readonly, strong) RACCommand *requestRemoteDataCommand;
@property (nonatomic, readonly, strong) RACCommand *supplierCommand;

@property (nonatomic, readonly, strong) RACCommand *shopcartCommand;
@property (nonatomic, readonly, strong) RACCommand *quoteCommand;
@property (nonatomic, readonly, strong) RACCommand *cartCommand;
@property (nonatomic, readonly, strong) RACCommand *orderCommand;

@end

NS_ASSUME_NONNULL_END
