//
//  OrderSubList.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "GoodOtherOne.h"
#import "OrderJson.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderSubList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *supplierAddress;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *mRemark;
@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, copy) NSString *goodName;
@property (nonatomic, readwrite, copy) NSString *receivedTime;
@property (nonatomic, readwrite, copy) NSString *supplierSimpleName;
@property (nonatomic, readwrite, strong) NSNumber *size;
@property (nonatomic, readwrite, strong) NSNumber *advancePrice;
@property (nonatomic, readwrite, strong) NSNumber *type;
@property (nonatomic, readwrite, copy) NSString *detail;
@property (nonatomic, readwrite, strong) NSNumber *diamondPrice;
@property (nonatomic, readwrite, copy) NSString *disc;
@property (nonatomic, readwrite, copy) NSString *discCost;
@property (nonatomic, readwrite, copy) NSString *discGid;
@property (nonatomic, readwrite, strong) NSNumber *discountPrice;
@property (nonatomic, readwrite, strong) NSNumber *finalPayment;
@property (nonatomic, readwrite, strong) NSNumber *goodId;
@property (nonatomic, readwrite, strong) NSNumber *goodType;
@property (nonatomic, readwrite, assign) BOOL isDisount;
@property (nonatomic, readwrite, strong) NSNumber *isSh;
@property (nonatomic, readwrite, assign) BOOL isown;
@property (nonatomic, readwrite, strong) NSNumber *num;
@property (nonatomic, readwrite, strong) NSNumber *orderGoodOtherId;
@property (nonatomic, readwrite, strong) NSNumber *orderGoodsId;
@property (nonatomic, readwrite, strong) GoodOtherOne *orderGoodOtherOne;
@property (nonatomic, readwrite, strong) NSNumber *orderId;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, strong) NSNumber *priceCost;
@property (nonatomic, readwrite, strong) NSNumber *purchasePrice;
@property (nonatomic, readwrite, strong) NSNumber *purchasePriceRmb;
@property (nonatomic, readwrite, strong) NSNumber *realPrice;
@property (nonatomic, readwrite, assign) NSInteger stoneType;
@property (nonatomic, readwrite, assign) NSInteger styleStatus;
@property (nonatomic, readwrite, assign) NSInteger tempStatus;
@property (nonatomic, readwrite, copy) NSString *purchasePriceDisc;
@property (nonatomic, readwrite, assign) NSInteger sourceType;
@property (nonatomic, readwrite, copy) NSString *extend;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) OrderJson *json;

@end

NS_ASSUME_NONNULL_END
