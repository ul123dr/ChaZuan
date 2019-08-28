//
//  GoodOtherOne.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodOtherOne : MHObject

@property (nonatomic, readwrite, strong) NSString *payTime;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, assign) NSInteger isbill;
@property (nonatomic, readwrite, strong) NSNumber *payPrice;
@property (nonatomic, readwrite, strong) NSString *orderNo;
@property (nonatomic, readwrite, assign) NSInteger wwwType;
@property (nonatomic, readwrite, assign) NSInteger goodType;
@property (nonatomic, readwrite, strong) NSString *gidUid;
@property (nonatomic, readwrite, assign) NSInteger isPay;
@property (nonatomic, readwrite, assign) NSInteger orderSx;
@property (nonatomic, readwrite, strong) NSNumber *orderId;
@property (nonatomic, readwrite, assign) NSInteger deposit;
@property (nonatomic, readwrite, assign) NSInteger orderTj;
@property (nonatomic, readwrite, strong) NSNumber *realPrice;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSString *uid;
@property (nonatomic, readwrite, strong) NSString *mobile;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, assign) BOOL isOk;
@property (nonatomic, readwrite, strong) NSNumber *dollarRate;
@property (nonatomic, readwrite, strong) NSString *createTime;
@property (nonatomic, readwrite, strong) NSNumber *price;

@end

NS_ASSUME_NONNULL_END
