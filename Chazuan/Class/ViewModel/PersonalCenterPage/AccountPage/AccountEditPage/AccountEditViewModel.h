//
//  AccountEditViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "AccountEditItemViewModel.h"
#import "AccountAddItemViewModel.h"
#import "AccountDoubleItemViewModel.h"
#import "EditRealItemViewModel.h"
#import "EditPhoneItemViewModel.h"
#import "EditSellerItemViewModel.h"
#import "EditBuyerItemViewModel.h"
#import "EditVipItemViewModel.h"
#import "EditUsertypeItemViewModel.h"
#import "EditRightItemViewModel.h"
#import "EditRightsItemViewModel.h"
#import "EditDiscItemViewModel.h"
#import "EditWhiteItemViewModel.h"
#import "EditFancyItemViewModel.h"
#import "EditRateItemViewModel.h"
#import "EditZtItemViewModel.h"
#import "SiftList.h"
#import "AddMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountEditViewModel : BaseTableViewModel

@property (nonatomic, readonly, assign) NSInteger type;
@property (nonatomic, readonly, strong) NSMutableArray *sellerSelectList;
@property (nonatomic, readonly, strong) NSMutableArray *buySelectList;
@property (nonatomic, readonly, strong) NSArray *vipSelectList;
@property (nonatomic, readonly, strong) NSArray *userTypeSelectList;

@property (nonatomic, readonly, assign) BOOL isEdit;
@property (nonatomic, readwrite, strong) AddMember *addUser;

@property (nonatomic, readonly, strong) RACSubject *selectSub;
@property (nonatomic, readonly, strong) RACCommand *editCommand;

@property (nonatomic, readwrite, strong) RACSubject *reloadSub;

@end

NS_ASSUME_NONNULL_END
