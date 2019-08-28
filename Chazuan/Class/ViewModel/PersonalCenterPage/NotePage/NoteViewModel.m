//
//  NoteViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NoteViewModel.h"

@interface NoteViewModel ()

@property (nonatomic, readwrite, strong) NSArray *noteList;
@property (nonatomic, readwrite, strong) NSString *startDate;
@property (nonatomic, readwrite, strong) NSString *endDate;

//@property (nonatomic, readwrite, strong) RACCommand *deleteCommand;
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation NoteViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldPullUpToLoadMore = YES;
    
    @weakify(self);
    RAC(self, noteList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    /// 数据源
    RAC(self, dataSource) = [[RACObserve(self, noteList) ignore:nil] map:^(NSArray * noteList) {
        @strongify(self);
        return [self _dataSourceWithNoteList:noteList];
    }];
    
//    self.deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *x) {
//
//        return [RACSignal empty];
//    }];
    
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        DateSelectViewModel *viewModel = [[DateSelectViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"搜索"}];
        [self.services pushViewModel:viewModel animated:YES];
        
        @weakify(self);
        viewModel.callback = ^(RACTuple *x) {
            @strongify(self);
            if (kObjectIsNotNil(x.first))
                self.startDate = x.first;
            else self.startDate = nil;
            if (kObjectIsNotNil(x.second))
                self.endDate = x.second;
            else self.endDate = nil;
            self.page = 1;
            [self.requestRemoteDataCommand execute:@1];
        };
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    
    NSArray * (^mapNoteList)(HTTPResponse *) = ^(HTTPResponse *response) {
        NoteModel *model = response.parsedResult;
        NSArray *noteList = model.list;
        if (page == 1) { // 下拉刷新
        } else { // 上拉刷新
            noteList = @[(self.noteList ?: @[]).rac_sequence, noteList.rac_sequence].rac_sequence.flatten.array;
        }
        return noteList;
    };

    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"currentPage"] = @(page);
    subscript[@"pageSize"] = @(self.perPage);
    if (kStringIsNotEmpty(self.startDate)) subscript[@"date_start"] = self.startDate;
    if (kStringIsNotEmpty(self.endDate)) subscript[@"date_end"] = self.endDate;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_MESSAGE_LIST parameters:subscript.dictionary];
    return [[self.services.client enqueueParameter:paramters resultClass:NoteModel.class] map:mapNoteList];
}

- (NSArray *)_dataSourceWithNoteList:(NSArray *)noteList {
    if (noteList.count == 0) return nil;
    return [noteList.rac_sequence.signal map:^id(NoteList *list) {
        NoteItemViewModel *noteViewModel = [NoteItemViewModel itemViewModelWithTitle:@""];
        noteViewModel.remark = [[list.remark stringByReplacingOccurrencesOfString:[SingleInstance stringForKey:ZGCUserWwwKey] withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGFloat height = sizeOfString(noteViewModel.remark, kFont(13), kScreenW-ZGCConvertToPx(30)).height+5;
        noteViewModel.rowHeight = ZGCConvertToPx(42)+height;
        noteViewModel.date = [self _formatData:list.createTime];
        return noteViewModel;
    }].toArray;
}

- (NSString *)_formatData:(NSString *)dateStr {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy K:m:s a"];
    NSDate *date = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end
