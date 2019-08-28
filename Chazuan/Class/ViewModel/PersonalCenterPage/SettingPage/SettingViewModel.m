//
//  SettingViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SettingViewModel.h"

@interface SettingViewModel ()

@property (nonatomic, readwrite, copy) NSString *dollarRate;
@property (nonatomic, readwrite, copy) NSString *maxTime;

@property (nonatomic, readwrite, strong) RACCommand *saveCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation SettingViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    
    @weakify(self);
    self.saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"dollar_rate"] = self.dollarRate;
        subscript[@"order_max_time"] = self.maxTime;
        
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_UPDATE_RATE parameters:subscript.dictionary];
        return [[[[self.services.client enqueueParameter:paramters resultClass:SettingModel.class] takeUntil:self.rac_willDeallocSignal] doNext:^(HTTPResponse *response) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }] doError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"id"] = [SingleInstance stringForKey:ZGCManagerIdKey];
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_METAL_BRAND parameters:subscript.dictionary];
    @weakify(self);
    return [[[self.services.client enqueueParameter:paramters resultClass:SettingModel.class] doNext:^(HTTPResponse *response) {
        @strongify(self);
        [self _fetchDataSource:response.parsedResult];
    }] doError:^(NSError *error) {
        @strongify(self);
        [SVProgressHUD showErrorWithStatus:@"出错了"];
        [self.services popViewModelAnimated:YES];
    }];
}

- (void)_fetchDataSource:(SettingModel *)model {
    // 第一组
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = 30.f;
    SettingItemViewModel *rateViewModel = [SettingItemViewModel itemViewModelWithTitle:@"美元汇率"];
    rateViewModel.value = [NSString stringWithFormat:@"%.2f", model.dollarRate.floatValue];
    RAC(self, dollarRate) = RACObserve(rateViewModel, value);
    rateViewModel.type = 0;
    SettingItemViewModel *timeViewModel = [SettingItemViewModel itemViewModelWithTitle:@"意向订单失效时间"];
    timeViewModel.value = model.maxTime.stringValue;
    RAC(self, maxTime) = RACObserve(timeViewModel, value);
    timeViewModel.type = 1;
    group1.itemViewModels = @[rateViewModel, timeViewModel];
    // 第二组
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.headerHeight = 10.f;
    DoneItemViewModel *doneViewModel = [DoneItemViewModel itemViewModelWithTitle:@"保存"];
    doneViewModel.doneCommand = self.saveCommand;
    group2.itemViewModels = @[doneViewModel];
    
    self.dataSource = @[group1, group2];
}

@end
