//
//  OrderCenterViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderCenterViewModel.h"
#import "ObjectT.h"

@interface OrderCenterViewModel ()

@property (nonatomic, readwrite, strong) NSArray *titleArray;
@property (nonatomic, readwrite, copy) NSString *titleViewTitle;
@property (nonatomic, readwrite, strong) NSArray *segmentArr;
@property (nonatomic, readwrite, strong) NSArray *segmentIndexStatus;
@property (nonatomic, readwrite, strong) NSArray *orderList;

@property (nonatomic, readwrite, assign) NSInteger searchStatus;
@property (nonatomic, readwrite, copy) NSString *searchOrderNo;

@property (nonatomic, readwrite, strong) RACCommand *confirmCommand;
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation OrderCenterViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.orderType = 1;
    self.searchStatus = 0;
    self.searchOrderNo = self.params[ViewModelSearchOrderNoKey];
    self.shouldPullUpToLoadMore = YES;
    
    NSMutableArray *list = [NSMutableArray array];
    if (SharedAppDelegate.manager.isYGoodsStock == 0) {
        [list addObject:[SiftList listWithId:@1 name:@"白钻订单"]];
        [list addObject:[SiftList listWithId:@2 name:@"彩钻订单"]];
    }
    if (SharedAppDelegate.manager.isYGoodsStock == 3) {
        [list addObject:[SiftList listWithId:@3 name:@"祖母绿订单"]];
    }
    [list addObject:[SiftList listWithId:@4 name:@"款式订单"]];
    [list addObject:[SiftList listWithId:@5 name:@"现货订单"]];
    if (SharedAppDelegate.manager.isSourceType == 2) {
        [list addObject:[SiftList listWithId:@6 name:@"找托订单"]];
    }
    self.titleArray = [list copy];
    
    @weakify(self);
    [[RACObserve(self, orderType) deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        SiftList *list;
        for (SiftList *iList in self.titleArray) {
            if (iList.listId.integerValue == x.integerValue) { list = iList; break;}
        }
        self.titleViewTitle = [NSString stringWithFormat:@" %@ ", list.name];
        [self _changeSegment:x.integerValue];
    }];
    
    [[RACObserve(self, segmentIndex) deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        NSInteger segmentStatus = [self.segmentIndexStatus[x.integerValue] integerValue];
        if (segmentStatus == self.searchStatus) return;
        self.searchStatus = segmentStatus;
        self.page = 1;
        [self.requestRemoteDataCommand execute:@1];
    }];
    
    /// 商品列表
    RAC(self, orderList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    /// 数据源
    RAC(self, dataSource) = [[RACObserve(self, orderList) ignore:nil] map:^(NSArray * orderList) {
        @strongify(self);
        return [self dataSourceWithOrderList:orderList];
    }];
    
    self.confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *oldId) {
        @strongify(self);
        if (kObjectIsNil(oldId)) {
            Alert(@"订单id为空", @"取消", @"确定", nil);
            return [RACSignal empty];
        }
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"order_id"] = oldId;
        
        NSString *path = @"";
        if (self.orderType == 1 || self.orderType == 2 || self.orderType == 3) {
            path = POST_DIAM_SUER;
            subscript[@"status"] = @"22";
            
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_DIAM_CHECK parameters:subscript.dictionary];
            @weakify(self);
            return [[[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] doNext:^(HTTPResponse *response) {
                @strongify(self);
                ObjectT *model = response.parsedResult;
                if (model.appCheckCode) {
                    [self.services.client loginAtOtherPlace];
                } else {
                    if (model.status == 21) {
                        [self sureOrder:path parameter:subscript];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"该订单状态已更改或已失效！"];
                    }
                }
            }] doError:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"查询状态失败"];
            }];
        } else if (self.orderType == 4 || self.orderType == 6) {
            path = POST_STYLE_SUER;
            subscript[@"status"] = @"32";
            if (self.orderType == 6) {
                Alert(@"确认订单后货品将被锁定，请2天内安排取货！（确认后订单号会变化，该操作无法撤销，请谨慎操作，生效时间待定）", @"取消", @"确定", ^(BOOL action) {
                    if (action) {
                        [self sureOrder:path parameter:subscript];
                    }
                });
            } else {
                [self sureOrder:path parameter:subscript];
            }
        } else if (self.orderType == 5) {
            path = POST_GOOD_SUER;
            subscript[@"status"] = @"82";
            [self sureOrder:path parameter:subscript];
        }
        return [RACSignal empty];
    }];
    
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SearchViewModel *viewModel = [[SearchViewModel alloc] initWithServices:self.services params:@{ViewModelTypeKey:@1}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

- (void)sureOrder:(NSString *)urlPath parameter:(KeyedSubscript *)subscript {
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:urlPath parameters:subscript.dictionary];
    [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
        ObjectT *obj = response.parsedResult;
        if (obj.appCheckCode) {
            [self.services.client loginAtOtherPlace];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"订单已确认"];
            self.page = 1;
            [self.requestRemoteDataCommand execute:@1];
        }
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showInfoWithStatus:@"系统繁忙！请稍后再试！"];
    }];
}

- (void)_changeSegment:(NSInteger)type {
    if (type == 1 || type == 2) {
        self.segmentArr = @[@"全部订单",@"待确认",@"采购中",@"采购成功",@"待发货",@"已发货",@"订单完成",@"无效订单",@"已退订单"];
        self.segmentIndexStatus = @[@"0",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    } else if (type == 4 || type == 6) {
        self.segmentArr = @[@"全部订单",@"待确认",@"已确认",@"生产中",@"已出单",@"已发货",@"已完成",@"无效订单"];
        self.segmentIndexStatus = @[@"0",@"31",@"32",@"33",@"34",@"35",@"36",@"37"];
    } else if (type == 5) {
        self.segmentArr = @[@"全部订单",@"待确认",@"待发货",@"待收货",@"已完成",@"已退货",@"已失效"];
        self.segmentIndexStatus = @[@"0",@"81",@"82",@"83",@"86",@"87",@"88"];
    }
    self.segmentIndex = 0;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    @weakify(self);
    NSArray * (^mapOrderList)(HTTPResponse *) = ^(HTTPResponse *response) {
        OrderModel *model = response.parsedResult;
        if (model.appCheckCode) {
            [self.services.client loginAtOtherPlace];
            return @[];
        }
        NSArray *orderList = model.list;
        if (page == 1) { // 下拉刷新
        } else { // 上拉刷新
            orderList = @[(self.orderList ?: @[]).rac_sequence, orderList.rac_sequence].rac_sequence.flatten.array;
        }
        return orderList;
    };
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"currentPage"] = @(page).stringValue;
    subscript[@"pageSize"] = @(self.perPage).stringValue;
    subscript[@"www_type"] = @"2";
    if(self.orderType == 1){
        subscript[@"good_type"] = @"0";
    } else if(self.orderType == 2){
        subscript[@"good_type"] = @"4";
    } else if(self.orderType == 4){
        subscript[@"good_type"] = @"5";
    } else if(self.orderType == 5){
        subscript[@"good_type"] = @"8";
    } else if (self.orderType == 6) {
        subscript[@"good_type"] = @"12";
    }
    subscript[@"order_tj"] = @"0";
    subscript[@"order_sx"] = @"0";
    subscript[@"user_type"] = @(self.services.client.currentUser.userType);
    if (self.services.client.currentUser.userType == 3) {
        subscript[@"salesmen_id"] = [SingleInstance stringForKey:ZGCUserIdKey];
    } else if (self.services.client.currentUser.userType == 2) {
        subscript[@"buyer_id"] = [SingleInstance stringForKey:ZGCUserIdKey];
    }
    if (self.searchStatus != 0) subscript[@"status"] = @(self.searchStatus);
    if (kStringIsNotEmpty(self.searchOrderNo)) {
        subscript[@"order_no"] = self.searchOrderNo;
        self.searchOrderNo = @"";
    }
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_FIND_ORDER parameters:subscript.dictionary];
    
    return [[[self.services.client enqueueParameter:paramters resultClass:OrderModel.class] map:mapOrderList] doError:^(NSError *error) {
        @strongify(self);
        self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"获取订单信息失败"}];
    }];
}

- (NSArray *)dataSourceWithOrderList:(NSArray *)orderList {
    self.goodIsNull = orderList.count == 0;
    if (orderList.count == 0) return @[];
    NSMutableArray *groups = [NSMutableArray array];
    for (int i = 0; i < orderList.count; i++) {
        OrderList *list = orderList[i];
        OrderGroupViewModel *group = [OrderGroupViewModel groupViewModel];
        group.headerBackColor = UIColor.whiteColor;
        group.footerBackColor = COLOR_BG;
        group.orderNo = [NSString stringWithFormat:@"订单号：%@", list.orderNo];
        group.orderStatus = [self _fetchStatus:list.status];
        group.oldId = list.orderId;
        group.headerHeight = ZGCConvertToPx(44);
        group.comfirmCommand = self.confirmCommand;
        group.footerHeight = ZGCConvertToPx(60);
        
        NSMutableArray *viewModels = [NSMutableArray array];
        for (OrderSubList *subList in list.list) {
            NSArray *mMarkArr = [subList.mRemark componentsSeparatedByString:@","];
            NSArray *remarkArr = [subList.remark componentsSeparatedByString:@","];
            
            if (self.orderType == 1 || self.orderType == 2) {
                NSArray *resultArr = [[[subList.remark componentsSeparatedByString:@"："][2] componentsSeparatedByString:@" "][0] componentsSeparatedByString:@","];
                
                OrderItemViewModel *viewModel = [OrderItemViewModel itemViewModelWithTitle:@""];
                viewModel.rowHeight = ZGCConvertToPx(110);
                viewModel.img = @"round";
                viewModel.temp1 = [NSString stringWithFormat:@"形状：%@　大小：%.2fCt", formatString(mMarkArr[0]), [(NSString *)mMarkArr[1] stringByReplacingOccurrencesOfString:@"CT" withString:@""].floatValue];
                if (self.orderType == 1) {
                    viewModel.temp2 = [NSString stringWithFormat:@"颜色：%@　净度：%@", formatString(mMarkArr[2]), formatString(mMarkArr[3])];
                    viewModel.temp3 = [NSString stringWithFormat:@"切工：%@　抛光：%@　对称：%@", formatString(resultArr[0]), formatString(resultArr[1]), formatString(resultArr[2])];
                    group.showBtn = list.status == 21 && (self.services.client.currentUser.userType == 99 || self.services.client.currentUser.userType == 3);
                } else {
                    viewModel.temp2 = [NSString stringWithFormat:@"规格：%@", formatString(mMarkArr[2])];
                    viewModel.temp3 = [NSString stringWithFormat:@"抛光：%@　对称：%@　净度：%@", formatString(resultArr[2]), formatString(resultArr[1]), formatString(mMarkArr[3])];
                    group.showBtn = list.status == 21 && self.services.client.currentUser.userType == 99;
                }
                viewModel.temp4 = [NSString stringWithFormat:@"备注：%@", formatString(list.remark)];
                [viewModels addObject:viewModel];
            } else if (self.orderType == 4) {
                OrderItemViewModel *viewModel = [OrderItemViewModel itemViewModelWithTitle:@""];
                viewModel.rowHeight = ZGCConvertToPx(110);
                viewModel.img = [self _fetchImageName:subList];
                viewModel.temp1 = [NSString stringWithFormat:@"款号：%@", formatString(remarkArr[0])];
                viewModel.temp2 = [NSString stringWithFormat:@"镶口：%.2fCt　材质：%@　手寸：%@", validateString(remarkArr[1]).floatValue, formatString(remarkArr[2]), formatString(remarkArr[3])];
                viewModel.temp3 = [NSString stringWithFormat:@"尺寸：%@　出货日期：%@", formatString(subList.mRemark), formatString(remarkArr[5])];
                viewModel.temp4 = [NSString stringWithFormat:@"刻字：%@　特殊要求：%@", formatString(remarkArr[4]), formatString(remarkArr[6])];
                [viewModels addObject:viewModel];
                if (subList.stoneType == 1 && kObjectIsNotNil(subList.orderGoodOtherOne)) {
                    OrderItemViewModel *viewModel1 = [OrderItemViewModel itemViewModelWithTitle:@""];
                    viewModel1.rowHeight = ZGCConvertToPx(110);
                    viewModel1.img = @"round";
                    OrderSubList *goodList = subList.orderGoodOtherOne.list[0];
                    NSArray *mRemarkArr = [goodList.mRemark componentsSeparatedByString:@","];
                    NSArray *resultA = [[[goodList.remark componentsSeparatedByString:@"："][2] componentsSeparatedByString:@" "][0] componentsSeparatedByString:@","];
                    viewModel1.temp1 = [NSString stringWithFormat:@"形状：%@　大小：%.2fCt", formatString(mRemarkArr[0]), [(NSString *)mRemarkArr[1] stringByReplacingOccurrencesOfString:@"CT" withString:@""].floatValue];
                    viewModel1.temp2 = [NSString stringWithFormat:@"颜色：%@　净度：%@", formatString(mRemarkArr[2]), formatString(mRemarkArr[3])];
                    viewModel1.temp3 = [NSString stringWithFormat:@"切工：%@　抛光：%@　对称：%@", formatString(resultA[0]), formatString(resultA[1]), formatString(resultA[2])];
                    viewModel1.temp4 = [NSString stringWithFormat:@"备注：%@", formatString(goodList.remark)];
                    [viewModels addObject:viewModel1];
                }
                if (subList.stoneType == 2) {
                    OrderItemViewModel *viewModel2 = [OrderItemViewModel itemViewModelWithTitle:@""];
                    viewModel2.rowHeight = ZGCConvertToPx(110);
                    viewModel2.img = @"round";
                    viewModel2.temp1 = [NSString stringWithFormat:@"送石时间：%@", formatString(mMarkArr[0])];
                    if ([mMarkArr[1] integerValue] == 1) {
                        viewModel2.temp2 = [NSString stringWithFormat:@"证书货　%@　%@", mMarkArr[2], mMarkArr[3]];
                    } else if ([mMarkArr[1] integerValue] != 1) {
                        viewModel2.temp2 = [NSString stringWithFormat:@"散货　%@", mMarkArr[4]];
                    }
                    if ([mMarkArr[5] integerValue] == 1) {
                        viewModel2.temp3 = [NSString stringWithFormat:@"是否送检：是　品验机构：%@", mMarkArr[6]];
                    } else if ([mMarkArr[1] integerValue] != 1) {
                        viewModel2.temp3 = @"是否送检：否";
                    }
                    viewModel2.temp4 = [NSString stringWithFormat:@"备注：%@", mMarkArr[7]];
                    [viewModels addObject:viewModel2];
                }
                group.showBtn = list.status == 31 && self.services.client.currentUser.userType == 99;
            } else if (self.orderType == 5) {
                OrderItemViewModel *viewModel = [OrderItemViewModel itemViewModelWithTitle:@""];
                viewModel.rowHeight = ZGCConvertToPx(209);
                viewModel.img = @"round";
                viewModel.temp1 = [NSString stringWithFormat:@"款号：%@　品类：%@", formatString(subList.json.designNo), formatString(subList.json.temp1)];
                viewModel.temp2 = [NSString stringWithFormat:@"条码号：%@　材质：%@", formatString(subList.json.barCode), formatString(subList.json.materialCn)];
                viewModel.temp3 = [NSString stringWithFormat:@"手寸：%@　总件重：%@g　净金重：%@g", formatString(subList.json.dhand), formatString(subList.json.weight), formatString(subList.json.materialWeight)];
                viewModel.temp4 = [NSString stringWithFormat:@"主石类别：%@　主石形状：%@", formatString(subList.json.temp4), formatString(subList.json.sizeShapeCn)];
                viewModel.temp5 = [NSString stringWithFormat:@"主石重：%@Ct　主石级别：%@", formatString(subList.json.size), formatString(subList.json.sizeShapeLevel)];
                viewModel.temp6 = [NSString stringWithFormat:@"副石粒数：%@　副石重：%@ct", formatString(subList.json.sideStoneNum), formatString(subList.json.sideStoneSize)];
                viewModel.temp7 = [NSString stringWithFormat:@"副石描述：%@", formatString(subList.json.sideStoneRemark)];
                viewModel.temp8 = [NSString stringWithFormat:@"证书：%@　%@", formatString(subList.json.cert), formatString(subList.json.certNo)];
                if (kStringIsNotEmpty(subList.remark))
                    viewModel.temp9 = [NSString stringWithFormat:@"刻字：%@　特殊要求：%@", formatString(remarkArr[4]), formatString(remarkArr[6])];
                group.showBtn = list.status == 81 && self.services.client.currentUser.userType == 99;
                [viewModels addObject:viewModel];
            } else if (self.orderType == 6) {
                OrderItemViewModel *viewModel = [OrderItemViewModel itemViewModelWithTitle:@""];
                viewModel.rowHeight = ZGCConvertToPx(110);
                viewModel.price = subList.price;
                viewModel.img = [self _fetchImageName:subList];
                viewModel.temp1 = [NSString stringWithFormat:@"款号：%@", formatString(subList.json.designNo)];
                NSString *temp2Str = subList.json.zsmc;
                if (kStringIsNotEmpty(subList.json.designTypeCn)) temp2Str = [temp2Str stringByAppendingFormat:@"-%@", subList.json.designTypeCn];
                if (kStringIsNotEmpty(subList.json.materialTypeCn)) temp2Str = [temp2Str stringByAppendingFormat:@"-%@", subList.json.materialTypeCn];
                temp2Str = [temp2Str stringByAppendingFormat:@"；条码：%@", formatString(subList.json.barCode)];
                viewModel.temp2 = temp2Str;
                viewModel.temp3 = [NSString stringWithFormat:@"主石：%@ct　手寸：%@#；", formatString(subList.json.size), formatString(subList.json.hand)];
                viewModel.temp4 = [NSString stringWithFormat:@"总件重：%@g　净金重：%@g；", formatString(subList.json.weight), formatString(subList.json.materialWeight)];
                [viewModels addObject:viewModel];

                group.showBtn = list.status == 31 && self.services.client.currentUser.userType == 99;
            }
        }
        group.itemViewModels = [viewModels copy];
        [groups addObject:group];
    }
    return [groups copy];
}

- (NSString *)_fetchStatus:(NSInteger)status {
    if (self.orderType == 1 || self.orderType == 2) {
        if (status == 21) return @"待确认";
        if (status == 22) return @"采购中";
        if (status == 23) return @"采购成功";
        if (status == 24) return @"待发货";
        if (status == 25) return @"已发货";
        if (status == 26) return @"订单完成";
        if (status == 27) return @"无效订单";
        if (status == 28) return @"已退订单";
    } else if (self.orderType == 4 || self.orderType == 6) {
        if (status == 31) return @"待确认";
        if (status == 32) return @"已确认";
        if (status == 33) return @"生产中";
        if (status == 34) return @"已出单";
        if (status == 35) return @"已发货";
        if (status == 36) return @"已完成";
        if (status == 37) return @"无效订单";
    } else if (self.orderType == 5) {
        if (status == 81) return @"待确认";
        if (status == 82) return @"待发货";
        if (status == 83) return @"待收货";
        if (status == 86) return @"已完成";
        if (status == 87) return @"已退货";
        if (status == 88) return @"已失效";
//    } else {
//        if (status == 0) return @"待处理";
//        if (status == 1) return @"已确认";
//        if (status == 2) return @"已付款";
//        if (status == 3) return @"已发货";
//        if (status == 4) return @"已发货";
//        if (status == 5) return @"已完成";
    }
    return @"无效订单";
}

- (NSString *)_fetchImageName:(OrderSubList *)list {
    NSString *name;
    if (kStringIsEmpty(list.pic)) return nil;
    NSArray *picArr = [list.pic componentsSeparatedByString:@","];
    if ([picArr[0] hasPrefix:@"http"]) {
        name = picArr[0];
    } else {
        if (list.sourceType == 8) {
            name = [NSString stringWithFormat:@"https://www9.wanttoseeyouagain.com/fileserver/echao_img_temp/%@", picArr[0]];
        } else {
            name = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], picArr[0]];
        }
    }
    return name;
}

@end
