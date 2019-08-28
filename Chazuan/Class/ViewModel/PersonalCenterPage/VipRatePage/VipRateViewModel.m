//
//  VipRateViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "VipRateViewModel.h"
#import "VipDollarRate.h"

@interface VipRateViewModel ()

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation VipRateViewModel

- (void)initialize {
    [super initialize];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"id"] = [SingleInstance stringForKey:ZGCManagerIdKey];
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_DOLLAR_RATE parameters:subscript.dictionary];
    @weakify(self);
    return [[[self.services.client enqueueParameter:paramters resultClass:VipDollarRate.class] doNext:^(HTTPResponse *response) {
        @strongify(self);
        [self _fetchDataSource:response.parsedResult];
    }] doError:^(NSError *error) {
        @strongify(self);
        [SVProgressHUD showErrorWithStatus:@"出错了"];
        [self.services popViewModelAnimated:YES];
    }];
}

- (void)_fetchDataSource:(VipDollarRate *)model {
    VipRateItemViewModel *viewModel1 = [VipRateItemViewModel itemViewModelWithTitle:@"普通VIP"];
    viewModel1.subTitle = model.temp1;
    viewModel1.rowHeight = ZGCConvertToPx(122);
    VipRateItemViewModel *viewModel2 = [VipRateItemViewModel itemViewModelWithTitle:@"白银VIP"];
    viewModel2.subTitle = model.temp2;
    viewModel2.rowHeight = ZGCConvertToPx(122);
    VipRateItemViewModel *viewModel3 = [VipRateItemViewModel itemViewModelWithTitle:@"白金VIP"];
    viewModel3.subTitle = model.temp3;
    viewModel3.rowHeight = ZGCConvertToPx(122);
    VipRateItemViewModel *viewModel4 = [VipRateItemViewModel itemViewModelWithTitle:@"钻石VIP"];
    viewModel4.subTitle = model.temp4;
    viewModel4.rowHeight = ZGCConvertToPx(122);
    
    self.dataSource = @[viewModel1, viewModel2, viewModel3, viewModel4];
}

@end
