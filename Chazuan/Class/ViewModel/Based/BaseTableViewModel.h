//
//  BaseTableViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewModel.h"
#import "CommonGroupViewModel.h"
#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewModel : BaseViewModel

@property (nonatomic, readwrite, strong) NSArray *dataSource; 
@property (nonatomic, readwrite, assign) UITableViewStyle style;

@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

@property (nonatomic, readwrite, assign) NSUInteger page; ///< 分页，默认 1
@property (nonatomic, readwrite, assign) NSUInteger perPage; ///< 每页请求数量，默认 10

@property (nonatomic, readwrite, assign) BOOL disableNetwork;

@property (nonatomic, readwrite, strong) RACCommand *didSelectCommand;
@property (nonatomic, readonly, strong) RACCommand *requestRemoteDataCommand;

- (id)fetchLocalData;

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (NSUInteger)offsetForPage:(NSUInteger)page;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end

NS_ASSUME_NONNULL_END
