//
//  DiamSearchResultViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSearchResultViewModel.h"
#import "DiamSearchModel.h"
#import "SearchPicModel.h"

@interface DiamSearchResultViewModel ()

@property (nonatomic, readwrite, strong) DiamSearchModel *diam;

@property (nonatomic, readwrite, strong) NSArray *supplierList;
@property (nonatomic, readwrite, strong) NSArray *resultList;

@property (nonatomic, readwrite, assign) NSInteger orderTJ;
@property (nonatomic, readwrite, assign) NSInteger orderSX;

@property (nonatomic, readwrite, copy) NSString *searchText;
@property (nonatomic, readwrite, assign) CGFloat headerHeight;
@property (nonatomic, readwrite, strong) NSArray *dataSource;
@property (nonatomic, readwrite, assign) NSInteger openedIndex;

@property (nonatomic, readwrite, assign) NSInteger type;

@property (nonatomic, readwrite, strong) RACSubject *discSub;
@property (nonatomic, readwrite, strong) RACSubject *moneySub;
@property (nonatomic, readwrite, strong) RACSubject *cellClickSub;
@property (nonatomic, readwrite, strong) RACSubject *detailSub;

@property (nonatomic, readwrite, strong) RACCommand *requestRemoteDataCommand;
@property (nonatomic, readwrite, strong) RACCommand *supplierCommand;

@property (nonatomic, readwrite, strong) RACCommand *shopcartCommand;
@property (nonatomic, readwrite, strong) RACCommand *quoteCommand;
@property (nonatomic, readwrite, strong) RACCommand *cartCommand;
@property (nonatomic, readwrite, strong) RACCommand *orderCommand;

@end

@implementation DiamSearchResultViewModel

- (void)initialize {
    [super initialize];
    
    self.type = [self.params[ViewModelTypeKey] integerValue];
    self.diam = [self _dealDiam:self.params[ViewModelModelKey]];
    self.orderTJ = 1;
    self.orderSX = 1;
    self.page = 0;
    self.perPage = 20;
    self.discSub = [RACSubject subject];
    self.moneySub = [RACSubject subject];
    self.cellClickSub = [RACSubject subject];
    self.detailSub = [RACSubject subject];
    self.showPicSub = [RACSubject subject];
    
    @weakify(self);
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self);
        self.openedIndex = -1;
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
    RAC(self, resultList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    /// 数据源
    RAC(self, dataSource) = [RACObserve(self, resultList) map:^id(NSArray *resultList) {
        return [self dataSourceWithResultList:resultList];
    }];
    
    self.supplierCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self requestSupplyDataSignal] takeUntil:self.rac_willDeallocSignal];
    }];
    
    RAC(self, supplierList) = self.supplierCommand.executionSignals.switchToLatest;
    
    if (self.type == 1) [self.supplierCommand execute:nil];
    else [self.requestRemoteDataCommand execute:@0];

    [self.discSub subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.orderTJ = 0;
        self.orderSX = !self.orderSX;
        self.page = 0;
        [self.requestRemoteDataCommand execute:@(self.page)];
    }];
    [self.moneySub subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.orderTJ = 1;
        self.orderSX = !self.orderSX;
        self.page = 0;
        [self.requestRemoteDataCommand execute:@(self.page)];
    }];
    
    [self.cellClickSub subscribeNext:^(RACTuple *x) {
        NSUInteger index = [x.second unsignedIntegerValue];
        NSInteger type = [x.first integerValue];
        DiamSearchResultItemViewModel *item = self.dataSource[index][0];
        DiamResultList *list = item.list;
        if (type == 0) {
            QuoteViewModel *viewModel = [[QuoteViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:self.type==1?@"白钻报价":@"彩钻报价",ViewModelModelKey:@[list],ViewModelTypeKey:@(YES)}];
            [self.services pushViewModel:viewModel animated:YES];
        } else if (type == 1) {
            CertSearchViewModel *viewModel = [[CertSearchViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"证书查询",ViewModelTypeKey:list.cert,ViewModelCertNoKey:list.certNo}];
            [self.services pushViewModel:viewModel animated:YES];
        } else if (type == 2) {
            if ([list.cert.uppercaseString containsString:@"GIA"]) {
                Alert(@"GIA官网加载时间较长，确定前往吗？", @"取消", @"确定", ^(BOOL action) {
                    if (action) {
                        NSString *url = [NSString stringWithFormat:@"http://%@/newManager/app/cert.html?url=%@&title=%@", [SingleInstance stringForKey:ZGCUserWwwKey], [NSString stringWithFormat:@"https:/www.gia.edu/CN/report-check?reportno=%@", list.certNo].stringByURLEncode, @"证书详情".stringByURLEncode];
//                        NSString *url = [NSString stringWithFormat:@"https:/www.gia.edu/CN/report-check?reportno=%@&title=证书详情", list.certNo];
                        
                        PdfViewModel *viewModel = [[PdfViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"证书详情",ViewModelPdfUrlKey:[url stringByURLEncode]}];
                        [self.services pushViewModel:viewModel animated:YES];
                    }
                });
            } else if ([list.cert.uppercaseString containsString:@"IGI"]) {
                Alert(@"IGI官网加载时间较长，确定前往吗？", @"取消", @"确定", ^(BOOL action) {
                    if (action) {
                        NSString *url = [NSString stringWithFormat:@"http://%@/newManager/app/cert.html?url=%@&title=%@", [SingleInstance stringForKey:ZGCUserWwwKey], [NSString stringWithFormat:@"https://www.igiworldwide.com/ch/verify.php?r=%@", list.certNo].stringByURLEncode, @"证书详情".stringByURLEncode];
//                        NSString *url = [NSString stringWithFormat:@"https://www.igiworldwide.com/ch/verify.php?r=%@&title=证书详情", list.certNo];
                        
                        PdfViewModel *viewModel = [[PdfViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"证书详情",ViewModelPdfUrlKey:[url stringByURLEncode]}];
                        [self.services pushViewModel:viewModel animated:YES];
                    }
                });
            }
        } else if (type == 3) {
            if (kStringIsNotEmpty(list.daylight)) {
                KeyedSubscript *subscript = [KeyedSubscript subscript];
                subscript[@"certNo"] = list.certNo;
                subscript[@"url"] = list.daylight;
                
                URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_DIAM_PIC, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:subscript.dictionary];
                [[self.services.client enqueueParameter:paramters resultClass:SearchPicModel.class] subscribeNext:^(HTTPResponse *response) {
                    SearchPicModel *picModel = response.parsedResult;
                    if (kStringIsNotEmpty(picModel.pic)) {
                        PdfViewModel *viewModel = [[PdfViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"图片",ViewModelPdfUrlKey:picModel.pic,ViewModelPdfTypeKey:@"diamonds_images_temp"}];
                        [self.services pushViewModel:viewModel animated:YES];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"找不到该图片"];
                    }
                } error:^(NSError * error) {
                    [SVProgressHUD showErrorWithStatus:@"系统繁忙！请稍后再试！"];
                }];
            } else {
                PdfViewModel *viewModel = [[PdfViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"图片",ViewModelPdfUrlKey:list.video}];
                [self.services pushViewModel:viewModel animated:YES];
            }
        } else if (type == 4) {
            NSString *url = x.third;
            if (![url hasPrefix:@"http://"] || ![url hasPrefix:@"https://"]) {
                if ([url hasPrefix:@"//"]) {
                    url = [@"http:" stringByAppendingString:url];
                } else {
                    url = [@"http://" stringByAppendingString:url];
                }
            }
            PdfViewModel *viewModel = [[PdfViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"官网",ViewModelPdfUrlKey:url}];
            [self.services pushViewModel:viewModel animated:YES];
        }
    }];
    
    [self.detailSub subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue > self.resultList.count) return;
        @weakify(self);
        DiamResultList *list = self.resultList[x.integerValue-1];
        if ([list.daylight containsString:@".jpg"] || [list.daylight containsString:@".png"] || [list.daylight containsString:@".jpeg"]) {
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"certNo"] = list.certNo;
            subscript[@"url"] = [list.daylight stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_DIAM_PIC, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:subscript.dictionary];
            [[self.services.client enqueueParameter:paramters resultClass:SearchPicModel.class] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                SearchPicModel *picModel = response.parsedResult;
                if (kStringIsNotEmpty(picModel.pic)) {
                    picModel.pic = [NSString stringWithFormat:@"http://%@/fileserver/diamonds_images_temp/%@", [SingleInstance stringForKey:ZGCUserWwwKey], picModel.pic];
                    if ([SharedAppDelegate.manager.isOwnServer zgc_parseInt] == 2) {
                        picModel.pic = [NSString stringWithFormat:@"http://www.zuansoft.com/fileserver/diamonds_images_temp/%@", picModel.pic];
                    }
                    [self.showPicSub sendNext:picModel.pic];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"找不到该图片"];
                }
            } error:^(NSError * error) {
                [SVProgressHUD showErrorWithStatus:@"系统繁忙！请稍后再试！"];
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:@"该图片手机端无法浏览"];
        }
    }];
    
    self.shopcartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        ShopCartViewModel *viewModel = [[ShopCartViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"我的购物车"}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.quoteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSMutableArray *selectArray = [NSMutableArray array];
        for (NSArray *dataArr in self.dataSource) {
            DiamSearchResultItemViewModel *item = dataArr.firstObject;
            if (item.selected) [selectArray addObject:item.list];
        }
        if (selectArray.count > 0) {
            QuoteViewModel *viewModel = [[QuoteViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:self.type==1?@"白钻报价":@"彩钻报价",ViewModelModelKey:[selectArray copy],ViewModelTypeKey:@(YES)}];
            [self.services pushViewModel:viewModel animated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:@"请先选择要报价的裸钻"];
        }
        return [RACSignal empty];
    }];
    self.cartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSMutableArray *selectArray = [NSMutableArray array];
        for (NSArray *dataArr in self.dataSource) {
            DiamSearchResultItemViewModel *item = dataArr.firstObject;
            if (item.selected) [selectArray addObject:item.list];
        }
        if (selectArray.count > 0) {
            for (int i = 0; i < selectArray.count; i++) {
                DiamResultList *list = selectArray[i];
                if (list.sysStatus.integerValue == 4) {
                    Alert([NSString stringWithFormat:@"第 %@ 颗裸石已被锁定，无法下单！", @(i+1)], nil, @"知道了", nil);
                    return [RACSignal empty];
                }
            }
            [MBProgressHUD zgc_show];
            dispatch_queue_t  queue = dispatch_queue_create("request_queue",NULL);
            //2.同步执行任务
            [selectArray enumerateObjectsUsingBlock:^(DiamResultList *list, NSUInteger idx, BOOL *stop) {
                __block BOOL blockStop = stop;
                dispatch_sync(queue, ^{
                    KeyedSubscript *subscript = [KeyedSubscript subscript];
                    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
                    subscript[@"www_type"] = @2;
                    subscript[@"good_type"] = @0;
                    subscript[@"good_id"] = list.listId;
                    subscript[@"txt"] = [list.toJSONString stringByURLEncode];
                    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_STYLE_ADDCART parameters:subscript.dictionary];
                    
                    @weakify(self);
                    [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                        @strongify(self);
                        ObjectT *obj = response.parsedResult;
                        if (obj.appCheckCode) {
                            blockStop = YES;
                            [MBProgressHUD zgc_hideHUD];
                            [self.services.client loginAtOtherPlace];
                        } else if (idx==selectArray.count-1) {
                            [MBProgressHUD zgc_hideHUD];
                            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
                        }
                    } error:^(NSError * _Nullable error) {
                        [MBProgressHUD zgc_hideHUD];
                        blockStop = YES;
                        [SVProgressHUD showErrorWithStatus:@"加入购物车失败"];
                    }];
                });
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:@"先选择要加入购物车的裸钻"];
        }
        return [RACSignal empty];
    }];
    self.orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSMutableArray *selectArray = [NSMutableArray array];
        for (NSArray *dataArr in self.dataSource) {
            DiamSearchResultItemViewModel *item = dataArr.firstObject;
            if (item.selected) [selectArray addObject:item.list];
        }
        if (selectArray.count > 0) {
            for (int i = 0; i < selectArray.count; i++) {
                DiamResultList *list = selectArray[i];
                if (list.sysStatus.integerValue == 4) {
                    Alert([NSString stringWithFormat:@"第 %@ 颗裸石已被锁定，无法下单！", @(i+1)], nil, @"知道了", nil);
                    return [RACSignal empty];
                }
            }
            
            [MBProgressHUD zgc_show];
            __block CGFloat price = 0;
            dispatch_queue_t  queue = dispatch_queue_create("request_queue",NULL);
            [selectArray enumerateObjectsUsingBlock:^(DiamResultList *list, NSUInteger idx, BOOL *stop) {
                price += list.rate.floatValue * list.dollarRate.floatValue;
                __block BOOL blockStop = stop;
                dispatch_sync(queue, ^{
                    KeyedSubscript *subscript = [KeyedSubscript subscript];
                    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
                    subscript[@"status"] = @21;
                    subscript[@"mobile"] = [self.services.client.currentUser.list[0] mobile];
                    subscript[@"good_type"] = @0;
                    subscript[@"temp"] = [NSString stringWithFormat:@"[{\"good_type\":0,\"num\":1,\"isown\":false,\"good_id\":%@}]",list.listId];
                    if (selectArray.count > 0) {
                        if (idx == selectArray.count-1) {
                            subscript[@"send_message_type"] = @(1);
                            subscript[@"send_message_price"] = [NSString stringWithFormat:@"%.2f", price];
                            subscript[@"send_message_num"] = @(selectArray.count);
                        } else {
                            subscript[@"send_message_type"] = @(0);
                        }
                    }
                    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ORDER parameters:subscript.dictionary];
                    @weakify(self);
                    [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                        @strongify(self);
                        ObjectT *obj = response.parsedResult;
                        if (obj.appCheckCode) {
                            [MBProgressHUD zgc_hideHUD];
                            blockStop = YES;
                            [self.services.client loginAtOtherPlace];
                        } else if (idx==selectArray.count-1) {
                            [MBProgressHUD zgc_hideHUD];
                            [SVProgressHUD showSuccessWithStatus:@"订单已生成"];
                        }
                    } error:^(NSError * _Nullable error) {
                        [MBProgressHUD zgc_hideHUD];
                        blockStop = YES;
                        [SVProgressHUD showErrorWithStatus:@"生成意向订单失败"];
                    }];
                });
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:@"请先选择要下单的裸钻"];
        }
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    @weakify(self);
    NSArray * (^mapList)(HTTPResponse *) = ^(HTTPResponse *response) {
        @strongify(self);
        DiamResultModel *model = response.parsedResult;
        if (model.appCheckCode) {
            [self.services.client loginAtOtherPlace];
            return @[];
        }
        NSArray *list = model.list;
        if (page == 0) { // 下拉刷新
        } else { // 上拉刷新
            list = @[(self.resultList ?: @[]).rac_sequence, list.rac_sequence].rac_sequence.flatten.array;
        }
        return list;
    };
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"currentPage"] = @(page).stringValue;
    subscript[@"pageSize"] = @(self.perPage).stringValue;
    subscript[@"dollar_rate"] = self.diam.dollarRate;
    subscript[@"order_tj"] = @(self.orderTJ);
    subscript[@"order_sx"] = @(self.orderSX);
    subscript[@"rap_ids"] = @"";
    if (kStringIsNotEmpty(self.diam.certNo)) subscript[@"reportNo"] = self.diam.certNo;
    if (kStringIsNotEmpty(self.diam.sizeMin)) subscript[@"d_size_min"] = self.diam.sizeMin;
    if (kStringIsNotEmpty(self.diam.sizeMax)) subscript[@"d_size_max"] = self.diam.sizeMax;
    if (kStringIsNotEmpty(self.diam.cert)) {
        if ([self.diam.cert containsString:@"Other"]) {
            subscript[@"cert"] = [self.diam.cert stringByAppendingString:@",EGL"];
        } else {
            subscript[@"cert"] = self.diam.cert;
        }
    }
    if (kStringIsNotEmpty(self.diam.shape)) subscript[@"shape"] = self.diam.shape;
    if (kStringIsNotEmpty(self.diam.color)) subscript[@"color"] = self.diam.color;
    if (kStringIsNotEmpty(self.diam.clarity)) subscript[@"clarity"] = self.diam.clarity;
    if (kStringIsNotEmpty(self.diam.cut)) subscript[@"cut"] = self.diam.cut;
    if (kStringIsNotEmpty(self.diam.polish)) subscript[@"polish"] = self.diam.polish;
    if (kStringIsNotEmpty(self.diam.sym)) subscript[@"sym"] = self.diam.sym;
    if (self.type == 1) {
        if (kStringIsNotEmpty(self.diam.milk)) subscript[@"milky"] = [self.diam.milk stringByURLEncode];
        if (kStringIsNotEmpty(self.diam.browness)) subscript[@"browness"] = [self.diam.browness stringByURLEncode];
        if (kStringIsNotEmpty(self.diam.green)) subscript[@"green"] = [self.diam.green stringByURLEncode];
        if (kStringIsNotEmpty(self.diam.black)) subscript[@"black"] = [self.diam.black stringByURLEncode];
        if (kStringIsNotEmpty(self.diam.location)) subscript[@"location"] = self.diam.location;
        if (kStringIsNotEmpty(self.diam.dRef)) subscript[@"d_ref"] = self.diam.dRef;
        subscript[@"sys_status"] = self.diam.status.length>0?self.diam.status:@"-1";
    }
    if (kStringIsNotEmpty(self.diam.flour)) subscript[@"flour"] = self.diam.flour;
    if (kStringIsNotEmpty(self.diam.detail)) {
        subscript[@"detail"] = self.diam.detail;
        subscript[@"is_accurate_and_detail"] = @4;
    } else {
        subscript[@"is_accurate_and_detail"] = @1;
        subscript[@"detail"] = @([[SingleInstance stringForKey:ZGCManagerIdKey] zgc_parseInt]+10000);
    }
    //    if ([SharedAppDelegate.manager.isOwnServer zgc_parseInt]==1) {
    //        subscript[@"detail"] = @([[SingleInstance stringForKey:ZGCManagerIdKey] zgc_parseInt]+10000);
    //        subscript[@"is_accurate_and_detail"] = @4;
    //    }
    NSString *path;
    if (self.type == 1) {
        path = POST_SEARCH_DIAM_RESULT_LIST;
    } else {
        path = POST_SEARCH_FANCY_RESULT_LIST;
    }
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:path parameters:subscript.dictionary];
    return [[[self.services.client enqueueParameter:paramters resultClass:DiamResultModel.class] map:mapList] doError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}

- (NSArray *)dataSourceWithResultList:(NSArray *)resultList {
    self.goodIsNull = resultList.count == 0;
    
    NSMutableArray *array = [NSMutableArray array];
    
    DiamSearchResultItemViewModel *header = [DiamSearchResultItemViewModel itemViewModel];
    header.type = self.type;
    header.index = 0;
    header.discType = self.orderTJ;
    header.moneyType = self.orderSX;
    header.discSub = self.discSub;
    header.moneySub = self.moneySub;
    [array addObject:@[header]];
    
    for (int i = 1; i <= resultList.count; i++) {
        DiamResultList *list = resultList[i-1];
        list.num = self.diam.addNum;
        list.dollarRate = self.diam.dollarRate;
        DiamSearchResultItemViewModel *item = [DiamSearchResultItemViewModel itemViewModel];
        item.list = list;
        item.index = i;
        item.clickSub = self.cellClickSub;
        item.detailSub = self.detailSub;
        if (self.page != 0 && i < self.dataSource.count) {
            DiamSearchResultItemViewModel *viewModel = self.dataSource[i][0];
            item.selected = viewModel.selected;
            item.opened = viewModel.opened;
            item.rowHeight = viewModel.rowHeight;
        }
        [array addObject:@[item]];

        item.selectOperation = ^(BOOL selected) {
            DiamSearchResultItemViewModel *blockItem = self.dataSource[i][0];
            blockItem.selected = selected;
            [array replaceObjectAtIndex:i withObject:@[blockItem]];
            self.dataSource = [array copy];
        };
        item.clickOperation = ^(BOOL opened) {
            DiamSearchResultItemViewModel *blockItem = self.dataSource[i][0];
            blockItem.supplyList = [self _supplyList:list.detail];
            blockItem.rowHeight = opened?ZGCConvertToPx(360):ZGCConvertToPx(40);
            blockItem.opened = opened;
            [array replaceObjectAtIndex:i withObject:@[blockItem]];
            if (self.openedIndex != -1 && self.openedIndex != i) {
                DiamSearchResultItemViewModel *openedItem = self.dataSource[self.openedIndex][0];
                openedItem.opened = NO;
                openedItem.rowHeight = ZGCConvertToPx(40);
                [array replaceObjectAtIndex:self.openedIndex withObject:@[openedItem]];
            }
            self.openedIndex = opened?i:-1;
            self.dataSource = [array copy];
        };
        @weakify(self);
        [RACObserve(item.list, dollarRate) subscribeNext:^(NSString *rate) {
            @strongify(self);
            if (self.dataSource.count <= i) return;
            if (kStringIsEmpty(rate) || [item.list.dollarRate isEqualToString:rate]) return;
            item.list.dollarRate = rate;
            NSMutableArray *data = [NSMutableArray arrayWithArray:self.dataSource];
            [data replaceObjectAtIndex:i withObject:@[item]];
            self.dataSource = [data copy];
        }];
        [RACObserve(item.list, num) subscribeNext:^(NSString *num) {
            @strongify(self);
            if (self.dataSource.count <= i) return;
            if (kStringIsEmpty(num) || [item.list.num isEqualToString:num]) return;
            NSMutableArray *data = [NSMutableArray arrayWithArray:self.dataSource];
            [data replaceObjectAtIndex:i withObject:@[item]];
            self.dataSource = [data copy];
        }];
    }
    return [array copy];
}

- (RACSignal *)requestSupplyDataSignal {
    NSArray * (^mapList)(HTTPResponse *) = ^(HTTPResponse *response) {
        DiamSupplyModel *model = response.parsedResult;
        if (model.appCheckCode) {
            [self.services.client loginAtOtherPlace];
            return @[];
        }
        self.page = 0;
        [self.requestRemoteDataCommand execute:@0];
        return model.list;
    };
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"currentPage"] = @0;
    subscript[@"pageSize"] = @999;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_SUPPLIER_LIST parameters:subscript.dictionary];
    
    return [[[self.services.client enqueueParameter:paramters resultClass:DiamSupplyModel.class] map:mapList] doError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取供应商失败"];
    }];
}

- (DiamSearchModel *)_dealDiam:(DiamSearchModel *)diam {
    NSMutableString *searchText = [NSMutableString string];
    if (kStringIsNotEmpty(diam.certNo)) [searchText appendFormat:@"证书编号：%@；", diam.certNo];
    if (self.type == 1) {
        if (kStringIsNotEmpty(diam.detail)) [searchText appendFormat:@"供应商：%@；", diam.detail];
        if (kStringIsNotEmpty(diam.dRef)) [searchText appendFormat:@"货号：%@；", diam.dRef];
        if (kStringIsNotEmpty(diam.addNum) && [SingleInstance boolForKey:DiscShowKey]) [searchText appendFormat:@"加点：%@；", diam.addNum];
    } else {
        if (kStringIsNotEmpty(diam.addNum) && [SingleInstance boolForKey:FancyRapKey]) [searchText appendFormat:@"倍率：%@；", diam.addNum];
    }
    if (kStringIsNotEmpty(diam.dollarRate) && ![[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.zuanshi.hk"] && [SingleInstance boolForKey:DollarShowKey]) [searchText appendFormat:@"汇率：%@；", diam.dollarRate];
    if (kStringIsNotEmpty(diam.sizeMin)) {
        [searchText appendFormat:@"克拉：%@", diam.sizeMin];
        if (kStringIsNotEmpty(diam.sizeMax))
            [searchText appendFormat:@" ~ %@；", diam.detail];
        [searchText appendString:@"；"];
    }
    if (kStringIsNotEmpty(diam.cert)) [searchText appendFormat:@"证书：%@；", diam.cert];
    if (kStringIsNotEmpty(diam.shape)) {
        [searchText appendFormat:@"形状：%@；", diam.shape];
        NSArray *shapeArr = @[];
        for (NSString *shape in [diam.shape componentsSeparatedByString:@","]) {
            shapeArr = [shapeArr arrayByAddingObject:shape.stringByURLEncode];
        }
        diam.shape = [shapeArr componentsJoinedByString:@","];
    }
    NSString *color = @"";
    if (self.type == 2) {
        if (kStringIsNotEmpty(diam.strength)) {
            [searchText appendFormat:@"强度：%@；", diam.strength];
            color = [color stringByAppendingString:diam.strength];
        }
        if (kStringIsNotEmpty(diam.lustre)) {
            [searchText appendFormat:@"光彩：%@；", diam.lustre];
            color = [color stringByAppendingString:diam.lustre];
        }
    }
    if (kStringIsNotEmpty(diam.color)) {
        [searchText appendFormat:@"颜色：%@；", diam.color];
        color = [color stringByAppendingString:diam.color];
        diam.color = color;
    }
    if (kStringIsNotEmpty(diam.clarity)) [searchText appendFormat:@"净度：%@；", diam.clarity];
    if (kStringIsNotEmpty(diam.cut)) {
        if (self.type == 1) [searchText appendFormat:@"切工：%@；", diam.cut];
        diam.cut = [self _dealEx:diam.cut];
    }
    if (kStringIsNotEmpty(diam.polish)) {
        [searchText appendFormat:@"抛光：%@；", diam.polish];
        diam.polish = [self _dealEx:diam.polish];
    }
    if (kStringIsNotEmpty(diam.sym)) {
        diam.sym = [self _dealEx:diam.sym];
        [searchText appendFormat:@"对称：%@；", diam.sym];
    }
    if (kStringIsNotEmpty(diam.milk)) {
        NSArray *milkArr = @[];
        NSArray *encodeArr = @[];
        BOOL m = NO, n = NO;
        for (NSString *str in [diam.milk componentsSeparatedByString:@","]) {
            if ([str isEqualToString:@"M"] && !m) {
                milkArr = [milkArr arrayByAddingObject:@"有奶"];
                encodeArr = [encodeArr arrayByAddingObject:[@"有奶" stringByURLEncode]];
                m = YES;
            } else if ([str isEqualToString:@"N"] && !n) {
                milkArr = [milkArr arrayByAddingObject:@"无奶"];
                encodeArr = [encodeArr arrayByAddingObject:[@"无奶" stringByURLEncode]];
                n = YES;
            } else {
                milkArr = [milkArr arrayByAddingObject:str];
            }
        }
        if (self.type == 1) [searchText appendFormat:@"奶色：%@；", [milkArr componentsJoinedByString:@","]];
        diam.milk = [encodeArr componentsJoinedByString:@","];
    }
    if (kStringIsNotEmpty(diam.browness)) {
        NSArray *milkArr = @[];
        NSArray *encodeArr = @[];
        BOOL m = NO, n = NO;
        for (NSString *str in [diam.browness componentsSeparatedByString:@","]) {
            if ([str isEqualToString:@"B"] && !m) {
                milkArr = [milkArr arrayByAddingObject:@"有咖"];
                encodeArr = [encodeArr arrayByAddingObject:[@"有咖" stringByURLEncode]];
                m = YES;
            } else if ([str isEqualToString:@"N"] && !n) {
                milkArr = [milkArr arrayByAddingObject:@"无咖"];
                encodeArr = [encodeArr arrayByAddingObject:[@"无咖" stringByURLEncode]];
                n = YES;
            } else {
                milkArr = [milkArr arrayByAddingObject:str];
            }
        }
        if (self.type == 1) [searchText appendFormat:@"咖色：%@；", [milkArr componentsJoinedByString:@","]];
        diam.browness = [encodeArr componentsJoinedByString:@","];
    }
    if (kStringIsNotEmpty(diam.green)) {
        NSArray *milkArr = @[];
        NSArray *encodeArr = @[];
        BOOL m = NO, n = NO;
        for (NSString *str in [diam.green componentsSeparatedByString:@","]) {
            if ([str isEqualToString:@"G"] && !m) {
                milkArr = [milkArr arrayByAddingObject:@"有绿"];
                encodeArr = [encodeArr arrayByAddingObject:[@"有绿" stringByURLEncode]];
                m = YES;
            } else if ([str isEqualToString:@"N"] && !n) {
                milkArr = [milkArr arrayByAddingObject:@"无绿"];
                encodeArr = [encodeArr arrayByAddingObject:[@"无绿" stringByURLEncode]];
                n = YES;
            } else {
                milkArr = [milkArr arrayByAddingObject:str];
            }
        }
        if (self.type == 1) [searchText appendFormat:@"绿色：%@；", [milkArr componentsJoinedByString:@","]];
        diam.green = [encodeArr componentsJoinedByString:@","];
    }
    if (kStringIsNotEmpty(diam.black)) {
        NSArray *milkArr = @[];
        NSArray *encodeArr = @[];
        BOOL m = NO, n = NO;
        for (NSString *str in [diam.black componentsSeparatedByString:@","]) {
            if ([str isEqualToString:@"B"] && !m) {
                milkArr = [milkArr arrayByAddingObject:@"有黑"];
                encodeArr = [encodeArr arrayByAddingObject:[@"有黑" stringByURLEncode]];
                m = YES;
            } else if ([str isEqualToString:@"N"] && !n) {
                milkArr = [milkArr arrayByAddingObject:@"无黑"];
                encodeArr = [encodeArr arrayByAddingObject:[@"无黑" stringByURLEncode]];
                n = YES;
            } else {
                milkArr = [milkArr arrayByAddingObject:str];
            }
        }
        if (self.type == 1) [searchText appendFormat:@"黑点：%@；", [milkArr componentsJoinedByString:@","]];
        diam.black = [encodeArr componentsJoinedByString:@","];
    }
    if (kStringIsNotEmpty(diam.flour)) {
        [searchText appendFormat:@"荧光：%@；", diam.flour];
        NSString *nStr = @"";
        for (NSString *str in [diam.flour componentsSeparatedByString:@","]) {
            if([str isEqualToString:@"N"]){
                nStr = [nStr stringByAppendingString:@"NON,"];
            } else if([str isEqualToString:@"F"]){
                nStr = [nStr stringByAppendingString:@"FNT,"];
            } else if([str isEqualToString:@"M"]){
                nStr = [nStr stringByAppendingString:@"MED,"];
            } else if([str isEqualToString:@"S"]){
                nStr = [nStr stringByAppendingString:@"STG,"];
            } else if([str isEqualToString:@"VS"]){
                nStr = [nStr stringByAppendingString:@"VST,"];
            }
        }
        diam.flour = nStr;
    }
    if (self.type == 1) {
        if (kStringIsNotEmpty(diam.status) && ![diam.status isEqualToString:@"-1"]) [searchText appendFormat:@"状态：%@；", diam.status];
    }
    if (kStringIsNotEmpty(diam.location)) {
        if (self.type == 1) [searchText appendFormat:@"所在地：%@；", diam.location];
        NSArray *locationArr = @[];
        for (NSString *location in [diam.location componentsSeparatedByString:@","]) {
            locationArr = [locationArr arrayByAddingObject:location.stringByURLEncode];
        }
        diam.location = [locationArr componentsJoinedByString:@","];
    }
    self.headerHeight = sizeOfString(searchText, kFont(12), kScreenW-ZGCConvertToPx(20)).height+5+ZGCConvertToPx(52);
    self.searchText = searchText;
    return diam;
}

- (NSString *)_dealEx:(NSString *)exStr {
    NSString *nStr = @"";
    for (NSString *str in [exStr componentsSeparatedByString:@","]) {
        if([str isEqualToString:@"EX"]){
            nStr = [nStr stringByAppendingString:@"EX,"];
        } else if([str isEqualToString:@"VG"]){
            nStr = [nStr stringByAppendingString:@"V,"];
        } else if([str isEqualToString:@"GD"]){
            nStr = [nStr stringByAppendingString:@"G,"];
        } else if([str isEqualToString:@"FR"]){
            nStr = [nStr stringByAppendingString:@"F,"];
        }
    }
    return nStr;
}

- (DiamSupplyList *)_supplyList:(NSString *)detail {
    for (DiamSupplyList *list in self.supplierList) {
        if ([list.supplierNo isEqualToString:detail]) return list;
    }
    return nil;
}

@end
