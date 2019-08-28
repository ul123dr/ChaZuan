//
//  ShopCartViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/19.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShopCartViewModel.h"

@interface ShopCartViewModel ()

// 商品列表
@property (nonatomic, readwrite, strong) NSArray *cartList;
@property (nonatomic, readwrite, strong) DollarRate *rate;

@property (nonatomic, readwrite, strong) RACCommand *balanceCommand;
@property (nonatomic, readwrite, strong) RACCommand *selectAllCommand;
@property (nonatomic, readwrite, strong) RACCommand *deleteCommand;

@property (nonatomic, readwrite, strong) RACSubject *reloadTableSub;

@property (nonatomic, readwrite, strong) RACCommand *requestRateCommand;

// 网络请求错误
@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation ShopCartViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldPullUpToLoadMore = YES;
    self.balanceTuple = [RACTuple tupleWithObjects:@(0), @(0), nil];
    self.reloadTableSub = [RACSubject subject];
    
    @weakify(self);
    self.requestRateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        URLParameters *parameters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_METAL_BRAND parameters:subscript.dictionary];
        return [[[self.services.client enqueueParameter:parameters resultClass:DollarRate.class] doNext:^(HTTPResponse *response) {
            @strongify(self);
            self.rate = response.parsedResult;
            [self.requestRemoteDataCommand execute:@(self.page)];
        }] doError:^(NSError *error) {
            @strongify(self);
            [SVProgressHUD showErrorWithStatus:@"获取汇率失败"];
            [self.services popViewModelAnimated:YES];
        }];
    }];
    
    /// 商品列表
    RAC(self, cartList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    /// 数据源
    RAC(self, dataSource) = [[RACObserve(self, cartList) ignore:nil] map:^(NSArray * cartList) {
        @strongify(self);
        return [self dataSourceWithCartList:cartList];
    }];
    
    self.selectAllCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *x) {
        @strongify(self);
        float allPrices = 0;
        NSInteger count = 0;
        for (int i = 0; i < self.dataSource.count; i++) {
            CartItemViewModel *viewModel = self.dataSource[i];
            [self.selectArray replaceObjectAtIndex:i withObject:x];
            viewModel.selected = x.boolValue;
            if (x.boolValue)  {
                allPrices += viewModel.price.floatValue;
                count++;
            }
        }
        self.balanceTuple = [RACTuple tupleWithObjects:@(allPrices), @(count), nil];
        return [RACSignal empty];
    }];
    
    self.deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        @weakify(self);
        Alert(@"确定删除选中吗？", @"取消", @"确定", ^(BOOL action) {
            @strongify(self);
            if (action) {
                for (int i = 0; i < self.dataSource.count; i++) {
                    CartItemViewModel *viewModel = self.dataSource[i];
                    if (viewModel.selected) {
                        ShopCartList *list = self.cartList[i];
                        KeyedSubscript *subscript = [KeyedSubscript subscript];
                        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
                        subscript[@"id"] = list.listId.stringValue;
                        URLParameters *parameters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_SHOPCART_DELETE parameters:subscript.dictionary];
                        [[self.services.client enqueueParameter:parameters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                            [MBProgressHUD zgc_hideHUD];
                            NSMutableArray *allItems = [NSMutableArray arrayWithArray:self.cartList];
                            [allItems removeObjectsInArray:@[list]];
                            self.cartList = [allItems copy];
                            self.balanceTuple = [RACTuple tupleWithObjects:@(0), @(0), nil];
                        } error:^(NSError *error) {
                            [MBProgressHUD zgc_hideHUD];
                        }];
                    }
                }
            }
        });
        return [RACSignal empty];
    }];
    
    self.balanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        @weakify(self);
        InputAlert(^(BOOL action, NSString *inputStr) {
            @strongify(self);
            if (action) {
                NSMutableArray *selectArr = [NSMutableArray array];
                for (int i = 0; i < self.dataSource.count; i++) {
                    CartItemViewModel *viewModel = self.dataSource[i];
                    if (viewModel.selected) [selectArr addObject:self.cartList[i]];
                }
                
                __block CGFloat price = 0;
                dispatch_queue_t  queue = dispatch_queue_create("request_queue",NULL);
                [selectArr enumerateObjectsUsingBlock:^(ShopCartList *list, NSUInteger idx, BOOL *stop) {
                    __block BOOL blockStop = stop;
                    dispatch_sync(queue, ^{
                        price += list.cartTxt.price.floatValue;
                        RACTuple *tuple = [self _createParameters:inputStr model:list];
                        KeyedSubscript *checkSubscript = tuple.first;
                        KeyedSubscript *orderSubscript = tuple.second;
                        
                        if (selectArr.count > 1) {
                            orderSubscript[@"send_message_type"] = @0;
                            if (idx == selectArr.count-1) {
                                orderSubscript[@"send_message_type"] = @1;
                                orderSubscript[@"send_message_price"] = [NSString stringWithFormat:@"%.2f", price];
                                orderSubscript[@"send_message_num"] = @(selectArr.count);
                            }
                        }
                        
                        @weakify(self);
                        if (list.goodType == 0 || list.goodType == 4 || list.goodType == 9) {
                            URLParameters *parameters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_GOOD_FIND parameters:checkSubscript.dictionary];
                            [[self.services.client enqueueParameter:parameters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                                @strongify(self);
                                ObjectT *obj = response.parsedResult;
                                if (obj.status == 101) {
                                    [self _sureOrder:orderSubscript stop:stop atIndex:idx selectArr:selectArr];
                                } else {
                                    blockStop = YES;
                                    self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"该货品不可售！"}];
                                }
                            } error:^(NSError *error) {
                                @strongify(self);
                                blockStop = YES;
                                self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"状态检测失败"}];
                            }];
                        } else if (list.goodType == 5) {
                            [self _sureOrder:orderSubscript stop:stop atIndex:idx selectArr:selectArr];
                        } else if (list.goodType == 8) {
                            URLParameters *parameters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_GOOD_CHECK parameters:checkSubscript.dictionary];
                            [[self.services.client enqueueParameter:parameters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                                @strongify(self);
                                ObjectT *obj = response.parsedResult;
                                if (obj.status == 101) {
                                    [self _sureOrder:orderSubscript stop:stop atIndex:idx selectArr:selectArr];
                                } else {
                                    blockStop = YES;
                                    self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"该货品不可售！"}];
                                }
                            } error:^(NSError *error) {
                                @strongify(self);
                                blockStop = YES;
                                self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"状态检测失败"}];
                            }];
                        }
                    });
                }];
            }
        });
        return [RACSignal empty];
    }];
}

- (RACTuple *)_createParameters:(NSString *)remark model:(ShopCartList *)list {
    // 商品检查
    KeyedSubscript *checkSub = [KeyedSubscript subscript];
    checkSub[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    checkSub[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    checkSub[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    checkSub[@"id"] = list.listId.stringValue;
    // 下单
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"mobile"] = [self.services.client.currentUser.list[0] mobile];
    subscript[@"good_type"] = @(list.goodType);
    
    if (list.goodType == 0 || list.goodType == 4 || list.goodType == 9) {
        subscript[@"status"] = @21;
        subscript[@"temp"] = [NSString stringWithFormat:@"[{\"good_type\":%@,\"num\":1,\"isown\":false,\"good_id\":%@,\"cloudGoods_id\":%@}]", @(list.goodType), list.cartTxt.txtId, list.listId];
        if (remark.length > 0) subscript[@"remark"] = remark.stringByURLEncode;
    } else {
        NSString *temp = [NSString stringWithFormat:@"[{\"good_type\":%@,\"num\":1,\"isown\":false,\"good_id\":%@,\"cloudGoods_id\":%@,\"remark\":\"%@\"", @(list.goodType), list.cartTxt.txtId, list.listId, list.cartTxt.shopcar.stringByURLEncode];
        if (list.goodType == 5) {
            subscript[@"status"] = @31;
            if (list.cartTxt.source==8) temp = [temp stringByAppendingString:@",\"source_type\":8"];
            if (list.cartTxt.remark.length>0) temp = [temp stringByAppendingFormat:@",\"m_remark\":%@", list.cartTxt.remark];
        } else {
            checkSub[@"good_id"] = list.cartTxt.txtId;
            checkSub[@"good_type"] = @8;
            subscript[@"status"] = @81;
        }
        temp = [temp stringByAppendingString:@"}]"];
        subscript[@"temp"] = temp;
        if (remark.length > 0) subscript[@"remark"] = [NSString stringWithFormat:@",,,,%@", remark.stringByURLEncode];
    }
    return [RACTuple tupleWithObjects:checkSub, subscript, nil];
}

- (void)_sureOrder:(KeyedSubscript *)subscript stop:(BOOL *)stop atIndex:(NSUInteger)index selectArr:(NSArray *)selectArr {
    __block BOOL blockStop = stop;
    URLParameters *orderParameters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ORDER parameters:subscript.dictionary];
    @weakify(self);
    [[self.services.client enqueueParameter:orderParameters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        ObjectT *obj = response.parsedResult;
        if (obj.appCheckCode) {
            blockStop = YES;
            [self.services.client loginAtOtherPlace];
        } else {
            if (index == selectArr.count-1) {
                blockStop = YES;
                NSMutableArray *allItems = [NSMutableArray arrayWithArray:self.cartList];
                [allItems removeObjectsInArray:selectArr];
                self.cartList = [allItems copy];
                [SVProgressHUD showSuccessWithStatus:@"订单已生成"];
            }
        }
    } error:^(NSError *error) {
        @strongify(self);
        blockStop = YES;
        self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"生成意向订单失败"}];
    }];
}

#pragma mark - 辅助功能
- (void)getAllPrices {
    float allPrices = 0;
    __block NSInteger selectGoods = 0;
    
    NSArray *priceArr = [[self.dataSource.rac_sequence filter:^BOOL(CartItemViewModel *viewModel) {
        return viewModel.selected;
    }] map:^id(CartItemViewModel *viewModel) {
        selectGoods++;
        return viewModel.price;
    }].array;
    
    for (NSNumber *price in priceArr) {
        allPrices += price.floatValue;
    }
    self.balanceTuple = [RACTuple tupleWithObjects:@(allPrices), @(selectGoods), nil];
}

#pragma mark - override
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    @weakify(self);
    NSArray * (^mapCartList)(HTTPResponse *) = ^(HTTPResponse *response) {
        ShopCartModel *model = response.parsedResult;
        NSArray *cartList = model.list;
        if (page == 1) { // 下拉刷新
        } else { // 上拉刷新
            cartList = @[(self.cartList ?: @[]).rac_sequence, cartList.rac_sequence].rac_sequence.flatten.array;
        }
        return cartList;
    };
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"currentPage"] = @(page).stringValue;
    subscript[@"pageSize"] = @(self.perPage).stringValue;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_SHOP_CART parameters:subscript.dictionary];
    
    return [[[self.services.client enqueueParameter:paramters resultClass:ShopCartModel.class] map:mapCartList] doError:^(NSError *error) {
        @strongify(self);
        self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"获取购物车信息失败"}];
    }];
}

- (NSArray *)dataSourceWithCartList:(NSArray *)cartList {
    self.goodIsNull = cartList.count == 0;
    if (cartList.count == 0) {
        self.balanceTuple = [RACTuple tupleWithObjects:@(0), @(0), nil];
        return nil;
    }
    self.selectArray = [NSMutableArray array];
    NSMutableArray *viewModels = [NSMutableArray array];
    for (int i = 0; i < cartList.count; i++) {
        ShopCartList *list = cartList[i];
        if (list.goodType != 0 && list.goodType != 4 && list.goodType !=5 && list.goodType !=8 && list.goodType != 9) continue;
        CartItemViewModel *viewModel = [CartItemViewModel itemViewModelWithTitle:@""];
        viewModel.rowHeight = list.goodType<8?ZGCConvertToPx(164):ZGCConvertToPx(269);
        viewModel.img = (list.goodType==0||list.goodType==4)?@"round":[self _fetchImageName:list];
        if (list.goodType == 9) viewModel.img = @"emerald_icon";
        viewModel.canSale = list.status == 101;
        viewModel.type = list.goodType;
        viewModel.status = list.status;
        if (list.goodType == 0 || list.goodType == 4) {
            if (list.goodType == 0) viewModel.price = list.price;
            else viewModel.price = @(self.rate.dollarRate.floatValue*list.cartTxt.rate.floatValue);
            viewModel.temp1 = [NSString stringWithFormat:@"形状：%@　大小：%@Ct", formatString(list.cartTxt.shape), formatString(list.cartTxt.size)];
            viewModel.temp2 = [NSString stringWithFormat:@"颜色：%@　净度：%@", formatString(list.cartTxt.color), formatString(list.cartTxt.clarity)];
            if (list.goodType == 0)
                viewModel.temp3 = [NSString stringWithFormat:@"切工：%@　抛光：%@　对称：%@", formatString(list.cartTxt.cut), formatString(list.cartTxt.polish), formatString(list.cartTxt.sym)];
            else
                viewModel.temp3 = [NSString stringWithFormat:@"抛光：%@　对称：%@", formatString(list.cartTxt.polish), formatString(list.cartTxt.sym)];
            viewModel.temp4 = [NSString stringWithFormat:@"证书：%@ %@", formatString(list.cartTxt.cert), [SingleInstance boolForKey:CertShowKey]?(list.cartTxt.certNo?:@""):@""];
        } else if (list.goodType == 5) {
            viewModel.price = @0;
            viewModel.temp1 = [NSString stringWithFormat:@"款号：%@", formatString(list.cartTxt.styleNo)];
            viewModel.temp2 = [NSString stringWithFormat:@"镶口：%@Ct　材质：%@　手寸：%@", formatString(list.cartTxt.size), formatString(list.cartTxt.caizhi), formatString(list.cartTxt.hand)];
            viewModel.temp3 = [NSString stringWithFormat:@"尺寸：%@　预出货时间：%@", formatString(list.cartTxt.remark), formatString(list.cartTxt.date)];
            viewModel.temp4 = [NSString stringWithFormat:@"刻字：%@　特殊要求：%@", formatString(list.cartTxt.kezi), formatString(list.cartTxt.mark)];
        } else if (list.goodType == 8) {
            viewModel.price = list.cartTxt.price;
            viewModel.temp1 = [NSString stringWithFormat:@"款号：%@　品类：%@", formatString(list.cartTxt.designNo), formatString(list.cartTxt.temp1)];
            viewModel.temp2 = [NSString stringWithFormat:@"条码号：%@　材质：%@", formatString(list.cartTxt.barCode), formatString(list.cartTxt.material)];
            viewModel.temp3 = [NSString stringWithFormat:@"手寸：%@　总件重：%@g　净金重：%@g", formatString(list.cartTxt.dHand), formatString(list.cartTxt.weight), formatString(list.cartTxt.materialWeight)];
            viewModel.temp4 = [NSString stringWithFormat:@"主石类别：%@　主石形状：%@", formatString(list.cartTxt.temp4), formatString(list.cartTxt.sizeShape)];
            viewModel.temp5 = [NSString stringWithFormat:@"主石重：%@Ct　主石级别：%@", formatString(list.cartTxt.size), formatString(list.cartTxt.sizeShapeLevel)];
            viewModel.temp6 = [NSString stringWithFormat:@"副石粒数：%@　副石重：%.2fCt", formatString(list.cartTxt.stoneNum), list.cartTxt.stoneSize];
            viewModel.temp7 = [NSString stringWithFormat:@"副石描述：%@", formatString(list.cartTxt.stoneRemark)];
            viewModel.temp8 = [NSString stringWithFormat:@"证书：%@ %@", formatString(list.cartTxt.cert), list.cartTxt.certNo?:@""];
            viewModel.temp9 = [NSString stringWithFormat:@"刻字：%@　特殊要求：%@", formatString(list.cartTxt.kezi), formatString(list.cartTxt.mark)];
        } else if (list.goodType == 9) {
            viewModel.price = list.price;
            viewModel.temp1 = [NSString stringWithFormat:@"形状：%@　大小：%@ct", formatString(list.cartTxt.shape), formatString(list.cartTxt.size)];
            viewModel.temp2 = [NSString stringWithFormat:@"颜色(GRS)：%@", formatString(list.cartTxt.color1)];
            viewModel.temp3 = [NSString stringWithFormat:@"颜色(GRS)：%@", formatString(list.cartTxt.color2)];
            viewModel.temp4 = [NSString stringWithFormat:@"切工：%@　净度：%@", formatString(list.cartTxt.cut), formatString(list.cartTxt.ceo)];
        }
        
        [viewModels addObject:viewModel];
        __block CartItemViewModel *blockViewModel = viewModel;
        @weakify(self);
        viewModel.selectOperation = ^(NSInteger selected) {
            @strongify(self);
            [self _fetchSelect:blockViewModel select:selected];
        };
        [self.selectArray addObject:@(NO)];
    }
    return viewModels ?: @[] ;
}

- (void)_fetchSelect:(CartItemViewModel *)viewModel select:(BOOL)selected {
    NSInteger index = [self.dataSource indexOfObject:viewModel];
    [self.selectArray replaceObjectAtIndex:index withObject:@(selected)];
    viewModel.selected = selected;
    [self getAllPrices];
}

- (NSString *)_fetchImageName:(ShopCartList *)list {
    NSString *name;
    NSArray *picArr = [list.cartTxt.pic componentsSeparatedByString:@","];
    if (list.cartTxt.source == 8) {
        name = [NSString stringWithFormat:@"https://www9.wanttoseeyouagain.com/fileserver/echao_img_temp/%@", picArr[0]];
    } else {
        name = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], picArr[0]];
    }
    return name;
}

@end
