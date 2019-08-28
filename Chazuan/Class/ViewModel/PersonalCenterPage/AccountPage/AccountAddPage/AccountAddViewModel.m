//
//  AccountAddViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountAddViewModel.h"
#import "AccountModel.h"
#import "AccountRoleModel.h"
#import "LoginStatus.h"
#import "PublicKey.h"
#import "RSAEncryptTool.h"

@interface AccountAddViewModel ()

@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, strong) NSArray *userList;
@property (nonatomic, readwrite, strong) NSMutableArray *userSelectList;
@property (nonatomic, readwrite, strong) NSMutableArray *sellerList;
@property (nonatomic, readwrite, strong) NSMutableArray *sellerSelectList;
@property (nonatomic, readwrite, strong) NSMutableArray *buyerList;
@property (nonatomic, readwrite, strong) NSMutableArray *buySelectList;
@property (nonatomic, readwrite, copy) NSString *levelDisc;
@property (nonatomic, readwrite, strong) NSArray *vipSelectList;
@property (nonatomic, readwrite, strong) NSArray *userTypeSelectList;
@property (nonatomic, readwrite, strong) NSArray *roleList;
@property (nonatomic, readwrite, strong) NSMutableArray *roleSelectList;

@property (nonatomic, readwrite, strong) Member *loginData;
@property (nonatomic, readwrite, copy) NSString *discBel1;
@property (nonatomic, readwrite, copy) NSString *discBel2;
@property (nonatomic, readwrite, copy) NSString *discBel3;
@property (nonatomic, readwrite, copy) NSString *discBel4;
@property (nonatomic, readwrite, copy) NSString *discBel5;

@property (nonatomic, readwrite, assign) CGFloat roleHeight;
@property (nonatomic, readwrite, assign) CGFloat rightHeight;
@property (nonatomic, readwrite, assign) CGFloat rateDiscHeight;
@property (nonatomic, readwrite, assign) CGFloat rateLzHeight;
@property (nonatomic, readwrite, assign) CGFloat rateLzColorHeight;
@property (nonatomic, readwrite, assign) CGFloat rateDoubleHeight;
@property (nonatomic, readwrite, assign) CGFloat rateDoubleZtHeight;
@property (nonatomic, readwrite, assign) CGFloat disc1Height;
@property (nonatomic, readwrite, assign) CGFloat disc2Height;
@property (nonatomic, readwrite, assign) CGFloat disc3Height;
@property (nonatomic, readwrite, assign) CGFloat disc4Height;
@property (nonatomic, readwrite, assign) CGFloat disc5Height;

@property (nonatomic, readwrite, strong) RACSubject *selectSub;

@property (nonatomic, readwrite, strong) RACCommand *resetCommand;
@property (nonatomic, readwrite, strong) RACCommand *addCommand;

@end

@implementation AccountAddViewModel

- (void)initialize {
    self.style = UITableViewStyleGrouped;
    self.shouldMultiSections = YES;
    self.type = [self.params[ViewModelTypeKey] integerValue];
    self.buyerList = [NSMutableArray array];
    self.buySelectList = [NSMutableArray arrayWithObject:[SiftList listWithId:@0 name:@"请选择..."]];
    self.sellerList = [NSMutableArray array];
    self.sellerSelectList = [NSMutableArray arrayWithObject:[SiftList listWithId:@0 name:@"请选择..."]];
    self.roleSelectList = [NSMutableArray arrayWithObject:[SiftList listWithId:@0 name:@"请选择..."]];
    self.userSelectList = [NSMutableArray arrayWithObject:[SiftList listWithId:@0 name:@"请选择..."]];
    self.selectSub = [RACSubject subject];
    self.vipSelectList = @[[SiftList listWithId:@0 name:@"请选择..."],
                           [SiftList listWithId:@1 name:@"普通VIP"],
                           [SiftList listWithId:@2 name:@"白银VIP"],
                           [SiftList listWithId:@3 name:@"白金VIP"],
                           [SiftList listWithId:@4 name:@"钻石VIP"]];
    self.userTypeSelectList = @[[SiftList listWithId:@0 name:@"请选择..."],
                                [SiftList listWithId:@2 name:@"采购专员"],
                                [SiftList listWithId:@3 name:@"销售专员"],
                                [SiftList listWithId:@4 name:@"物流专员"],
                                [SiftList listWithId:@5 name:@"管理层"],
                                [SiftList listWithId:@6 name:@"财务专员"],
                                [SiftList listWithId:@13 name:@"内部销售"]];
    self.reloadSub = [RACSubject subject];
    self.roleHeight = ZGCConvertToPx(50);
    self.rateDiscHeight = 0;
    self.rateLzHeight = 0;
    self.rateLzColorHeight = 0;
    self.rateDoubleHeight = 0;
    self.rateDoubleZtHeight = 0;
    self.disc1Height = 0;
    self.disc2Height = 0;
    self.disc3Height = 0;
    self.disc4Height = 0;
    self.disc5Height = 0;
    
    self.addUser = [self _createAddUser];
    
    @weakify(self);
    [RACObserve(self.addUser, fromList) subscribeNext:^(NSNumber *userId) {
        for (Member *mem in self.userList) {
            if (mem.memberId.integerValue != userId.integerValue) continue;
            Member *list = mem.list[0];
            NSArray *powerArr = [list.diamondShowPower componentsSeparatedByString:@","];
            self.addUser.buyer = formatWithString(list.buyerId, @"").numberValue;
            self.addUser.level = mem.userLevel;
            self.addUser.userType = mem.userType;
            self.addUser.areaShow = powerArr.count>0?[powerArr[0] boolValue]:NO;
            self.addUser.certshow = powerArr.count>1?[powerArr[1] boolValue]:NO;
            self.addUser.detailshow = powerArr.count>2?[powerArr[2] boolValue]:NO;
            self.addUser.rapshow = powerArr.count>3?[powerArr[3] boolValue]:NO;
            self.addUser.rapBuyshow = powerArr.count>4?[powerArr[4] boolValue]:NO;
            self.addUser.discshow = powerArr.count>5?[powerArr[5] boolValue]:NO;
            self.addUser.mbgshow = powerArr.count>6?[powerArr[6] boolValue]:NO;
            self.addUser.blackshow = powerArr.count>7?[powerArr[7] boolValue]:NO;
            self.addUser.fancyRapshow = powerArr.count>8?[powerArr[8] boolValue]:NO;
            self.addUser.imgShow = powerArr.count>9?[powerArr[9] boolValue]:NO;
            self.addUser.dollarShow = powerArr.count>10?[powerArr[10] boolValue]:NO;
            self.addUser.realGoodsNumberShow = powerArr.count>11?[powerArr[11] boolValue]:NO;
            self.addUser.sizeShow = powerArr.count>12?[powerArr[12] boolValue]:NO;
            self.addUser.isEyeCleanShow = powerArr.count>13?[powerArr[13] boolValue]:NO;
            self.addUser.isDTShow = powerArr.count>14?[powerArr[14] boolValue]:NO;
            self.addUser.disc = @(mem.rateDiscount.floatValue*100).stringValue;
            self.addUser.white = mem.rateDoubleLz.stringValue;
            self.addUser.fancy = mem.rateDoubleLzColor.stringValue;
            self.addUser.rateDouble = formatWithString(mem.rateDouble, @"1");
            self.addUser.rateDoubleZt = formatWithString(mem.rateDoubleZt, @"1");
            self.addUser.isExport = list.isExport.boolValue;
            self.addUser.status = mem.status;
            self.addUser.seller = formatWithString(list.salesmenId, @"").numberValue;
            break;
        }
    }];
    
    [RACObserve(self, loginData) subscribeNext:^(Member *m) {
        @strongify(self);
        self.rateDiscHeight = 0;
        self.rateLzHeight = 0;
        self.rateLzColorHeight = 0;
        self.rateDoubleHeight = 0;
        self.rateDoubleZtHeight = 0;
        self.disc1Height = 0;
        self.disc2Height = 0;
        self.disc3Height = 0;
        self.disc4Height = 0;
        self.disc5Height = 0;
        if (kObjectIsNil(m)) {
            self.discBel1 = @"0";
            self.discBel2 = @"0";
            self.discBel3 = @"0";
            self.discBel4 = @"0";
            self.discBel5 = @"0";
        } else {
            NSString *bel1 = @"", *bel2 = @"0", *bel3 = @"0", *bel4 = @"0", *bel5 = @"0";
            if (self.addUser.seller && self.addUser.seller != 0 && m.userType == 3) {
                CGFloat total1 = formatWithString(self.addUser.disc, @"0").floatValue+m.rateDiscount.floatValue;
                if (kStringIsNotEmpty(self.levelDisc)) {
                    NSArray *discArr = [self.levelDisc componentsSeparatedByString:@","];
                    for (NSString *discValue in discArr) {
                        if (kStringIsNotEmpty(discValue)) {
                            NSString *left = [discValue componentsSeparatedByString:@"="][0];
                            NSString *right = [[discValue componentsSeparatedByString:@"="][1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            CGFloat num = [right stringByReplacingOccurrencesOfString:@"%" withString:@""].floatValue + total1;
                            bel1 = [bel1 stringByAppendingFormat:@"%@=%@%%,", left, @(num)];
                        }
                    }
                } else {
                    bel1 = @(total1).stringValue;
                }
                
                CGFloat total2 = formatWithString(self.addUser.white, @"0").floatValue * m.rateDoubleLz.floatValue;
                bel2 = [NSString stringWithFormat:@"%.3f", total2];
                
                CGFloat total3 = formatWithString(self.addUser.fancy, @"0").floatValue * m.rateDoubleLzColor.floatValue;
                bel3 = [NSString stringWithFormat:@"%.3f", total3];
                
                CGFloat total4 = formatWithString(self.addUser.rateDouble, @"0").floatValue * m.rateDouble.floatValue;
                bel4 = [NSString stringWithFormat:@"%.3f", total4];
                
                CGFloat total5 = formatWithString(self.addUser.rateDoubleZt, @"0").floatValue * m.rateDoubleZt.floatValue;
                bel5 = [NSString stringWithFormat:@"%.3f", total5];
                
                self.rateDiscHeight = ZGCConvertToPx(50);
                self.rateLzHeight = ZGCConvertToPx(50);
                self.rateLzColorHeight = ZGCConvertToPx(50);
                self.rateDoubleHeight = ZGCConvertToPx(50);
                self.rateDoubleZtHeight = ZGCConvertToPx(50);
                self.disc1Height = sizeOfString(bel1, kFont(15), kScreenW-ZGCConvertToPx(180)).height+ZGCConvertToPx(33);
                self.disc2Height = ZGCConvertToPx(50);
                self.disc3Height = ZGCConvertToPx(50);
                self.disc4Height = ZGCConvertToPx(50);
                self.disc5Height = ZGCConvertToPx(50);
            }
            self.discBel1 = formatWithString(bel1, @"0");
            self.discBel2 = bel2;
            self.discBel3 = bel3;
            self.discBel4 = bel4;
            self.discBel5 = bel5;
        }
        [self.reloadSub sendNext:nil];
    }];
    
    self.resetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
        @strongify(self);
        [self _resetAddUser];
        [self.reloadSub sendNext:nil];
        return [RACSignal empty];
    }];
    
    self.addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSString *mobile = [@"136189" stringByAppendingFormat:@"%.5d", (int)(arc4random()%100000)];
        if ([[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.jydiam.com"]) {
            @weakify(self);
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            subscript[@"validateName"] = @"mobile";
            subscript[@"param"] = mobile;
            
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_VILADE_MOBILE, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:subscript.dictionary];
            [[self.services.client enqueueParameter:paramters resultClass:LoginStatus.class] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                LoginStatus *status = response.parsedResult;
                if (status.code == 0) {
                    self.addUser.mobile = mobile;
                    [self _validateNameAndMobile];
                } else {
                    [self.addCommand execute:nil];
                }
            }];
        } else {
            [self _validateNameAndMobile];
        }
        return [RACSignal empty];
    }];
    
    [self _dealDataSource];
    
    [MBProgressHUD zgc_show];
    if (self.type == 1) {
        [self _getSeller:0];
    } else {
        [self _getRole];
    }
}

- (void)_getSeller:(NSInteger)type {
    @weakify(self);
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"status"] = @"";
    subscript[@"currentPage"] = @0;
    subscript[@"pageSize"] = @999;
    subscript[@"user_type_big"] = @2;
    
    if (type != 0) {
        subscript[@"user_type_big"] = @(type);
        NSInteger userLevel = [HTTPService sharedInstance].currentUser.userType;
        if (userLevel == 3) {
            subscript[@"salesmen_id"] = [HTTPService sharedInstance].currentUser.userId;
        }
        if (userLevel == 2) {
            subscript[@"buyer_id"] = [HTTPService sharedInstance].currentUser.userId;
        }
    }
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_USER_LIST parameters:subscript.dictionary];
    [[self.services.client enqueueParameter:paramters resultClass:AccountModel.class] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        AccountModel *model = response.parsedResult;
        if (model.appCheckCode) {
            [MBProgressHUD zgc_hideHUD];
            return [self.services.client loginAtOtherPlace];
        }
        for (Member *list in model.list) {
            Member *subList = list.list[0];
            if (type == 0) {
                if (list.userType == 2) {
                    [self.buyerList addObject:list];
                    [self.buySelectList addObject:[SiftList listWithId:list.memberId name:subList.realname]];
                } else if (list.userType == 3 || list.userType == 13) {
                    [self.sellerList addObject:list];
                    [self.sellerSelectList addObject:[SiftList listWithId:list.memberId name:subList.realname]];
                }
            } else {
                [self.userSelectList addObject:[SiftList listWithId:list.memberId name:subList.realname]];
            }
        }
        if (type != 0) {
            [MBProgressHUD zgc_hideHUD];
            self.userList = model.list;
        } else {
            [self _getRole];
        }
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:type==0?@"获取销售员信息失败":@"获取会员信息失败"];
    }];
}

- (void)_getRole {
    @weakify(self);
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"currentPage"] = @0;
    subscript[@"pageSize"] = @999;
    subscript[@"type"] = @(self.type);
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ROLE parameters:subscript.dictionary];
    [[self.services.client enqueueParameter:paramters resultClass:AccountRoleModel.class] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        AccountRoleModel *model = response.parsedResult;
        if (model.appCheckCode) {
            [MBProgressHUD zgc_hideHUD];
            return [self.services.client loginAtOtherPlace];
        }
        for (Role *role in model.list) {
            [self.roleSelectList addObject:[SiftList listWithId:role.roleId name:role.roleName]];
        }
        self.roleList = model.list;
        [self _getSeller:self.type];
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:@"获取角色信息失败"];
    }];
}

- (void)_dealDataSource {
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = ZGCConvertToPx(10);
    group1.itemViewModels = [self _dealGroupOne];
    
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.footerHeight = ZGCConvertToPx(10);
    group2.itemViewModels = [self _dealGroupTwo];
    
    CommonGroupViewModel *group3 = [CommonGroupViewModel groupViewModel];
    group3.footerHeight = ZGCConvertToPx(10);
    group3.itemViewModels = [self _dealGroupThird];
    
    if (group2.itemViewModels.count > 0) {
        self.dataSource = @[group1, group2, group3];
    } else {
        self.dataSource = @[group1, group3];
    }
}

- (NSArray *)_dealGroupOne {
    @weakify(self);
    NSMutableArray *groupArr = [NSMutableArray array];
    EditUserItemViewModel *usernameItem = [EditUserItemViewModel itemViewModelWithTitle:@"账号"];
    usernameItem.placeholder = @"请输入账号";
    RACChannelTo(usernameItem, value) = RACChannelTo(self.addUser, username);
    usernameItem.rowHeight = ZGCConvertToPx(50);
    [groupArr addObject:usernameItem];
    
    EditRealItemViewModel *nameItem = [EditRealItemViewModel itemViewModelWithTitle:@"姓名"];
    nameItem.placeholder = @"请输入客户姓名";
    RACChannelTo(nameItem, value) = RACChannelTo(self.addUser, realname);
    nameItem.rowHeight = ZGCConvertToPx(50);
    [groupArr addObject:nameItem];
    
    if (![[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.jydiam.com"]) {
        EditPhoneItemViewModel *phoneItem = [EditPhoneItemViewModel itemViewModelWithTitle:@"手机"];
        phoneItem.placeholder = @"请输入客户手机";
        RACChannelTo(phoneItem, value) = RACChannelTo(self.addUser, mobile);
        phoneItem.rowHeight = ZGCConvertToPx(50);
        [groupArr addObject:phoneItem];
    }
    
    EditFromItemViewModel *selectItem = [EditFromItemViewModel itemViewModelWithTitle:@"引用权限配置"];
    RAC(selectItem, subTitle) = [RACObserve(self.addUser, fromList) map:^id(NSNumber *x) {
        @strongify(self);
        NSString *title = @"请选择...";
        for (SiftList *list in self.userSelectList) {
            if (list.listId.integerValue != x.integerValue) continue;
            title = formatString(list.name);
            break;
        }
        return title;
    }];
    selectItem.rowHeight = ZGCConvertToPx(50);
    selectItem.type = 1;
    selectItem.clickSub = self.selectSub;
    [groupArr addObject:selectItem];
    
    if (self.type == 1) {
        EditSellerItemViewModel *sellerItem = [EditSellerItemViewModel itemViewModelWithTitle:@"销售员"];
        RAC(sellerItem, subTitle) = [RACObserve(self.addUser, seller) map:^id(NSNumber *x) {
            @strongify(self);
            NSString *title = @"请选择...";
            for (SiftList *list in self.sellerSelectList) {
                if (list.listId.integerValue != x.integerValue) continue;
                title = formatString(list.name);
                break;
            }
            if (self.services.client.currentUser.userType > 4) {
                Member *data;
                for (Member *mem in self.sellerList) {
                    if (mem.memberId.integerValue == x.integerValue) {
                        mem.rateDiscount = @(mem.rateDiscount.floatValue * 100);
                        data = mem;
                        break;
                    }
                }
                self.loginData = data;
            }
            return title;
        }];
        sellerItem.rowHeight = ZGCConvertToPx(50);
        sellerItem.type = 2;
        sellerItem.clickSub = self.selectSub;
        [groupArr addObject:sellerItem];
        
        EditBuyerItemViewModel *buyItem = [EditBuyerItemViewModel itemViewModelWithTitle:@"采购员"];
        RAC(buyItem, subTitle) = [RACObserve(self.addUser, buyer) map:^id(NSNumber *x) {
            @strongify(self);
            NSString *title = @"请选择...";
            for (SiftList *list in self.buySelectList) {
                if (list.listId.integerValue != x.integerValue) continue;
                title = formatString(list.name);
                break;
            }
            return title;
        }];
        buyItem.rowHeight = ZGCConvertToPx(50);
        buyItem.type = 3;
        buyItem.clickSub = self.selectSub;
        [groupArr addObject:buyItem];
    }
    return [groupArr copy];
}

- (NSArray *)_dealGroupTwo {
    @weakify(self);
    NSInteger goodsStock = SharedAppDelegate.manager.isYGoodsStock;
    
    EditVipItemViewModel *vipItem = [EditVipItemViewModel itemViewModelWithTitle:@"会员等级"];
    RAC(vipItem, subTitle) = [RACObserve(self.addUser, level) map:^id(NSNumber *x) {
        @strongify(self);
        NSString *title = @"请选择...";
        NSString *levelDisc;
        for (SiftList *list in self.vipSelectList) {
            if (list.listId.integerValue != x.integerValue) continue;
            title = formatString(list.name);
            if (x.integerValue == 1) {
                levelDisc = SharedAppDelegate.vipRate.temp1;
            } else if (x.integerValue == 2) {
                levelDisc = SharedAppDelegate.vipRate.temp2;
            } else if (x.integerValue == 3) {
                levelDisc = SharedAppDelegate.vipRate.temp3;
            } else if (x.integerValue == 4) {
                levelDisc = SharedAppDelegate.vipRate.temp4;
            }
            break;
        }
        self.levelDisc = levelDisc;
        return title;
    }];
    vipItem.rowHeight = ZGCConvertToPx(50);
    vipItem.type = 4;
    vipItem.clickSub = self.selectSub;
    
    EditUsertypeItemViewModel *typeItem = [EditUsertypeItemViewModel itemViewModelWithTitle:@"所属部门"];
    RAC(typeItem, subTitle) = [RACObserve(self.addUser, userType) map:^id(NSNumber *x) {
        @strongify(self);
        NSString *title = @"请选择...";
        for (SiftList *list in self.userTypeSelectList) {
            if (list.listId.integerValue != x.integerValue) continue;
            title = formatString(list.name);
            break;
        }
        return title;
    }];
    typeItem.rowHeight = ZGCConvertToPx(50);
    typeItem.type = 5;
    typeItem.clickSub = self.selectSub;
    
    EditRightItemViewModel *roleItem = [EditRightItemViewModel itemViewModelWithTitle:@"数据展示权限"];
    roleItem.leftStr = @"角色";
    roleItem.rightStr = @"自定义";
    roleItem.rowHeight = ZGCConvertToPx(50);
    RAC(roleItem, allowed) = [RACObserve(self.addUser, roleSelect) map:^id(NSNumber *x){
        return @(x.integerValue == 1);
    }];
    [RACObserve(roleItem, allowed) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (self.addUser.roleSelect == 1 && x.boolValue) return;
        if (self.addUser.roleSelect == 2 && !x.boolValue) return;
        self.addUser.roleSelect = x.boolValue?1:2;
        self.roleHeight = x.boolValue?ZGCConvertToPx(50):0;
        self.rightHeight = !x.boolValue?[self _getRightHeight]:0;
        [self.reloadSub sendNext:nil];
    }];
    
    EditRoleItemViewModel *roleSelectItem = [EditRoleItemViewModel itemViewModelWithTitle:@"权限角色"];
    RAC(roleSelectItem, subTitle) = [RACObserve(self.addUser, fromRole) map:^id(NSNumber *x) {
        @strongify(self);
        NSString *title = @"请选择...";
        for (SiftList *list in self.roleSelectList) {
            if (list.listId.integerValue != x.integerValue) continue;
            title = formatString(list.name);
            break;
        }
        for (Role *role in self.roleList) {
            if (role.roleId.integerValue != x.integerValue) continue;
            self.addUser.areaShow = role.isRegion;
            self.addUser.certshow = role.isCertNo;
            self.addUser.detailshow = role.isDetail;
            self.addUser.rapshow = role.isRap;
            self.addUser.rapBuyshow = role.isDollar;
            self.addUser.discshow = role.isDisc;
            self.addUser.mbgshow = role.isBgm;
            self.addUser.blackshow = role.isBlack;
            self.addUser.fancyRapshow = role.isColorRap;
            self.addUser.imgShow = role.isDaylight;
            self.addUser.dollarShow = role.isDollarRate;
            self.addUser.realGoodsNumberShow = role.isTrueRef;
            self.addUser.sizeShow = role.isMeasurements;
            self.addUser.isEyeCleanShow = role.isEyeClean;
            self.addUser.isDTShow = role.isDT;
            break;
        }
        return title;
    }];
    roleSelectItem.type = 6;
    roleSelectItem.clickSub = self.selectSub;
    RAC(roleSelectItem, rowHeight) = RACObserve(self, roleHeight);
    
    EditRightsItemViewModel *rightsItem = [EditRightsItemViewModel itemViewModelWithTitle:@""];
    RAC(rightsItem, rowHeight) = RACObserve(self, rightHeight);
    RACChannelTo(rightsItem, area) = RACChannelTo(self.addUser, areaShow);
    RACChannelTo(rightsItem, cert) = RACChannelTo(self.addUser, certshow);
    RACChannelTo(rightsItem, detail) = RACChannelTo(self.addUser, detailshow);
    RACChannelTo(rightsItem, rap) = RACChannelTo(self.addUser, rapshow);
    RACChannelTo(rightsItem, rapBuy) = RACChannelTo(self.addUser, rapBuyshow);
    RACChannelTo(rightsItem, disc) = RACChannelTo(self.addUser, discshow);
    RACChannelTo(rightsItem, mbg) = RACChannelTo(self.addUser, mbgshow);
    RACChannelTo(rightsItem, black) = RACChannelTo(self.addUser, blackshow);
    RACChannelTo(rightsItem, fancyRap) = RACChannelTo(self.addUser, fancyRapshow);
    RACChannelTo(rightsItem, img) = RACChannelTo(self.addUser, imgShow);
    RACChannelTo(rightsItem, dollar) = RACChannelTo(self.addUser, dollarShow);
    RACChannelTo(rightsItem, realGoodsNumber) = RACChannelTo(self.addUser, realGoodsNumberShow);
    RACChannelTo(rightsItem, size) = RACChannelTo(self.addUser, sizeShow);
    RACChannelTo(rightsItem, isEyeClean) = RACChannelTo(self.addUser, isEyeCleanShow);
    RACChannelTo(rightsItem, isDT) = RACChannelTo(self.addUser, isDTShow);
    
    NSMutableArray *groupArr = [NSMutableArray array];
    if (self.type == 1) {
        if (goodsStock == 0)
            [groupArr addObject:vipItem];
    } else {
        [groupArr addObject:typeItem];
    }
    if (goodsStock != 1) {
        [groupArr addObject:roleItem];
        [groupArr addObject:roleSelectItem];
        [groupArr addObject:rightsItem];
    }
    return [groupArr copy];
}

- (NSArray *)_dealGroupThird {
    @weakify(self);
    EditDiscItemViewModel *discItem = [EditDiscItemViewModel itemViewModelWithTitle:@"白钻折扣"];
    discItem.placeholder = @"请输入白钻折扣";
    RACChannelTo(discItem, value) = RACChannelTo(self.addUser, disc);
    discItem.rowHeight = ZGCConvertToPx(50);
    
    EditWhiteItemViewModel *whiteItem = [EditWhiteItemViewModel itemViewModelWithTitle:@"白钻倍率"];
    whiteItem.placeholder = @"请输入白钻倍率";
    RACChannelTo(whiteItem, value) = RACChannelTo(self.addUser, white);
    whiteItem.rowHeight = ZGCConvertToPx(50);
    
    EditFancyItemViewModel *fancyItem = [EditFancyItemViewModel itemViewModelWithTitle:@"彩钻倍率"];
    fancyItem.placeholder = @"请输入彩钻倍率";
    RACChannelTo(fancyItem, value) = RACChannelTo(self.addUser, fancy);
    fancyItem.rowHeight = ZGCConvertToPx(50);
    
    EditRateItemViewModel *rateItem = [EditRateItemViewModel itemViewModelWithTitle:@"成品倍率"];
    rateItem.placeholder = @"请输入成品倍率";
    RACChannelTo(rateItem, value) = RACChannelTo(self.addUser, rateDouble);
    rateItem.rowHeight = ZGCConvertToPx(50);
    
    EditZtItemViewModel *ztItem = [EditZtItemViewModel itemViewModelWithTitle:@"找托倍率"];
    ztItem.placeholder = @"请输入找托倍率";
    RACChannelTo(ztItem, value) = RACChannelTo(self.addUser, rateDoubleZt);
    ztItem.rowHeight = ZGCConvertToPx(50);
    
    AccountAddItemViewModel *rateDiscItem = [AccountAddItemViewModel itemViewModelWithTitle:@"销售员折扣"];
    RAC(rateDiscItem, value) = [RACObserve(self, loginData) map:^id(Member *m) {
        return formatWithString(m.rateDiscount, @"0");
    }];
    RAC(rateDiscItem, rowHeight) = RACObserve(self, rateDiscHeight);
    
    AccountAddItemViewModel *rateLzItem = [AccountAddItemViewModel itemViewModelWithTitle:@"销售员白钻倍率"];
    RAC(rateLzItem, value) = [RACObserve(self, loginData) map:^id(Member *m) {
        return formatWithString(m.rateDoubleLz, @"0");
    }];
    RAC(rateLzItem, rowHeight) = RACObserve(self, rateLzHeight);
    
    AccountAddItemViewModel *rateLzColorItem = [AccountAddItemViewModel itemViewModelWithTitle:@"销售员彩钻倍率"];
    RAC(rateLzColorItem, value) = [RACObserve(self, loginData) map:^id(Member *m) {
        return formatWithString(m.rateDoubleLzColor, @"0");
    }];
    RAC(rateLzColorItem, rowHeight) = RACObserve(self, rateLzColorHeight);
    
    AccountAddItemViewModel *rateDoubleItem = [AccountAddItemViewModel itemViewModelWithTitle:@"销售员成品倍率"];
    RAC(rateDoubleItem, value) = [RACObserve(self, loginData) map:^id(Member *m) {
        return formatWithString(m.rateDouble, @"0");
    }];
    RAC(rateDoubleItem, rowHeight) = RACObserve(self, rateDoubleHeight);
    
    AccountAddItemViewModel *rateDoubleZtItem = [AccountAddItemViewModel itemViewModelWithTitle:@"销售员找托倍率"];
    RAC(rateDoubleZtItem, value) = [RACObserve(self, loginData) map:^id(Member *m) {
        return formatWithString(m.rateDoubleZt, @"0");
    }];
    RAC(rateDoubleZtItem, rowHeight) = RACObserve(self, rateDoubleZtHeight);
    
    AccountAddItemViewModel *discBel1Item = [AccountAddItemViewModel itemViewModelWithTitle:@"白钻折扣总计"];
    RAC(discBel1Item, value) = RACObserve(self, discBel1);
    RAC(discBel1Item, rowHeight) = RACObserve(self, disc1Height);
    
    AccountAddItemViewModel *discBel2Item = [AccountAddItemViewModel itemViewModelWithTitle:@"白钻倍率总计"];
    RAC(discBel2Item, value) = RACObserve(self, discBel2);
    RAC(discBel2Item, rowHeight) = RACObserve(self, disc2Height);
    
    AccountAddItemViewModel *discBel3Item = [AccountAddItemViewModel itemViewModelWithTitle:@"彩钻倍率总计"];
    RAC(discBel3Item, value) = RACObserve(self, discBel3);
    RAC(discBel3Item, rowHeight) = RACObserve(self, disc3Height);
    
    AccountAddItemViewModel *discBel4Item = [AccountAddItemViewModel itemViewModelWithTitle:@"成品倍率总计"];
    RAC(discBel4Item, value) = RACObserve(self, discBel4);
    RAC(discBel4Item, rowHeight) = RACObserve(self, disc4Height);
    
    AccountAddItemViewModel *discBel5Item = [AccountAddItemViewModel itemViewModelWithTitle:@"找托倍率总计"];
    RAC(discBel5Item, value) = RACObserve(self, discBel5);
    RAC(discBel5Item, rowHeight) = RACObserve(self, disc5Height);
    
    AccountDoubleItemViewModel *exportItem = [AccountDoubleItemViewModel itemViewModelWithTitle:@"数据下载"];
    exportItem.leftStr = @"允许";
    exportItem.rightStr = @"禁止";
    RACChannelTo(exportItem, allowed) = RACChannelTo(self.addUser, isExport);
    exportItem.rowHeight = ZGCConvertToPx(50);
    
    AccountDoubleItemViewModel *statusItem = [AccountDoubleItemViewModel itemViewModelWithTitle:@"登录状态"];
    statusItem.leftStr = @"允许";
    statusItem.rightStr = @"禁止";
    RAC(statusItem, allowed) = [RACObserve(self.addUser, status) map:^id(NSNumber *x) {
        return @(x.integerValue == 2);
    }];
    [RACObserve(statusItem, allowed) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue && self.addUser.status == 2) return;
        if (!x.boolValue && self.addUser.status == 3) return;
        self.addUser.status = x.boolValue?2:3;
    }];
    statusItem.rowHeight = ZGCConvertToPx(50);
    
    NSInteger userLevel = self.services.client.currentUser.userType;
    NSInteger goodsStock = SharedAppDelegate.manager.isYGoodsStock;
    NSInteger sourceType = SharedAppDelegate.manager.isSourceType;
    NSMutableArray *groupArr = [NSMutableArray array];
    
    if (goodsStock == 0) {
        [groupArr addObject:discItem];
        [groupArr addObject:whiteItem];
        [groupArr addObject:fancyItem];
        [groupArr addObject:rateItem];
        if (sourceType == 2)
            [groupArr addObject:ztItem];
        if (self.type == 1 && userLevel > 4) {
            [groupArr addObject:rateDiscItem];
            [groupArr addObject:rateLzItem];
            [groupArr addObject:rateLzColorItem];
            [groupArr addObject:rateDoubleItem];
            if (sourceType == 2)
                [groupArr addObject:rateDoubleZtItem];
            [groupArr addObject:discBel1Item];
            [groupArr addObject:discBel2Item];
            [groupArr addObject:discBel3Item];
            [groupArr addObject:discBel4Item];
            if (sourceType == 2)
                [groupArr addObject:discBel5Item];
        }
        [groupArr addObject:exportItem];
        [groupArr addObject:statusItem];
    } else if (goodsStock == 1) {
        [groupArr addObject:rateItem];
        if (self.type == 1 && userLevel > 4) {
            [groupArr addObject:rateDoubleItem];
            [groupArr addObject:discBel4Item];
        }
        [groupArr addObject:statusItem];
    } else if (goodsStock == 3) {
        whiteItem.title = @"裸石倍率";
        [groupArr addObject:whiteItem];
        [groupArr addObject:rateItem];
        if (self.type == 1 && userLevel > 4) {
            rateLzItem.title = @"销售员裸石倍率";
            [groupArr addObject:rateLzItem];
            [groupArr addObject:rateDoubleItem];
            discBel2Item.title = @"裸石倍率总计";
            [groupArr addObject:discBel2Item];
            [groupArr addObject:discBel4Item];
        }
        [groupArr addObject:exportItem];
        [groupArr addObject:statusItem];
    }
    return [groupArr copy];
}

- (CGFloat)_getRightHeight {
    NSInteger userLevel = [HTTPService sharedInstance].currentUser.userType;
    if (userLevel==9||userLevel==5) {
        return ZGCConvertToPx(196);
    } else {
        NSMutableArray *rights = [NSMutableArray array];
        if ([SingleInstance boolForKey:AddressShowKey]) [rights addObject:@"1"];
        if ([SingleInstance boolForKey:CertShowKey]) [rights addObject:@"2"];
        if ([SingleInstance boolForKey:RapIdShowKey] && [SingleInstance numberForKey:DiamondShowPowerMasterKey].integerValue == 1) [rights addObject:@"3"];
        if ([SingleInstance boolForKey:RapShowKey]) [rights addObject:@"4"];
        if ([SingleInstance boolForKey:RapBuyShowKey]) [rights addObject:@"5"];
        if ([SingleInstance boolForKey:DiscShowKey]) [rights addObject:@"6"];
        if ([SingleInstance boolForKey:MbgShowKey]) [rights addObject:@"7"];
        if ([SingleInstance boolForKey:BlackShowKey]) [rights addObject:@"8"];
        if ([SingleInstance boolForKey:FancyRapKey]) [rights addObject:@"9"];
        if ([SingleInstance boolForKey:ImgShowKey]) [rights addObject:@"10"];
        if ([SingleInstance boolForKey:DollarShowKey]) [rights addObject:@"11"];
        if ([SingleInstance boolForKey:GoodsNumberShowKey]) [rights addObject:@"12"];
        if ([SingleInstance boolForKey:SizeShowKey]) [rights addObject:@"13"];
        if ([SingleInstance boolForKey:EyeCleanShowKey]) [rights addObject:@"14"];
        if ([SingleInstance boolForKey:DTShowKey]) [rights addObject:@"15"];
        if (rights.count == 0) return 0;
        return ((rights.count-1)/3+1)*ZGCConvertToPx(36)+ZGCConvertToPx(16);
    }
}

- (AddMember *)_createAddUser {
    AddMember *add = [[AddMember alloc] init];
    add.roleSelect = 1;
    add.areaShow = NO;
    add.certshow = NO;
    add.detailshow = NO;
    add.rapshow = NO;
    add.rapBuyshow = NO;
    add.discshow = NO;
    add.mbgshow = NO;
    add.blackshow = NO;
    add.fancyRapshow = NO;
    add.imgShow = NO;
    add.dollarShow = NO;
    add.realGoodsNumberShow = NO;
    add.sizeShow = NO;
    add.isEyeCleanShow = NO;
    add.isDTShow = NO;
    add.disc = @"0";
    add.white = @"1";
    add.fancy = @"1";
    add.rateDouble = @"1";
    add.rateDoubleZt = @"1";
    add.isExport = YES;
    add.status = 2;
    return add;
}

- (void)_resetAddUser {
    self.addUser.username = @"";
    self.addUser.realname = @"";
    self.addUser.mobile = @"";
    self.addUser.buyer = @0;
    self.addUser.level = 0;
    self.addUser.userType = 0;
    self.addUser.buyer = @0;
    self.addUser.fromList = @0;
    self.addUser.fromRole = @0;
    self.addUser.seller = @0;
    self.addUser.disc = @"0";
    self.addUser.white = @"1";
    self.addUser.fancy = @"1";
    self.addUser.rateDouble = @"1";
    self.addUser.rateDoubleZt = @"1";
    self.addUser.roleSelect = 1;
    self.addUser.isExport = YES;
    self.addUser.status = 2;
    self.addUser.areaShow = NO;
    self.addUser.certshow = NO;
    self.addUser.detailshow = NO;
    self.addUser.rapshow = NO;
    self.addUser.rapBuyshow = NO;
    self.addUser.discshow = NO;
    self.addUser.mbgshow = NO;
    self.addUser.blackshow = NO;
    self.addUser.fancyRapshow = NO;
    self.addUser.imgShow = NO;
    self.addUser.dollarShow = NO;
    self.addUser.realGoodsNumberShow = NO;
    self.addUser.sizeShow = NO;
    self.addUser.isEyeCleanShow = NO;
    self.addUser.isDTShow = NO;
    if (self.services.client.currentUser.userType == 2) {
        self.addUser.buyer = [SingleInstance numberForKey:ZGCUserIdKey];
    } else if (self.services.client.currentUser.userType == 3) {
        self.addUser.seller = [SingleInstance numberForKey:ZGCUserIdKey];
    }
    self.roleHeight = ZGCConvertToPx(50);
    self.rightHeight = 0;
}

- (BOOL)_checkInput {
    NSString *errorMsg;
    if (kStringIsEmpty(self.addUser.username)) errorMsg = @"账号不能为空";
    else if ([self.addUser.username hasSuffix:@".com"] || [self.addUser.username hasSuffix:@".cn"])
        errorMsg = @"账号不能已.com或.cn结尾！";
    else if (self.addUser.username.length < 2) errorMsg = @"账号不能少于两位字符";
    if (kStringIsEmpty(self.addUser.realname)) errorMsg = @"姓名不能为空";
    if (kStringIsEmpty(self.addUser.mobile)) errorMsg = @"手机不能为空";
    if (kStringIsEmpty(self.addUser.disc)) errorMsg = @"白钻折扣不能为空";
    if (kStringIsEmpty(self.addUser.white)) errorMsg = @"白钻倍率不能为空";
    if (kStringIsEmpty(self.addUser.fancy)) errorMsg = @"彩钻倍率不能为空";
    if (kStringIsEmpty(self.addUser.rateDouble)) errorMsg = @"成品倍率不能为空";
    if (self.type == 2 && self.addUser.userType == 0) errorMsg = @"请选择所属部门";
    if (self.addUser.white.floatValue <= 0) errorMsg = @"白钻倍率必须大于0";
    if (self.addUser.fancy.floatValue <= 0) errorMsg = @"彩钻倍率必须大于0";
    if (self.addUser.rateDouble.floatValue <= 0) errorMsg = @"成品倍率必须大于0";
    if (self.addUser.rateDouble.floatValue <= 0 && SharedAppDelegate.manager.isSourceType == 2) errorMsg = @"找托倍率必须大于0";
    if (self.addUser.status < 2) errorMsg = @"请选择登录状态";
    if (kStringIsNotEmpty(self.addUser.mobile) && ![self.addUser.mobile zgc_isValidMobile])
        errorMsg = @"手机格式不正确";
    
    if (kStringIsNotEmpty(errorMsg)) {
        [SVProgressHUD showInfoWithStatus:errorMsg];
        return NO;
    }
    return YES;
}

- (void)_validateNameAndMobile {
    @weakify(self);
    if ([self _checkInput]) {
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"param"] = [self.addUser.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subscript[@"validateName"] = @"username";
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_VILADE_MOBILE, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:subscript.dictionary];
        [[self.services.client enqueueParameter:paramters resultClass:LoginStatus.class] subscribeNext:^(HTTPResponse *response) {
            @strongify(self);
            LoginStatus *status = response.parsedResult;
            if (status.code == 0) {
                KeyedSubscript *mobileSub = [KeyedSubscript subscript];
                mobileSub[@"param"] = [self.addUser.mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                mobileSub[@"validateName"] = @"mobile";
                mobileSub[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
                URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_VILADE_MOBILE, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:mobileSub.dictionary];
                @weakify(self);
                [[self.services.client enqueueParameter:paramters resultClass:LoginStatus.class] subscribeNext:^(HTTPResponse *response) {
                    @strongify(self);
                    LoginStatus *status = response.parsedResult;
                    if (status.code == 0) {
                        [self _changePassword];// 转码
                    } else {
                        [SVProgressHUD showErrorWithStatus:status.desc];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:status.desc];
            }
        }];
    }
}

- (void)_changePassword {
    @weakify(self);
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"param"] = [self.addUser.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_AES_PUBLICKEY, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:subscript.dictionary];
    [[self.services.client enqueueParameter:paramters resultClass:PublicKey.class] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        PublicKey *key = response.parsedResult;
        [self _addAccountDo:[RSAEncryptTool encryptPublicKey:@"123123" Mod:key.temp]];
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"密码转码失败"];
    }];
}

- (void)_addAccountDo:(NSString *)password {
    @weakify(self);
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"temp_uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"password"] = password;
    subscript[@"username"] = [self.addUser.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    subscript[@"status"] = @(self.addUser.status);
    subscript[@"rate_discount"] = self.addUser.disc;
    subscript[@"rate_double_lz"] = self.addUser.white;
    subscript[@"rate_double_lz_color"] = self.addUser.fancy;
    subscript[@"rate_double"] = self.addUser.rateDouble;
    if (SharedAppDelegate.manager.isSourceType == 2) {
        subscript[@"rate_double_zt"] = self.addUser.rateDoubleZt;
    }
    subscript[@"user_type"] = @(self.type);
    
    NSString *temp = [NSString stringWithFormat:@"[{\"mobile\":%@,\"realname\":%@,\"is_export\":%d,\"diamond_show_power\":\"%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\"", self.addUser.mobile, self.addUser.realname.stringByURLEncode, self.addUser.isExport?1:0, self.addUser.areaShow?1:0, self.addUser.certshow?1:0, self.addUser.detailshow?1:0, self.addUser.rapshow?1:0, self.addUser.rapBuyshow?1:0, self.addUser.discshow?1:0, self.addUser.mbgshow?1:0, self.addUser.blackshow?1:0, self.addUser.fancyRapshow?1:0, self.addUser.imgShow?1:0, self.addUser.dollarShow?1:0, self.addUser.realGoodsNumberShow?1:0, self.addUser.sizeShow?1:0, self.addUser.isEyeCleanShow?1:0, self.addUser.isDTShow?1:0];
    if (self.type == 1) {
        if (self.addUser.level != 0) {
            subscript[@"user_level"] = @(self.addUser.level);
        }
        if (self.addUser.seller && self.addUser.seller.integerValue != 0) {
            temp = [temp stringByAppendingFormat:@",\"salesmen_id\":%@", self.addUser.seller];
        }
        if (self.addUser.buyer && self.addUser.buyer.integerValue != 0) {
            temp = [temp stringByAppendingFormat:@",\"buyer_id\":%@", self.addUser.buyer];
        }
    } else {
        subscript[@"user_type"] = @(self.addUser.userType);
    }
    temp = [temp stringByAppendingString:@"}]"];
    subscript[@"temp"] = temp;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_ADD_ACCOUNT parameters:subscript.dictionary];
    [[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        ObjectT *obj = response.parsedResult;
        if (obj.appCheckCode) {
            [self.services.client loginAtOtherPlace];
        } else {
            [MBProgressHUD zgc_hideHUD];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [ZGCNotificationCenter postNotificationName:AddAccountSuccessNotification object:nil userInfo:@{}];
            [self.services popViewModelAnimated:YES];
        }
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"添加失败"];
    }];
}

@end
