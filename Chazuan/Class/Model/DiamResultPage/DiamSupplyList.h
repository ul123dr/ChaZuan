//
//  DiamSupplyList.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamSupplyList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *updateTime;
@property (nonatomic, readwrite, copy) NSString *supplierLocation;
@property (nonatomic, readwrite, strong) NSNumber *supplierAreaType;
@property (nonatomic, readwrite, copy) NSString *logo;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, strong) NSNumber *dollarRate;
@property (nonatomic, readwrite, strong) NSNumber *isQuick;
@property (nonatomic, readwrite, copy) NSString *supplierNameTrue;
@property (nonatomic, readwrite, copy) NSString *whatsapp;
@property (nonatomic, readwrite, copy) NSString *skype;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *supplierNo;
@property (nonatomic, readwrite, strong) NSNumber *isJk;
@property (nonatomic, readwrite, strong) NSNumber *type;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, copy) NSString *orderbyTurn;
@property (nonatomic, readwrite, copy) NSString *supplierSimpleName;
@property (nonatomic, readwrite, copy) NSString *weixin;
@property (nonatomic, readwrite, copy) NSString *supplierTypeCn;
@property (nonatomic, readwrite, copy) NSString *supplierDollarRate;
@property (nonatomic, readwrite, copy) NSString *mobile;
@property (nonatomic, readwrite, copy) NSString *rapid;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *supplierWww;
@property (nonatomic, readwrite, copy) NSString *qq;
@property (nonatomic, readwrite, copy) NSString *orderbyParam;
@property (nonatomic, readwrite, strong) NSNumber *isAuto;
@property (nonatomic, readwrite, strong) NSNumber *isCustomer;
@property (nonatomic, readwrite, copy) NSString *supplierName;
@property (nonatomic, readwrite, copy) NSString *sessionkey;
@property (nonatomic, readwrite, strong) NSNumber *disc1;

@end

NS_ASSUME_NONNULL_END
