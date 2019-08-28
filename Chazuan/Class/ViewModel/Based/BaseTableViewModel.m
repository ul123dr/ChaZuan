//
//  BaseTableViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"

@interface BaseTableViewModel ()
// 网络请求命令
@property (nonatomic, readwrite, strong) RACCommand *requestRemoteDataCommand;

@end

@implementation BaseTableViewModel

- (void)initialize {
    [super initialize];
    
    self.page = 1;
    self.perPage = 10;
    self.style = UITableViewStyleGrouped;
    
    // request remote data
    @weakify(self);
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self);
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

#pragma mark - Public Method subClass can override it
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

@end
