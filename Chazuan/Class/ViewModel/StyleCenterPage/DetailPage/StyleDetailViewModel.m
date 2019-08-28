//
//  StyleDetailViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleDetailViewModel.h"
#import "DiamondModel.h"
#import "CycleCollectionModel.h"
#import "ObjectT.h"

@interface StyleDetailViewModel ()

@property (nonatomic, readwrite, assign) StyleType type;
@property (nonatomic, readwrite, strong) DiamondList *diamondModel;

@property (nonatomic, readwrite, strong) NSArray *loopPics;
@property (nonatomic, readwrite, strong) NSMutableArray *sizeArray;
@property (nonatomic, readwrite, strong) NSArray *caizhiArray;
@property (nonatomic, readwrite, strong) NSArray *handArray;
@property (nonatomic, readwrite, assign) NSInteger record;
@property (nonatomic, readwrite, strong) RACCommand *designCommand;

@property (nonatomic, readwrite, strong) StyleDetailModel *detailModel;
@property (nonatomic, readwrite, assign) NSInteger index;
@property (nonatomic, readwrite, strong) NSArray *popArray;

@property (nonatomic, readwrite, strong) RACSubject *picClickSub;
@property (nonatomic, readwrite, strong) RACSubject *selectSub;
@property (nonatomic, readwrite, strong) RACSubject *dateSub;

@property (nonatomic, readwrite, strong) RACCommand *homeCommand;
@property (nonatomic, readwrite, strong) RACCommand *cartCommand;
@property (nonatomic, readwrite, strong) RACCommand *orderCommand;

@property (nonatomic, readwrite, strong) RACSubject *showGoodSub;
@property (nonatomic, readwrite, strong) RACCommand *addCommond;
@property (nonatomic, readwrite, strong) RACCommand *resetCommond;

@property (nonatomic, readwrite, strong) NSArray *popDatas;
@property (nonatomic, readwrite, strong) StyleSelectModel *selectModel;

@end

@implementation StyleDetailViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.type = [self.params[ViewModelTypeKey] integerValue];
    self.diamondModel = self.params[ViewModelModelKey];
    self.sizeArray = [NSMutableArray array];
    self.record = 0;
    self.picClickSub = [RACSubject subject];
    self.selectSub = [RACSubject subject];
    self.dateSub = [RACSubject subject];
    self.showGoodSub = [RACSubject subject];
    self.loopPics = [self _getPics];
    
    self.caizhiArray = @[@"18K白",@"18K黄",@"18K红",@"PT950"];
    self.add = [[StyleAddModel alloc] init];
    self.add.tabs = self.caizhiArray[0];
    self.add.handsize = @"请选择手寸...";
    self.handArray = @[@"请选择手寸...",@"6#",@"7#",@"8#",@"9#",@"10#",@"11#",@"12#",@"13#",@"14#",@"15#",@"16#",@"17#",@"18#",@"19#",@"20#",@"21#",@"22#",@"23#",@"24#",@"25#",@"26#",@"27#",@"28#",@"29#",@"30#",@"31#",@"32#",@"33#"];
    self.handIndex = -1;
    self.sizeIndex = -1;
    if (kStringIsNotEmpty(self.diamondModel.designSeries)) {
        NSArray *arr = [self.diamondModel.designSeries componentsSeparatedByString:@","];
        if (self.diamondModel.size.floatValue > 0) {
            [self.sizeArray addObject:[NSString stringWithFormat:@"%@ct", self.diamondModel.size]];
        }
        for (int i = 0; i < arr.count; i++) {
            NSString *sizeStr = arr[i];
            if (kStringIsNotEmpty(sizeStr)) {
                if (self.diamondModel.size.floatValue != sizeStr.floatValue)
                    [self.sizeArray addObject:[NSString stringWithFormat:@"%@ct", sizeStr]];
            }
        }
        self.add.size = self.sizeArray[0];
    }
    self.add.date = @"年/月/日";
    
    @weakify(self);
    self.designCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
        @strongify(self);
        return [self _getDetail:page];
    }];
    
    [self _dataWithModelList:nil];
    if (self.type != StyleCenter && self.diamondModel.stockNum.integerValue > 0) [self.designCommand execute:@1];
    
    self.homeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services popToRootViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    self.cartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *x) {
        @strongify(self);
        return [self _addCart];
    }];
    self.orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *x) {
        @strongify(self);
        if (self.type == StyleCenter) {
            return [self _addOrder];
        }
        if (self.selectArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:self.type==StyleGoodsList?@"请先添加现货！":@"请先添加现托！"]; return [RACSignal empty];
        }
        if (self.type == StyleGoodsList) {
            [self _addGoodOrder];
            return [RACSignal empty];
        } else {
            return [self _addZTOrder];
        }
    }];
    
    self.addCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.showGoodSub sendNext:nil];
        return [RACSignal empty];
    }];
    
    self.resetCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.sizeIndex = -1;
        self.handIndex = -1;
        self.selectArray = nil;
        return [RACSignal empty];
    }];
    
    [RACObserve(self, selectArray) subscribeNext:^(NSArray *array) {
        @strongify(self);
        if (self.dataSource.count == 0) return;
        if (kObjectIsNil(self.detailModel)) return;
        self.dataSource = [self _dealGoodArray:self.dataSource];
    }];
}

- (NSArray *)_getPics {
    if (kObjectIsNil(self.diamondModel)) return @[];
    NSArray *pics;
    if (self.type == StyleZT) {
        pics = [self.diamondModel.goodsPic componentsSeparatedByString:@","];
    } else {
        pics = [self.diamondModel.pic componentsSeparatedByString:@","];
    }
    return [[[pics.rac_sequence filter:^BOOL(NSString *str) {
        return kStringIsNotEmpty(str);
    }] map:^id(NSString *picUrl) {
        CycleCollectionModel *model = [[CycleCollectionModel alloc] init];
        if ([picUrl hasPrefix:@"http"]) {
            model.imgUrl = picUrl;
        } else {
            if (self.diamondModel.source.integerValue == 8) {
                model.imgUrl = [@"http://www.zuansoft.com/fileserver/echao_img_temp/" stringByAppendingString:picUrl];
            } else {
                model.imgUrl = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], picUrl];
            }
        }
        return model;
    }] array];
}

- (void)_dataWithModelList:(StyleDetailModel *)model {
    self.detailModel = model;
    CommonGroupViewModel *picGroup = [CommonGroupViewModel groupViewModel];
    picGroup.hideDividerLine = YES;
    StylePicItemViewModel *picViewModel = [[StylePicItemViewModel alloc] initWithModel:self.loopPics];
    picViewModel.rowHeight = kScreenW;
    picViewModel.bannerClickSub = self.picClickSub;
    picGroup.itemViewModels = @[picViewModel];
    
    CommonGroupViewModel *infoGroup = [CommonGroupViewModel groupViewModel];
    infoGroup.hideDividerLine = YES;
    infoGroup.itemViewModels = [self _styleInfo];
    
    NSArray *sourceArray = @[];
    if (self.dataSource.count == 0) {
        sourceArray = @[picGroup, infoGroup];
        if (self.type != StyleZT)
            sourceArray = [sourceArray arrayByAddingObject:[self _searchGroupInfo]];
    } else {
        NSMutableArray *sArr = [NSMutableArray arrayWithArray:self.dataSource];
        [sArr replaceObjectAtIndex:1 withObject:infoGroup];
        if (kObjectIsNotNil(model)) {
            sourceArray = [self _dealGoodArray:sArr];
        }
    }
    self.dataSource = [sourceArray copy];
}

- (NSArray *)_styleInfo {
    StyleInfoItemViewModel *infoViewModel = [[StyleInfoItemViewModel alloc] init];
    if (self.type == StyleCenter) {
        infoViewModel.designNo = self.diamondModel.designNo;
        NSString *material = @"18k:";
        if (self.diamondModel.material18k.floatValue > 0)
            material = [material stringByAppendingFormat:@"%@g　PT:", self.diamondModel.material18k];
        else
            material = [material stringByAppendingString:@"-　PT:"];
        if (self.diamondModel.materialPt950.floatValue > 0)
            material = [material stringByAppendingFormat:@"%@g", self.diamondModel.materialPt950];
        else
            material = [material stringByAppendingString:@"-"];
        infoViewModel.material = material;
        infoViewModel.size = [validateString(self.diamondModel.size) stringByAppendingString:@"ct"];
        infoViewModel.designSeries = [self eachSize:self.diamondModel.designSeries];
        CGFloat seriesHeight = sizeOfString(infoViewModel.designSeries, kFont(13), kScreenW-ZGCConvertToPx(80)).height+5;
        if (seriesHeight < ZGCConvertToPx(25)) seriesHeight = ZGCConvertToPx(25);
        if (kStringIsNotEmpty(self.diamondModel.remark)) {
            infoViewModel.remark = self.diamondModel.remark;
            infoViewModel.rowHeight = ZGCConvertToPx(113) + seriesHeight;
        } else {
            infoViewModel.rowHeight = ZGCConvertToPx(113);
        }
    } else {
        NSString *attrStr;
        if (self.type == StyleZT) {
            infoViewModel.name = self.diamondModel.goodsName;
            infoViewModel.rowHeight = ZGCConvertToPx(63);
            attrStr = @"库存";
        } else {
            infoViewModel.rowHeight = ZGCConvertToPx(38);
            attrStr = @"现货";
        }
        infoViewModel.designNo = self.diamondModel.designNo;
        if (self.diamondModel.stockNum.integerValue > 0) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[attrStr stringByAppendingFormat:@" %@ 件", @(self.record).stringValue]];
            [str addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#FF9000") range:NSMakeRange(3, @(self.record).stringValue.length)];
            infoViewModel.record = str;
        }
    }
    return @[infoViewModel];
}

- (NSString *)eachSize:(NSString *)series {
    NSString *name = @"";
    if (kStringIsNotEmpty(series)) {
        NSArray *arr = [series componentsSeparatedByString:@","];
        for (int i = 0; i < arr.count; i++) {
            NSString *item = arr[i];
            if (kStringIsNotEmpty(item)) {
                if (i == arr.count - 1) {
                    name = [name stringByAppendingFormat:@"%@", item];
                } else {
                    name = [name stringByAppendingFormat:@"%@、", item];
                }
            }
        }
        return name;
    } else return @"-";
}

- (CommonGroupViewModel *)_searchGroupInfo {
    CommonGroupViewModel *searchGroup = [CommonGroupViewModel groupViewModel];
    searchGroup.hideDividerLine = YES;
    searchGroup.footerHeight = ZGCConvertToPx(30);
    searchGroup.footerBackColor = UIColor.whiteColor;
    StyleSelectItemViewModel *sizeViewModel = [StyleSelectItemViewModel itemViewModelWithTitle:@"主石大小"];
    RACChannelTo(sizeViewModel, name) = RACChannelTo(self.add, size);
    sizeViewModel.rowHeight = ZGCConvertToPx(94);
    sizeViewModel.selectBlock = ^(UITableViewCell * cell, CGPoint point) {
        self.index = 0;
        self.popArray = [self.sizeArray copy];
        [self.selectSub sendNext:[RACTuple tupleWithObjects:self.add.size, cell, NSStringFromCGPoint(point), nil]];
    };
    StyleSelectItemViewModel *caizhiViewModel = [StyleSelectItemViewModel itemViewModelWithTitle:@"材质"];
    RACChannelTo(caizhiViewModel, name) = RACChannelTo(self.add, tabs);
    caizhiViewModel.rowHeight = ZGCConvertToPx(94);
    caizhiViewModel.selectBlock = ^(UITableViewCell * cell, CGPoint point) {
        self.index = 1;
        self.popArray = self.caizhiArray;
        [self.selectSub sendNext:[RACTuple tupleWithObjects:self.add.tabs, cell, NSStringFromCGPoint(point), nil]];
    };
    StyleSelectItemViewModel *handViewModel = [StyleSelectItemViewModel itemViewModelWithTitle:@"手寸"];
    RACChannelTo(handViewModel, name) = RACChannelTo(self.add, handsize);
    handViewModel.rowHeight = ZGCConvertToPx(94);
    handViewModel.selectBlock = ^(UITableViewCell * cell, CGPoint point) {
        self.index = 2;
        self.popArray = self.handArray;
        [self.selectSub sendNext:[RACTuple tupleWithObjects:self.add.handsize, cell, NSStringFromCGPoint(point), nil]];
    };
    StyleSelectItemViewModel *dateViewModel = [StyleSelectItemViewModel itemViewModelWithTitle:@"出货日期"];
    RACChannelTo(dateViewModel, name) = RACChannelTo(self.add, date);
    dateViewModel.rowHeight = ZGCConvertToPx(94);
    dateViewModel.selectBlock = ^(UITableViewCell *cell, CGPoint point) {
        [self.dateSub sendNext:nil];
    };
    StyleTextItemViewModel *chicunViewModel = [StyleTextItemViewModel itemViewModelWithTitle:@"尺寸"];
    chicunViewModel.rowHeight = ZGCConvertToPx(94);
    RAC(self.add, mRemark) = RACObserve(chicunViewModel, name);
    StyleTextItemViewModel *keziViewModel = [StyleTextItemViewModel itemViewModelWithTitle:@"刻字"];
    keziViewModel.placeholder = @"为了戒指美观度，建议6个字符以内";
    keziViewModel.rowHeight = ZGCConvertToPx(94);
    RAC(self.add, write) = RACObserve(keziViewModel, name);
    StyleTextItemViewModel *markViewModel = [StyleTextItemViewModel itemViewModelWithTitle:@"特殊要求"];
    markViewModel.placeholder = @"不超过200字符";
    markViewModel.rowHeight = ZGCConvertToPx(110);
    RAC(self.add, remark) = RACObserve(markViewModel, name);
    
    if (self.type == StyleCenter) {
        if (self.sizeArray.count > 0) {
            searchGroup.itemViewModels = @[sizeViewModel, caizhiViewModel, handViewModel, dateViewModel, chicunViewModel, keziViewModel, markViewModel];
        } else {
            searchGroup.itemViewModels = @[caizhiViewModel, handViewModel, dateViewModel, chicunViewModel, keziViewModel, markViewModel];
        }
    } else {
        searchGroup.itemViewModels = @[keziViewModel, markViewModel];
    }
    return searchGroup;
}

- (NSArray *)_dealGoodArray:(NSArray *)sourceArray {
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:sourceArray];
    if (self.diamondModel.stockNum.integerValue > 0 && kObjectIsNotNil(self.detailModel)) {
        GoodInfoGroupViewModel *group = [GoodInfoGroupViewModel groupViewModel];
        group.hideDividerLine = YES;
        if (self.selectArray.count != 0) {
            group.headerHeight = ZGCConvertToPx(30);
            group.footerHeight = ZGCConvertToPx(114);
            group.headerBackColor = kHexColor(@"#F5F6FA");
            group.footerBackColor = kHexColor(@"#F5F6FA");
            group.addCommond = self.addCommond;
            group.resetCommond = self.resetCommond;
            
            NSString *count = @(self.selectArray.count).stringValue;
            NSString *totalPrice = [self _totalPrice];
            NSString *notice = [NSString stringWithFormat:@"已添加 %@ 件，合计 %@ 元", count, totalPrice];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:notice];
            [attrStr addAttribute:NSFontAttributeName value:kFont(13) range:NSMakeRange(0, notice.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#1C2B36") range:NSMakeRange(0, notice.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#F85359") range:NSMakeRange(4, count.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#F85359") range:NSMakeRange(count.length+10, totalPrice.length)];
            group.attrHeader = attrStr;
        }
        group.itemViewModels = [self _getGoodWithPrice:self.selectArray.count!=0];
        if (self.type == StyleGoodsList && sourceArray.count == 3) {
            [dataArray insertObject:group atIndex:2];
        } else if (self.type == StyleZT && sourceArray.count == 2) {
            [dataArray addObject:group];
        } else if (self.type != StyleCenter) {
            [dataArray replaceObjectAtIndex:2 withObject:group];
        }
    }
    return [dataArray copy];
}

- (NSArray *)_getGoodWithPrice:(BOOL)showPrice {
    NSMutableArray *goodArray = [NSMutableArray array];
    if (showPrice) {
        for (StyleDetailList *list in self.selectArray) {
            [goodArray addObject:[self _goodInfo:list showPrice:showPrice]];
        }
    } else {
        if (self.detailModel.list.count > 0 && kObjectIsNotNil([self.detailModel.list.firstObject detailId])) {
            StyleDetailList *list = self.detailModel.list.firstObject;
            [goodArray addObject:[self _goodInfo:list showPrice:showPrice]];
        }
    }
    return [goodArray copy];
}

- (GoodInfoItemViewModel *)_goodInfo:(StyleDetailList *)list showPrice:(BOOL)showPrice {
    GoodInfoItemViewModel *goodViewModel = [GoodInfoItemViewModel itemViewModelWithTitle:@""];
    @weakify(self);
    goodViewModel.operation = ^{
        @strongify(self);
        if (showPrice) {
            NSMutableArray *selectArray = [NSMutableArray arrayWithArray:self.selectArray];
            [selectArray removeObject:list];
            self.selectArray = [selectArray copy];
        } else {
            [self.showGoodSub sendNext:nil];
        }
    };
    if (self.type == StyleGoodsList) {
        goodViewModel.rowHeight = ZGCConvertToPx(202);
        
        NSString *temp1 = self.diamondModel.designNo;
        if (kStringIsNotEmpty(list.temp1)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.temp1];
        if (kStringIsNotEmpty(list.materialCn)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.materialCn];
        temp1 = [temp1 stringByAppendingFormat:@"；总件重：%@", validateString(list.weight)];
        if (list.weight.floatValue > 0) temp1 = [temp1 stringByAppendingString:@"g"];
        goodViewModel.temp1 = [temp1 stringByAppendingString:@"；"];
        
        NSString *temp3 = [NSString stringWithFormat:@"主石大小：%@", formatString(list.size)];
        if (list.size.floatValue > 0) temp3 = [temp3 stringByAppendingString:@"ct"];
        temp3 = [temp3 stringByAppendingFormat:@"； 手寸：%@；", formatString(list.dHand)];
        goodViewModel.temp3 = temp3;
        
        goodViewModel.temp4 = [NSString stringWithFormat:@"主石类别：%@；主石形状：%@；", formatString(list.temp4), formatString(list.sizeShapeCn)];
        goodViewModel.temp5 = [NSString stringWithFormat:@"主石级别：%@；", formatString(list.sizeShapeLevel)];
        goodViewModel.temp6 = [NSString stringWithFormat:@"副石粒数：%@；副石重：%@ct；", formatString(list.sideStoneNum), formatString(list.sideStoneSize)];
        goodViewModel.temp7 = [NSString stringWithFormat:@"副石描述：%@；", formatString(list.sideStoneRemark)];
        goodViewModel.temp8 = [NSString stringWithFormat:@"证书：%@　%@；", formatString(list.cert), validateString(list.certNo)];
    } else {
        goodViewModel.rowHeight = ZGCConvertToPx(90);
        
        NSString *temp1 = self.diamondModel.zsmc;
        if (kStringIsNotEmpty(list.designTypeCn)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.designTypeCn];
        if (kStringIsNotEmpty(list.materialTypeCn)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.materialTypeCn];
        temp1 = [temp1 stringByAppendingFormat:@"；总件重：%@", validateString(list.weight)];
        if (list.weight.floatValue > 0) temp1 = [temp1 stringByAppendingString:@"g"];
        goodViewModel.temp1 = [temp1 stringByAppendingString:@"；"];
        
        NSString *temp3 = [NSString stringWithFormat:@"主石：%@", formatString(list.size)];
        if (list.size.floatValue > 0) temp3 = [temp3 stringByAppendingString:@"ct"];
        temp3 = [temp3 stringByAppendingFormat:@"； 手寸：%@#；", formatString(list.hand)];
        goodViewModel.temp3 = temp3;
    }
    
    NSString *temp2 = [NSString stringWithFormat:@"条码：%@；净金重：%@", formatString(list.barCode), formatString(list.materialWeight)];
    if (list.materialWeight.floatValue > 0) temp2 = [temp2 stringByAppendingString:@"g"];
    goodViewModel.temp2 = [temp2 stringByAppendingString:@"；"];
    
    goodViewModel.price = showPrice?[NSString stringWithFormat:@"￥%.2f",list.price.floatValue]:@"";
    goodViewModel.btnTitle = showPrice?@"删除":(self.type==StyleGoodsList?@"查看现货":@"查看更多");
    return goodViewModel;
}

- (NSString *)_totalPrice {
    CGFloat price = 0.f;
    for (StyleDetailList *list in self.selectArray) {
        price += list.price.floatValue;
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

- (RACSignal *)_getDetail:(NSNumber *)page {
    NSString *path;
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"d_design_no"] = self.diamondModel.designNo;
    subscript[@"currentPage"] = page;
    subscript[@"pageSize"] = @"10";
    if (self.type == StyleGoodsList) {
        subscript[@"status_type"] = @"1";
        path = POST_STYLE_GOODSLIST_LIST;
    } else {
        path = POST_STYLE_ZT_LIST;
    }
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:path parameters:subscript.dictionary];
    @weakify(self);
    return [[[self.services.client enqueueParameter:paramters resultClass:StyleDetailModel.class] doNext:^(HTTPResponse *response) {
        @strongify(self);
        StyleDetailModel *model = response.parsedResult;
        self.record = model.page.totalRecord;
        if (model.appCheckCode) {
            [self.services.client loginAtOtherPlace];
        } else {
            self.popDatas = model.list;
            [self _dataWithModelList:model];
        }
    }] doError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取现货信息失败"];
    }];
}

- (RACSignal *)_addCart {
    @weakify(self);
    [MBProgressHUD zgc_show];
    if (self.type == StyleCenter) {
        NSInteger designType = self.diamondModel.designType.integerValue;
        if (designType == 1 || designType == 2 || designType == 34) {
            if (kStringIsEmpty(self.add.handsize) || [self.add.handsize isEqualToString:@"请选择手寸..."]) {
                [MBProgressHUD zgc_hideHUD];
                [SVProgressHUD showInfoWithStatus:@"请选择手寸"];
                return [RACSignal empty];
            }
        }
        if (kStringIsEmpty(self.add.date) || [self.add.date isEqualToString:@"年/月/日"]) {
            [MBProgressHUD zgc_hideHUD];
            [SVProgressHUD showInfoWithStatus:@"请选择出货日期"];
            return [RACSignal empty];
        }
        NSString *size = [self.add.size substringWithRange:NSMakeRange(0, self.add.size.length-2)];
        NSString *date = [self.add.date stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSString *remark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,1", self.diamondModel.designNo,size?:@"",self.add.tabs,self.add.handsize,self.add.write?:@"",date,self.add.remark?:@""];
        self.diamondModel.shopcar = remark;
        if (kStringIsNotEmpty(self.add.mRemark)) self.diamondModel.mRemark = self.add.mRemark;
        
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"www_type"] = @2;
        subscript[@"good_type"] = @5;
        subscript[@"good_id"] = self.diamondModel.listId;
        subscript[@"txt"] = [self.diamondModel.toJSONString stringByURLEncode];
        
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_STYLE_ADDCART parameters:subscript.dictionary];
        return [[[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] doNext:^(HTTPResponse *response) {
            @strongify(self);
            [MBProgressHUD zgc_hideHUD];
            ObjectT *obj = response.parsedResult;
            if (obj.appCheckCode) {
                [self.services.client loginAtOtherPlace];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
            }
        }] doError:^(NSError *error) {
            [MBProgressHUD zgc_hideHUD];
            [SVProgressHUD showErrorWithStatus:@"加入购物车失败"];
        }];
    } else {
        if (self.selectArray.count == 0) {
            [MBProgressHUD zgc_hideHUD];
            [SVProgressHUD showInfoWithStatus:@"请先添加现货！"];
            return [RACSignal empty];
        }
        //1.队列-串行
        /*
         参数1：队列名称
         参数2：队列属性 DISPATCH_QUEUE_SERIAL 串行，等价于NULL
         */
        dispatch_queue_t  queue = dispatch_queue_create("request_queue",NULL);
        //2.同步执行任务
        [self.selectArray enumerateObjectsUsingBlock:^(StyleDetailList *list, NSUInteger idx, BOOL *stop) {
            __block BOOL blockStop = stop;
            dispatch_sync(queue, ^{
                NSString *remark = [NSString stringWithFormat:@"%@,,,,%@,,%@,1,,%@,%@,%@", self.diamondModel.designNo,self.add.write?:@"",self.add.remark?:@"",list.barCode?:@"",list.weight,list.materialWeight];
                list.shopcar = remark;
                if (kStringIsNotEmpty(self.add.mRemark)) list.mRemark = self.add.mRemark;
                
                KeyedSubscript *subscript = [KeyedSubscript subscript];
                subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
                subscript[@"www_type"] = @2;
                subscript[@"good_type"] = @8;
                subscript[@"good_id"] = list.detailId;
                subscript[@"txt"] = [list.toJSONString stringByURLEncode];
                URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_STYLE_ADDCART parameters:subscript.dictionary];
                
                @weakify(self);
                [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                    @strongify(self);
                    ObjectT *obj = response.parsedResult;
                    if (obj.appCheckCode) {
                        [MBProgressHUD zgc_hideHUD];
                        [self.services.client loginAtOtherPlace];
                    } else if (idx==self.selectArray.count-1) {
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
        return [RACSignal empty];
    }
}

- (RACSignal *)_addOrder {
    [MBProgressHUD zgc_show];
    NSInteger designType = self.diamondModel.designType.integerValue;
    if (designType == 1 || designType == 2 || designType == 34) {
        if (kStringIsEmpty(self.add.handsize) || [self.add.handsize isEqualToString:@"请选择手寸..."]) {
            [MBProgressHUD zgc_hideHUD];
            [SVProgressHUD showInfoWithStatus:@"请选择手寸"];
            return [RACSignal empty];
        }
    }
    if (kStringIsEmpty(self.add.date) || [self.add.date isEqualToString:@"年/月/日"]) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showInfoWithStatus:@"请选择出货日期"];
        return [RACSignal empty];
    }
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"mobile"] = [self.services.client.currentUser.list[0] mobile];
    subscript[@"status"] = @31;
    subscript[@"good_type"] = @5;
    
    NSString *size = [self.add.size substringWithRange:NSMakeRange(0, self.add.size.length-2)];
    NSString *date = [self.add.date stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *remark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,1", self.diamondModel.designNo,size?:@"",self.add.tabs.stringByURLEncode,self.add.handsize,(self.add.write?:@"").stringByURLEncode,date,(self.add.remark?:@"").stringByURLEncode];
    
    NSString *temp = @"[{\"good_type\":5,\"num\":1,\"isown\":false,\"good_id\":";
    temp = [temp stringByAppendingString:self.diamondModel.listId.stringValue];
    temp = [temp stringByAppendingFormat:@",\"remark\":\"%@\"", remark];
    if (self.diamondModel.source.integerValue == 8)
        temp = [temp stringByAppendingString:@",\"source_type\":8"];
    if (kStringIsNotEmpty(self.add.mRemark))
        temp = [temp stringByAppendingFormat:@",\"m_remark\":\"%@\"", self.add.mRemark.stringByURLEncode];
    temp = [temp stringByAppendingString:@"}]"];
    
    subscript[@"temp"] = temp;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ORDER parameters:subscript.dictionary];
    return [[[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] doNext:^(HTTPResponse *response) {
        [MBProgressHUD zgc_hideHUD];
        ObjectT *obj = response.parsedResult;
        if (obj.appCheckCode) {
            [self.services.client loginAtOtherPlace];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"下单成功"];
        }
    }] doError:^(NSError *error) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:@"下单失败"];
    }];
}

- (void)_addGoodOrder {
    dispatch_queue_t  queue = dispatch_queue_create("request_queue",NULL);
    //2.同步执行任务
    [MBProgressHUD zgc_show];
    [self.selectArray enumerateObjectsUsingBlock:^(StyleDetailList *list, NSUInteger idx, BOOL *stop) {
        __block BOOL blockStop = stop;
        dispatch_sync(queue, ^{
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
            subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
            subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            subscript[@"good_type"] = @8;
            subscript[@"good_id"] = list.detailId;
            
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_GOOD_CHECK parameters:subscript.dictionary];
            @weakify(self);
            [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                ObjectT *obj = response.parsedResult;
                if (obj.status == 101) {
                    if (idx == self.selectArray.count-1) {
                        KeyedSubscript *subscript = [KeyedSubscript subscript];
                        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
                        subscript[@"mobile"] = [self.services.client.currentUser.list[0] mobile];
                        subscript[@"status"] = @81;
                        subscript[@"good_type"] = @8;
                        
                        NSString *temp = @"[";
                        for (int i = 0; i < self.selectArray.count; i++) {
                            StyleDetailList *detail = self.selectArray[i];
                            NSString *remark = [NSString stringWithFormat:@"%@,,,,%@,,%@,1,,%@,%@,%@", self.diamondModel.designNo,(self.add.write?:@"").stringByURLEncode,(self.add.remark?:@"").stringByURLEncode,detail.barCode?:@"",detail.weight,detail.materialWeight];
                            
                            NSString *userExtend = [NSString stringWithFormat:@"{\"good_type\":8,\"num\":1,\"isown\":false,\"good_id\":%@,\"remark\":\"%@\"", detail.detailId, remark];
                            if (kStringIsNotEmpty(self.add.mRemark))
                                userExtend = [userExtend stringByAppendingFormat:@",\"m_remark\":%@}",self.add.mRemark.stringByURLEncode];
                            else
                                userExtend = [userExtend stringByAppendingString:@"}"];
                            temp = [temp stringByAppendingString:userExtend];
                            if (i < self.selectArray.count-1)
                                temp = [temp stringByAppendingString:@","];
                        }
                        temp = [temp stringByAppendingString:@"]"];
                        subscript[@"temp"] = temp;
                        
                        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ORDER parameters:subscript.dictionary];
                        @weakify(self);
                        [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
                            @strongify(self);
                            [MBProgressHUD zgc_hideHUD];
                            ObjectT *obj = response.parsedResult;
                            if (obj.appCheckCode) {
                                [self.services.client loginAtOtherPlace];
                            } else {
                                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                                self.selectArray = nil;
                                [self.designCommand execute:@1];
                            }
                        } error:^(NSError *error) {
                            [MBProgressHUD zgc_hideHUD];
                            [SVProgressHUD showErrorWithStatus:@"下单失败"];
                        }];
                    }
                } else {
                    @strongify(self);
                    [MBProgressHUD zgc_hideHUD];
                    NSMutableArray *mutableList = [NSMutableArray arrayWithArray:self.selectArray];
                    [mutableList removeObject:list];
                    self.selectArray = [mutableList copy];
                    [SVProgressHUD showErrorWithStatus:@"选中现货中有不可售现货，已从选中删除！请重新下单！"];
                    blockStop = YES;
                }
            }];
        });
    }];
}

- (RACSignal *)_addZTOrder {
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"mobile"] = [self.services.client.currentUser.list[0] mobile];
    subscript[@"status"] = @31;
    subscript[@"good_type"] = @12;
    
    NSString *temp = @"[";
    for (int i = 0; i < self.selectArray.count; i++) {
        StyleDetailList *detail = self.selectArray[i];
        temp = [temp stringByAppendingFormat:@"{\"good_type\":12,\"num\":1,\"isown\":false,\"barcode\":%@}", detail.barCode];
        if (i < self.selectArray.count-1)
            temp = [temp stringByAppendingString:@","];
    }
    temp = [temp stringByAppendingString:@"]"];
    subscript[@"temp"] = temp;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ORDER parameters:subscript.dictionary];
    return [[[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] doNext:^(HTTPResponse *response) {
        ObjectT *obj = response.parsedResult;
        if (obj.appCheckCode) {
            [self.services.client loginAtOtherPlace];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            self.selectArray = nil;
            [self.designCommand execute:@1];
        }
    }] doError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"下单失败"];
    }];
}

- (void)searchList:(NSString *)sizeMin max:(NSString *)sizeMax hand:(NSString *)hand {
    NSString *path;
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"d_design_no"] = self.diamondModel.designNo;
    subscript[@"currentPage"] = @1;
    subscript[@"pageSize"] = @10;
    if (self.type == StyleGoodsList) {
        subscript[@"status_type"] = @"1";
        path = POST_STYLE_GOODSLIST_LIST;
    } else {
        path = POST_STYLE_ZT_LIST;
    }
    if (kStringIsNotEmpty(sizeMin)) {
        subscript[@"d_size_min"] = sizeMin;
    }
    if (kObjectIsNotNil(sizeMax)) {
        subscript[@"d_size_max"] = sizeMax;
    }
    if (kObjectIsNotNil(hand)) {
        if (self.type == StyleZT) subscript[@"hand"] = hand;
        else subscript[@"d_hand"] = hand;
    }
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:path parameters:subscript.dictionary];
    @weakify(self);
    [[self.services.client enqueueParameter:paramters resultClass:StyleDetailModel.class] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        StyleDetailModel *model = response.parsedResult;
        self.popDatas = model.list;
    } error:^(NSError *error) {
        @strongify(self);
        self.popDatas = nil;
    }];
}

@end
