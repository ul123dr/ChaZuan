//
//  StyleDetailList.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleDetailList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSNumber *detailId;
@property (nonatomic, readwrite, copy) NSString *barCode;
@property (nonatomic, readwrite, copy) NSString *cert;
@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *createTime;
@property (nonatomic, readwrite, copy) NSString *designNo;
@property (nonatomic, readwrite, copy) NSString *dHand;
@property (nonatomic, readwrite, copy) NSString *materialCn;
@property (nonatomic, readwrite, strong) NSNumber *materialWeight;
@property (nonatomic, readwrite, strong) NSNumber *size;
@property (nonatomic, readwrite, copy) NSString *sizeShapeCn;
@property (nonatomic, readwrite, copy) NSString *sizeShapeLevel;
@property (nonatomic, readwrite, strong) NSNumber *weight;
@property (nonatomic, readwrite, assign) BOOL isDelete;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *sellTime;
@property (nonatomic, readwrite, copy) NSString *sideStoneNum;
@property (nonatomic, readwrite, copy) NSString *sideStoneRemark;
@property (nonatomic, readwrite, strong) NSNumber *sideStoneSize;
@property (nonatomic, readwrite, strong) NSNumber *status;
@property (nonatomic, readwrite, copy) NSString *temp1;
@property (nonatomic, readwrite, copy) NSString *temp2;
@property (nonatomic, readwrite, copy) NSString *temp3;
@property (nonatomic, readwrite, copy) NSString *temp4;
@property (nonatomic, readwrite, copy) NSString *temp5;
@property (nonatomic, readwrite, copy) NSString *temp6;
@property (nonatomic, readwrite, copy) NSString *hand;
@property (nonatomic, readwrite, copy) NSString *designTypeCn;
@property (nonatomic, readwrite, copy) NSString *materialTypeCn;
@property (nonatomic, readwrite, copy) NSString *typeZCn;
@property (nonatomic, readwrite, strong) NSArray *goodsPic;
@property (nonatomic, readwrite, strong) NSNumber *orderSx;
@property (nonatomic, readwrite, strong) NSNumber *orderTj;
@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, strong) NSNumber *sId;
@property (nonatomic, readwrite, copy) NSString *sideStone;
@property (nonatomic, readwrite, strong) NSNumber *stockNum;
@property (nonatomic, readwrite, copy) NSString *zsmc;
@property (nonatomic, readwrite, copy) NSString *sizeTypeCn;

@property (nonatomic, readwrite, copy) NSString *shopcar;
@property (nonatomic, readwrite, copy) NSString *mRemark;

@end

NS_ASSUME_NONNULL_END
