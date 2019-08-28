//
//  SearchViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchModel.h"

@interface SearchViewModel ()

@property (nonatomic, readwrite, copy) NSString *searchStr;
@property (nonatomic, readwrite, strong) NSArray *logList;
@property (nonatomic, readwrite, assign) NSInteger type;

@property (nonatomic, readwrite, strong) RACCommand *clearCommand;
@property (nonatomic, readwrite, strong) RACCommand *searchLogCommand;

@end

//#define POST_FIND_SEARCH @"order/pc/ajaxOrderFindPageList_manager_specialty.xhtml"
//#define POST_INSET_SEARCHLOG @"searchLog/pc/ajaxSearchLogInsert.xhtml"
//#define POST_DELETE_SEARCHLOG @"searchLog/pc/ajaxSearchLogDelete.xhtml"

@implementation SearchViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.type = [self.params[ViewModelTypeKey] integerValue];
    
    @weakify(self);
    /// 数据源
    RAC(self, logList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    RAC(self, dataSource) = [[RACObserve(self, logList) ignore:nil] map:^(NSArray * logList) {
        @strongify(self);
        return [self dataSourceWithLogList:logList];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"type"] = @(self.type);
        NSString *content = @"";
        if ([input isKindOfClass:NSString.class]) {
            content = input;
        } else {
            SearchLog *log = [self.logList objectAtIndex:((NSIndexPath*)input).row];
            content = log.content;
        }
        subscript[@"content"] = content;
        
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_INSET_SEARCHLOG parameters:subscript.dictionary];
        @weakify(self);
        [[self.services.client enqueueParameter:paramters resultClass:SearchLog.class] subscribeNext:^(SearchLog *search) {
            @strongify(self);
            OrderCenterViewModel *viewModel = [[OrderCenterViewModel alloc] initWithServices:self.services params:@{ViewModelSearchOrderNoKey:content}];
            [self.services pushViewModel:viewModel animated:YES];
            [self.requestRemoteDataCommand execute:@0];
        } error:^(NSError * error) {
            [self.requestRemoteDataCommand execute:@0];
        }];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    @weakify(self);
    NSArray * (^mapLogList)(HTTPResponse *) = ^(HTTPResponse *response) {
//        @strongify(self);
        SearchModel *model = response.parsedResult;
        if (model.appCheckCode) {
            [self.services.client loginAtOtherPlace];
            return @[];
        }
        return model.list;
//        NSArray *logList = model.list;
////        if (page == 1) { // 下拉刷新
////        } else { // 上拉刷新
//        self.logList = @[];
//            logList = @[(self.logList ?: @[]).rac_sequence, logList.rac_sequence].rac_sequence.flatten.array;
////        }
//        return logList;
    };
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"currentPage"] = @"0";
    subscript[@"pageSize"] = @(self.perPage*5).stringValue;
    subscript[@"type"] = @"1";
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_FIND_SEARCHLOG parameters:subscript.dictionary];
    
    return [[self.services.client enqueueParameter:paramters resultClass:SearchModel.class] map:mapLogList];
}

- (NSArray *)dataSourceWithLogList:(NSArray *)searchList {
    @weakify(self);
    SearchGroupViewModel *group = [SearchGroupViewModel groupViewModel];
    group.footerBackColor = UIColor.whiteColor;
    group.headerBackColor = UIColor.whiteColor;
    group.clearCommand = self.clearCommand;
    group.header = @"历史记录";
    group.headerHeight = ZGCConvertToPx(44);
    group.footerHeight = ZGCConvertToPx(144);
    NSMutableArray *viewModels = [NSMutableArray array];
    for (SearchLog *log in searchList) {
        SearchItemViewModel *viewModel = [SearchItemViewModel itemViewModelWithTitle:@""];
        viewModel.historyStr = log.content;
        viewModel.operation = ^{
            @strongify(self);
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
            subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
            subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            subscript[@"id"] = log.logId.stringValue;
            
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_DELETE_SEARCHLOG parameters:subscript.dictionary];
            @weakify(self);
            [[self.services.client enqueueParameter:paramters resultClass:SearchLog.class] subscribeNext:^(SearchLog *search) {
                @strongify(self);
                [self.requestRemoteDataCommand execute:@0];
            }];
        };
        [viewModels addObject:viewModel];
    }
    group.itemViewModels = [viewModels copy];
    return @[group];
}

@end
