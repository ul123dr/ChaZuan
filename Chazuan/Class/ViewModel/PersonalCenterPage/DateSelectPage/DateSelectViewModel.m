//
//  DateSelectViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DateSelectViewModel.h"

@interface DateSelectViewModel ()

@property (nonatomic, readwrite, strong) RACCommand *doneCommand;
@property (nonatomic, readwrite, strong) RACSubject *dateSub;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation DateSelectViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.dateSub = [RACSubject subject];
    
    @weakify(self);
    self.doneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (kStringIsNotEmpty(self.endDate) && kStringIsNotEmpty(self.startDate)) {
            if ([self _compareOneDay:self.startDate withAnotherDay:self.endDate] != -1) {
                [SVProgressHUD showInfoWithStatus:@"结束日期必须大于开始日期"];
                return [RACSignal empty];
            }
        }
        !self.callback?:self.callback([RACTuple tupleWithObjects:self.startDate, self.endDate, nil]);
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    
    [self _fetchDataSource];
}

- (void)_fetchDataSource {
    // 第一组
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = 30.f;
    DateSelectItemViewModel *startViewModel = [DateSelectItemViewModel itemViewModelWithTitle:@"开始时间"];
    RAC(startViewModel, date) = RACObserve(self, startDate);
    startViewModel.start = YES;
    startViewModel.dateSub = self.dateSub;
    DateSelectItemViewModel *endViewModel = [DateSelectItemViewModel itemViewModelWithTitle:@"结束时间"];
    RAC(endViewModel, date) = RACObserve(self, endDate);
    endViewModel.start = NO;
    endViewModel.dateSub = self.dateSub;
    
    group1.itemViewModels = @[startViewModel, endViewModel];
    
    // 第二组
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.headerHeight = 10.f;
    DoneItemViewModel *doneViewModel = [DoneItemViewModel itemViewModelWithTitle:@"查 询"];
    doneViewModel.doneCommand = self.doneCommand;
    group2.itemViewModels = @[doneViewModel];
    
    self.dataSource = @[group1, group2];
}

- (int)_compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    } else if (result ==NSOrderedAscending) {
        return -1;
    }
    return 0;
}

@end
