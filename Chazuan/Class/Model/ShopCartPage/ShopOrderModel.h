//
//  ShopOrderModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopOrderList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSNumber *cloudGoodsId;
@property (nonatomic, readwrite, copy) NSString *size;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, assign) NSInteger detail;
@property (nonatomic, readwrite, assign) NSNumber *diamondPrice;
@property (nonatomic, readwrite, copy) NSString *disc;
@property (nonatomic, readwrite, copy) NSString *discCost;
@property (nonatomic, readwrite, copy) NSString *discGid;
@property (nonatomic, readwrite, strong) NSNumber *goodId;
@property (nonatomic, readwrite, copy) NSString *goodName;
@property (nonatomic, readwrite, assign) NSInteger goodType;
@property (nonatomic, readwrite, assign) NSInteger isDisount;
@property (nonatomic, readwrite, assign) NSInteger isSh;
@property (nonatomic, readwrite, assign) NSInteger isown;
@property (nonatomic, readwrite, copy) NSString *mRemark;
@property (nonatomic, readwrite, assign) NSInteger num;
@property (nonatomic, readwrite, strong) NSNumber *orderGoodsId;
@property (nonatomic, readwrite, strong) NSNumber *orderId;
@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, copy) NSString *priceCost;
@property (nonatomic, readwrite, copy) NSString *purchasePrice;
@property (nonatomic, readwrite, copy) NSString *purchasePriceDisc;
@property (nonatomic, readwrite, strong) NSNumber *purchasePriceRmb;
@property (nonatomic, readwrite, copy) NSString *realPrice;
@property (nonatomic, readwrite, copy) NSString *receivedTime;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *supplierAddress;
@property (nonatomic, readwrite, copy) NSString *supplierSimpleName;
@property (nonatomic, readwrite, assign) NSInteger tempStatus;

@end

@interface ShopOrderModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, assign) NSInteger deposit;
@property (nonatomic, readwrite, assign) NSInteger goodType;
@property (nonatomic, readwrite, assign) BOOL isPay;
@property (nonatomic, readwrite, assign) BOOL isbill;
@property (nonatomic, readwrite, strong) NSNumber *mobile;
@property (nonatomic, readwrite, copy) NSString *dollarRate;
@property (nonatomic, readwrite, strong) NSNumber *orderId;
@property (nonatomic, readwrite, strong) NSNumber *orderNo;
@property (nonatomic, readwrite, strong) NSNumber *orderSx;
@property (nonatomic, readwrite, strong) NSNumber *orderTj;
@property (nonatomic, readwrite, strong) NSNumber *payPrice;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, strong) NSNumber *realPrice;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, assign) NSInteger sendMessageType;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *temp;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, assign) NSInteger wwwType;
@property (nonatomic, readwrite, copy) NSString *wwwUrl;

@end

NS_ASSUME_NONNULL_END
