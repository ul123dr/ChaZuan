//
//  StyleCenterViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleCenterViewModel.h"
#import "ShopCartViewModel.h"
#import "TypeModel.h"

@interface StyleCenterViewModel ()
// 商品列表
@property (nonatomic, readwrite, strong) NSArray *diamondList;

@property (nonatomic, readwrite, strong) NSArray *sideTitle;
@property (nonatomic, readwrite, strong) NSMutableArray *sideArray;

@property (nonatomic, readwrite, strong) RACCommand *designCommand;
@property (nonatomic, readwrite, strong) RACCommand *shopcartCommand;

@property (nonatomic, readwrite, strong) RACCommand *sideResetCommand;
@property (nonatomic, readwrite, strong) RACCommand *sideConfirmCommand;

// 网络请求错误
@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation StyleCenterViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldPullUpToLoadMore = YES;
    self.orderBy = @"0";
    if ([self.title isEqualToString:@"在线板房"]) {
        self.type = StyleCenter;
    } else if ([self.title isEqualToString:@"成品现货"]) {
        self.type = StyleGoodsList;
    } else {
        self.type = StyleZT;
    }
    self.priceBtnTitle = @"时间段";
    @weakify(self);
    /// 商品列表
    RAC(self, diamondList) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    /// 数据源
    RAC(self, dataSource) = [[RACObserve(self, diamondList) ignore:nil] map:^(NSArray * diamondList) {
        @strongify(self);
        return [self dataSourceWithDiamondList:diamondList];
    }];
    
    self.sideModel = [[SiftSelectModel alloc] init];
    self.select = [[SiftSelectModel alloc] init];
    self.sideArray = [NSMutableArray array];
    self.sideSelectArray = [NSMutableArray array];
    [self _initSideModel];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(DiamondList *list) {
        if ([list isKindOfClass:NSIndexPath.class]) return [RACSignal empty];
        if (kStringIsEmpty(list.designNo)) {
            [SVProgressHUD showInfoWithStatus:@"查询出错，未找到款号"];
        } else {
            NSString *title;
            if (self.type == StyleCenter) title = @"款式详情";
            else if (self.type == StyleGoodsList) title = @"现货详情";
            else title = @"找托详情";
            StyleDetailViewModel *viewModel = [[StyleDetailViewModel alloc] initWithServices:self.services params:@{ViewModelModelKey:list,ViewModelTitleKey:title,ViewModelTypeKey:@(self.type)}];
            [self.services pushViewModel:viewModel animated:YES];
        }
        return [RACSignal empty];
    }];
    
    self.designCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.type != StyleZT) {
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
            subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
            subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_STYLE_DESIGNTYPE parameters:subscript.dictionary];
            @weakify(self);
            [[self.services.client enqueueParameter:paramters resultClass:TypeModel.class] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                TypeModel *model = response.parsedResult;
                if (model.appCheckCode) {
                    [self.services.client loginAtOtherPlace];
                } else {
                    NSMutableArray *cateList = [NSMutableArray array];
                    for (TypeList *list in model.list1) {
                        [cateList addObject:[SiftList listWithId:list.listId name:list.designName]];
                    }
                    if (cateList.count > 0) self.sideModel.categoryList = [self.sideModel.categoryList arrayByAddingObjectsFromArray:cateList];
                    NSMutableArray *descList = [NSMutableArray array];
                    for (TypeList *list in model.list2) {
                        [descList addObject:[SiftList listWithId:list.listId name:list.designName]];
                    }
                    if (descList.count > 0) self.sideModel.describeList = [self.sideModel.describeList arrayByAddingObjectsFromArray:descList];
                    NSMutableArray *styleList = [NSMutableArray array];
                    for (TypeList *list in model.list3) {
                        [styleList addObject:[SiftList listWithId:list.listId name:list.designName]];
                    }
                    if (styleList.count > 0) self.sideModel.styleList = [self.sideModel.styleList arrayByAddingObjectsFromArray:styleList];
                    NSMutableArray *gemsList = [NSMutableArray array];
                    for (TypeList *list in model.list4) {
                        [gemsList addObject:[SiftList listWithId:list.listId name:list.designName]];
                    }
                    if (gemsList.count > 0) self.sideModel.gemsList = [self.sideModel.gemsList arrayByAddingObjectsFromArray:gemsList];
                    NSMutableArray *recList = [NSMutableArray array];
                    for (TypeList *list in model.list5) {
                        [recList addObject:[SiftList listWithId:list.listId name:list.designName]];
                    }
                    if (recList.count > 0) self.sideModel.recommendList = [self.sideModel.recommendList arrayByAddingObjectsFromArray:recList];
                    
                    self.sideTitle = @[@"款号",@"品类",@"爪型",@"镶口方式",@"镶口",@"宝石",@"专区"];
                    [self.sideArray addObjectsFromArray:@[@[],
                                                          self.sideModel.categoryList,
                                                          self.sideModel.describeList,
                                                          self.sideModel.styleList,
                                                          self.sideModel.scoopList,
                                                          self.sideModel.gemsList,
                                                          self.sideModel.recommendList]];
                    [self.sideSelectArray addObjectsFromArray:@[@[],@[],@[],@[],@[],@[],@[]]];
                    [self.requestRemoteDataCommand execute:@1];
                }
            } error:^(NSError *error) {
                @strongify(self);
                self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"获取分类失败"}];
                [self.services popViewModelAnimated:YES];
            }];
        } else {
            [self.requestRemoteDataCommand execute:@1];
        }
        return [RACSignal empty];
    }];
    
    self.shopcartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        ShopCartViewModel *viewModel = [[ShopCartViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"我的购物车"}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.sideResetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.sideSelectArray removeAllObjects];
        self.select = [[SiftSelectModel alloc] init];
        for (int i = 0; i < self.sideArray.count; i++) {
            [self.sideSelectArray addObject:@[]];
        }
        return [RACSignal empty];
    }];
    
    self.sideConfirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.requestRemoteDataCommand execute:@1];
        return [RACSignal empty];
    }];
}

- (void)_initSideModel {
    self.sideModel.scoopList = @[[SiftList listWithId:@1 name:@"10分以下"],
                                 [SiftList listWithId:@2 name:@"10-19分"],
                                 [SiftList listWithId:@3 name:@"20-29分"],
                                 [SiftList listWithId:@4 name:@"30-49分"],
                                 [SiftList listWithId:@5 name:@"50-69分"],
                                 [SiftList listWithId:@6 name:@"70-99分"],
                                 [SiftList listWithId:@7 name:@"1克拉以上"]];
    if (self.type == StyleZT) {
        self.sideModel.categoryList = @[[SiftList listWithId:@1 name:@"女戒"],
                                        [SiftList listWithId:@2 name:@"男戒"],
                                        [SiftList listWithId:@3 name:@"吊坠"]];
        self.sideModel.describeList = @[[SiftList listWithId:@1 name:@"2-3叶包"],
                                        [SiftList listWithId:@2 name:@"3-4爪"],
                                        [SiftList listWithId:@3 name:@"4-6叶包"],
                                        [SiftList listWithId:@4 name:@"5-6爪"],
                                        [SiftList listWithId:@5 name:@"包夹其他"],
                                        [SiftList listWithId:@6 name:@"爪镶"],
                                        [SiftList listWithId:@7 name:@"爪镶其他"],
                                        [SiftList listWithId:@8 name:@"群镶"]];
        self.sideTitle = @[@"款号",@"品类",@"爪型",@"镶口"];
        [self.sideArray addObjectsFromArray:@[@[],
                                              self.sideModel.categoryList,
                                              self.sideModel.describeList,
                                              self.sideModel.scoopList]];
        [self.sideSelectArray addObjectsFromArray:@[@[],@[],@[],@[]]];
        [self.requestRemoteDataCommand execute:@1];
    } else {
        //                self.sideModel.category8List = @[[SiftList listWithId:@2 name:@"女戒"],[SiftList listWithId:@4 name:@"男戒"],[SiftList listWithId:@5 name:@"耳饰"],[SiftList listWithId:@3 name:@"对戒"],[SiftList listWithId:@6 name:@"腕饰"],[SiftList listWithId:@7 name:@"颈饰"]];
        //                self.sideModel.describe8List = @[[SiftList listWithNameId:@"a" name:@"四爪"],[SiftList listWithNameId:@"b" name:@"五爪"],[SiftList listWithNameId:@"c" name:@"六爪"],[SiftList listWithNameId:@"d" name:@"牛头款"]];
        //                self.sideModel.style8List = @[[SiftList listWithNameId:@"a" name:@"爪镶"],[SiftList listWithNameId:@"b" name:@"包镶"],[SiftList listWithNameId:@"c" name:@"迫镶"],[SiftList listWithNameId:@"d" name:@"无边镶"]];
        //                self.sideModel.scoop8List = @[[SiftList listWithId:@1 name:@"10分以下"],[SiftList listWithId:@2 name:@"10-19分"],[SiftList listWithId:@3 name:@"120-29分"],[SiftList listWithId:@4 name:@"30-49分"],[SiftList listWithId:@5 name:@"50-69分"],[SiftList listWithId:@6 name:@"70-99分"],[SiftList listWithId:@7 name:@"1克拉以上"]];
        //                self.sideModel.recommend8List = @[[SiftList listWithId:@1 name:@"时尚新品"],[SiftList listWithId:@2 name:@"爆款推荐"],[SiftList listWithId:@3 name:@"异型钻"],[SiftList listWithId:@4 name:@"经典款式"],[SiftList listWithId:@5 name:@"主副款"],[SiftList listWithId:@6 name:@"单钻款"]];
        self.sideModel.typeList = @[[SiftList listWithId:@1 name:@"品牌典藏"],
                                    [SiftList listWithId:@8 name:@"急速出货"]];
        self.sideModel.describeList = @[[SiftList listWithId:@1 name:@"四爪"],
                                        [SiftList listWithId:@2 name:@"六爪"],
                                        [SiftList listWithId:@3 name:@"水滴爪"],
                                        [SiftList listWithId:@4 name:@"圆爪"],
                                        [SiftList listWithId:@5 name:@"心形爪"],
                                        [SiftList listWithId:@6 name:@"牛头款"],
                                        [SiftList listWithId:@7 name:@"天使之吻"]];
        self.sideModel.styleList = @[[SiftList listWithId:@1 name:@"爪镶"],
                                     [SiftList listWithId:@2 name:@"包镶"],
                                     [SiftList listWithId:@3 name:@"迫镶"],
                                     [SiftList listWithId:@4 name:@"钉镶"],
                                     [SiftList listWithId:@5 name:@"无边镶"],
                                     [SiftList listWithId:@6 name:@"微镶"],
                                     [SiftList listWithId:@7 name:@"意大利镶"],
                                     [SiftList listWithId:@8 name:@"埋镶"],
                                     [SiftList listWithId:@9 name:@"组合镶"]];
        self.sideModel.gemsList = @[[SiftList listWithId:@1 name:@"钻石"],
                                    [SiftList listWithId:@2 name:@"红宝石"],
                                    [SiftList listWithId:@3 name:@"祖母绿"],
                                    [SiftList listWithId:@4 name:@"蓝宝石"],
                                    [SiftList listWithId:@5 name:@"碧玺"],
                                    [SiftList listWithId:@6 name:@"芙蓉石"]];
        self.sideModel.recommendList = @[[SiftList listWithId:@1 name:@"时尚新品"],
                                         [SiftList listWithId:@2 name:@"爆款推荐"]];
        if ([[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.ajuzb.com"]) {
            self.sideModel.categoryList = @[[SiftList listWithId:@1 name:@"女戒"],
                                            [SiftList listWithId:@2 name:@"男戒"],
                                            [SiftList listWithId:@34 name:@"对戒"]];
        } else {
            self.sideModel.categoryList = @[[SiftList listWithId:@1 name:@"女戒"],
                                            [SiftList listWithId:@2 name:@"男戒"],
                                            [SiftList listWithId:@3 name:@"吊坠"],
                                            [SiftList listWithId:@4 name:@"手链"],
                                            [SiftList listWithId:@5 name:@"耳环"],
                                            [SiftList listWithId:@6 name:@"耳钉"],
                                            [SiftList listWithId:@13 name:@"链牌"],
                                            [SiftList listWithId:@14 name:@"手镯"],
                                            [SiftList listWithId:@34 name:@"对戒"]];
        }
    }
}

#pragma mark - override
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    @weakify(self);
    NSArray * (^mapList)(HTTPResponse *) = ^(HTTPResponse *response) {
        @strongify(self);
        DiamondModel *model = response.parsedResult;
        NSArray *diamondList = model.list;
        if (page == 1) { // 下拉刷新
            self.page = 1;
        } else { // 上拉刷新
            diamondList = @[(self.diamondList ?: @[]).rac_sequence, diamondList.rac_sequence].rac_sequence.flatten.array;
        }
        return diamondList;
    };
    
    NSString *path;
    if (self.type == StyleZT) path = POST_ONLINE_ZT;
    else path = POST_ONLINE_LIST;

    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"currentPage"] = @(page).stringValue;
    subscript[@"pageSize"] = @(self.perPage).stringValue;
    subscript[@"order_sx"] = @"0";
    subscript[@"order_tj"] = self.orderBy;
    if (self.type == StyleGoodsList) subscript[@"is_have_stock"] = @"1";
    else subscript[@"isShow"] = @"1";
    
    if (self.type != StyleZT) {
        if (self.select.categoryList.count != 0) {
            SiftList *list = self.select.categoryList[0];
            subscript[@"d_design_type"] = list.listId;
        }
        if (self.select.describeList.count != 0) {
            SiftList *list = self.select.describeList[0];
            subscript[@"d_type_z"] = list.listId;
        }
    } else {
        if (self.select.categoryList.count != 0) {
            SiftList *list = self.select.categoryList[0];
            subscript[@"d_design_type_cn"] = [list.name stringByURLEncode];
        }
        if (self.select.describeList.count != 0) {
            SiftList *list = self.select.describeList[0];
            subscript[@"d_type_z_cn"] = [list.name stringByURLEncode];
        }
    }
    if (self.select.styleList.count != 0) {
        SiftList *list = self.select.styleList[0];
        subscript[@"d_type_xq"] = list.listId;
    }
    if (self.select.scoopList.count != 0) {
        SiftList *list = self.select.scoopList[0];
        switch (list.listId.integerValue) {
            case 1: {
                subscript[@"d_size_min"] = @"0";
                subscript[@"d_size_max"] = @"0.1";
            }
                break;
            case 2: {
                subscript[@"d_size_min"] = @"0.1";
                subscript[@"d_size_max"] = @"0.19";
            }
                break;
            case 3: {
                subscript[@"d_size_min"] = @"0.2";
                subscript[@"d_size_max"] = @"0.29";
            }
                break;
            case 4: {
                subscript[@"d_size_min"] = @"0.3";
                subscript[@"d_size_max"] = @"0.49";
            }
                break;
            case 5: {
                subscript[@"d_size_min"] = @"0.5";
                subscript[@"d_size_max"] = @"0.69";
            }
                break;
            case 6: {
                subscript[@"d_size_min"] = @"0.7";
                subscript[@"d_size_max"] = @"0.99";
            }
                break;
            case 7: {
                subscript[@"d_size_min"] = @"1";
            }
                break;
            default:
                break;
        }
    }
    if (self.select.gemsList.count != 0) {
        SiftList *list = self.select.gemsList[0];
        subscript[@"d_type_stone"] = list.listId;
    }
    if (self.select.recommendList.count != 0) {
        SiftList *list = self.select.recommendList[0];
        subscript[@"d_area"] = list.listId;
    }
    if (kStringIsNotEmpty(self.designNo)) {
        subscript[@"d_design_no"] = self.designNo;
    }
    if (self.type == StyleGoodsList) {
        if (kStringIsNotEmpty(self.priceMin)) {
            subscript[@"d_price_min"] = self.priceMin;
        }
        if (kStringIsNotEmpty(self.priceMax)) {
            subscript[@"d_price_max"] = self.priceMax;
        }
        if (kStringIsNotEmpty(self.barCode)) {
            subscript[@"bar_code"] = self.barCode;
        }
    }
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:path parameters:subscript.dictionary];
    
    return [[[self.services.client enqueueParameter:paramters resultClass:DiamondModel.class] map:mapList] doError:^(NSError *error) {
        @strongify(self);
        self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"系统繁忙，请稍后再试！"}];
    }];
}

- (NSArray *)dataSourceWithDiamondList:(NSArray *)diamondList {
    self.goodIsNull = diamondList.count == 0;
    if (diamondList.count == 0) {
        return @[];
    }
    NSMutableArray *viewModels = [NSMutableArray array];

    NSMutableArray *goods = [NSMutableArray array];
    NSUInteger index = 0;
    for (int i = 0; i < diamondList.count; i++) {
        DiamondList *list = diamondList[i];
        [goods addObject:list];
        index++;
        if (i == diamondList.count - 1 || index >= 2) {
            index = 0;
            StyleItemViewModel *viewModel = [[StyleItemViewModel alloc] initWithModel:[goods copy]];
            viewModel.type = self.type;
            if (self.type == StyleCenter) viewModel.rowHeight = kScreenW/2.0+ZGCConvertToPx(69);
            else if (self.type == StyleGoodsList) viewModel.rowHeight = kScreenW/2.0+ZGCConvertToPx(48);
            else viewModel.rowHeight = kScreenW/2.0+ZGCConvertToPx(90);
            viewModel.didSelectCommand = self.didSelectCommand;
            [viewModels addObject:viewModel];
            [goods removeAllObjects];
        }
    }
    self.shouldEndRefreshingWithNoMoreData = (diamondList.count % self.perPage)?NO:YES;
    
    return viewModels ?: @[];
}

@end
