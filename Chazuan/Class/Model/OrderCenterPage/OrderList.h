//
//  OrderList.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "OrderSubList.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) User *userpro;
@property (nonatomic, readwrite, copy) NSString *createTime;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, assign) NSInteger deposit;
@property (nonatomic, readwrite, strong) NSNumber *dollarRate;
@property (nonatomic, readwrite, assign) NSInteger goodType;
@property (nonatomic, readwrite, assign) NSInteger isPay;
@property (nonatomic, readwrite, assign) NSInteger isbill;
@property (nonatomic, readwrite, copy) NSString *mobile;
@property (nonatomic, readwrite, strong) NSNumber *orderId;
@property (nonatomic, readwrite, copy) NSString *orderNo;
@property (nonatomic, readwrite, strong) NSNumber *orderSx;
@property (nonatomic, readwrite, strong) NSNumber *orderTj;
@property (nonatomic, readwrite, strong) NSNumber *payPrice;
@property (nonatomic, readwrite, copy) NSString *payTime;
@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, strong) NSNumber *realPrice;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *revName;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *telephone;
@property (nonatomic, readwrite, copy) NSString *userMobile;
@property (nonatomic, readwrite, copy) NSString *userRealname;
@property (nonatomic, readwrite, assign) NSInteger wwwType;
@property (nonatomic, readwrite, assign) BOOL ok;

@end

NS_ASSUME_NONNULL_END
