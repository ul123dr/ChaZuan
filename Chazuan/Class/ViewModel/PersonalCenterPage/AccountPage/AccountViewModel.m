//
//  AccountViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountViewModel.h"

@interface AccountViewModel ()

@property (nonatomic, readwrite, strong) NSArray *memberList;
@property (nonatomic, readwrite, assign) NSInteger count;

@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSub;

@property (nonatomic, readwrite, strong) RACCommand *addCommand;

@end

@implementation AccountViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldPullUpToLoadMore = YES;
    self.type = 1;
    self.searchType = 1;
    self.searchTypeSub = [RACSubject subject];
    
    @weakify(self);
    RAC(self, memberList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    /// 数据源
    RAC(self, dataSource) = [[RACObserve(self, memberList) ignore:nil] map:^(NSArray * memberList) {
        @strongify(self);
        return [self _dataSourceWithMemberList:memberList];
    }];
    
    [RACObserve(self, type) subscribeNext:^(id x) {
        self.page = 1;
        [self.requestRemoteDataCommand execute:@1];
    }];
    
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.page = 1;
        [self.requestRemoteDataCommand execute:@1];
        return [RACSignal empty];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (NSIndexPath *indexPath) {
        @strongify(self);
        Member *member = self.memberList[indexPath.row];
        AccountEditViewModel *viewModel = [[AccountEditViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:self.type==1?@"会员详情":@"员工详情",ViewModelTypeKey:@(self.type),ViewModelModelKey:member}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        AccountAddViewModel *viewModel = [[AccountAddViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:self.type==1?@"添加会员":@"添加员工",ViewModelTypeKey:@(self.type)}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    [[ZGCNotificationCenter rac_addObserverForName:AddAccountSuccessNotification object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        self.page = 1;
        [self.requestRemoteDataCommand execute:@1];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    self.error = nil;
    @weakify(self);
    
    NSArray * (^mapMemberList)(HTTPResponse *) = ^(HTTPResponse *response) {
        @strongify(self);
        AccountModel *model = response.parsedResult;
        self.count = model.page.totalRecord;
        NSArray *memberList = model.list;
        if (page == 1) { // 下拉刷新
        } else { // 上拉刷新
            memberList = @[(self.memberList ?: @[]).rac_sequence, memberList.rac_sequence].rac_sequence.flatten.array;
        }
        if (memberList.count == model.page.totalRecord)
            self.shouldEndRefreshingWithNoMoreData = YES;
        return memberList;
    };
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"status"] = @"";
    subscript[@"currentPage"] = @(page);
    subscript[@"pageSize"] = @(self.perPage);
    if (self.services.client.currentUser.userType == 3) {
        subscript[@"salesmen_id"] = self.services.client.currentUser.userId.stringValue;
    } else if (self.services.client.currentUser.userType == 2) {
        subscript[@"buyer_id"] = self.services.client.currentUser.userId.stringValue;
    }
    subscript[@"user_type_big"] = @(self.type);
    if (kStringIsNotEmpty(self.searchText)) {
        if (self.searchType == 1) {
            subscript[@"username"] = [self.searchText stringByURLEncode];
        } else if (self.searchType == 2) {
            subscript[@"realname"] = AFPercentEscapedStringFromString(self.searchText);
        } else {
            subscript[@"mobile"] = self.searchText;
        }
    }
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_USER_LIST parameters:subscript.dictionary];
    return [[self.services.client enqueueParameter:paramters resultClass:AccountModel.class] map:mapMemberList];
}

- (NSArray *)_dataSourceWithMemberList:(NSArray *)memberList {
    if (memberList.count == 0) return nil;
    return [memberList.rac_sequence.signal map:^id(Member *member) {
        MemberItemViewModel *viewModel = [MemberItemViewModel itemViewModelWithTitle:@""];
        viewModel.rowHeight = ZGCConvertToPx(80);
        Member *submem = member.list[0];
        if (kStringIsNotEmpty(submem.avatar))
            viewModel.avastar = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], submem.avatar];
        viewModel.name = member.username;
        viewModel.role = [self _fetchUserRole:member];
        viewModel.info = [NSString stringWithFormat:@"%@  %@", formatString(submem.realname), formatString(submem.mobile)];
        return viewModel;
    }].toArray;
}

- (NSString *)_fetchUserRole:(Member *)member {
    if (self.type == 1) {
        if (member.userLevel == 1) return @"普通VIP";
        else if (member.userLevel == 2) return @"白银VIP";
        else if (member.userLevel == 3) return @"白金VIP";
        else if (member.userLevel == 4) return @"钻石VIP";
    } else {
        if (member.userType == 2) return @"采购专员";
        else if (member.userType == 3) return @"销售专员";
        else if (member.userType == 4) return @"物流专员";
        else if (member.userType == 5) return @"管理层";
        else if (member.userType == 6) return @"财务专员";
    }
    return @"";
}

- (NSString *)_formatData:(NSString *)dateStr {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy K:m:s a"];
    NSDate *date = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end
