//
//  DiamondModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/11.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamondList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *barCode;
@property (nonatomic, readwrite, copy) NSString *designNo;
@property (nonatomic, readwrite, copy) NSString *designTypeCn;
@property (nonatomic, readwrite, copy) NSString *materailTypeCn;
@property (nonatomic, readwrite, strong) NSNumber *materialWeight;
@property (nonatomic, readwrite, strong) NSNumber *size;
@property (nonatomic, readwrite, copy) NSString *typeZCn;
@property (nonatomic, readwrite, strong) NSNumber *weight;
@property (nonatomic, readwrite, copy) NSString *goodsName;
@property (nonatomic, readwrite, copy) NSString *goodsPic;
@property (nonatomic, readwrite, copy) NSString *hand;
@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, copy) NSString *zsmc;
@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, copy) NSString *sideStone;
@property (nonatomic, readwrite, strong) NSNumber *stockNum;
@property (nonatomic, readwrite, strong) NSNumber *orderSx;
@property (nonatomic, readwrite, strong) NSNumber *orderTj;
@property (nonatomic, readwrite, strong) NSNumber *area;
@property (nonatomic, readwrite, strong) NSNumber *designType;
@property (nonatomic, readwrite, strong) NSNumber *type;
@property (nonatomic, readwrite, strong) NSNumber *priceMax;
@property (nonatomic, readwrite, strong) NSNumber *priceMin;
@property (nonatomic, readwrite, copy) NSString *stockPic;
@property (nonatomic, readwrite, strong) NSNumber *typeStone;
@property (nonatomic, readwrite, strong) NSNumber *source;
@property (nonatomic, readwrite, strong) NSNumber *typeXq;
@property (nonatomic, readwrite, copy) NSString *materialPt950;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *designSeries;
@property (nonatomic, readwrite, strong) NSNumber *material18k;
@property (nonatomic, readwrite, assign) BOOL isShow;
@property (nonatomic, readwrite, strong) NSNumber *typeZ;
@property (nonatomic, readwrite, strong) NSNumber *temp6;
@property (nonatomic, readwrite, strong) NSNumber *temp7;
@property (nonatomic, readwrite, strong) NSNumber *temp8;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, copy) NSString *sessionkey;

@property (nonatomic, readwrite, copy) NSString *shopcar;
@property (nonatomic, readwrite, copy) NSString *mRemark;

@end

@interface DiamondModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
//@property (nonatomic, readwrite, strong) ObjectT *objectT;
//@property (nonatomic, readwrite, strong) Page *page;

@end

NS_ASSUME_NONNULL_END
