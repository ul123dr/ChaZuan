//
//  CartTxt.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartTxt : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSNumber *txtId;
@property (nonatomic, readwrite, copy) NSString *shape;
@property (nonatomic, readwrite, strong) NSNumber *size;
@property (nonatomic, readwrite, copy) NSString *color;
@property (nonatomic, readwrite, copy) NSString *color1;
@property (nonatomic, readwrite, copy) NSString *color2;
@property (nonatomic, readwrite, copy) NSString *ceo;
@property (nonatomic, readwrite, copy) NSString *clarity;
@property (nonatomic, readwrite, copy) NSString *cut;
@property (nonatomic, readwrite, copy) NSString *polish;
@property (nonatomic, readwrite, copy) NSString *sym;
@property (nonatomic, readwrite, copy) NSString *flour;
@property (nonatomic, readwrite, copy) NSString *m1;
@property (nonatomic, readwrite, strong) NSNumber *depth;
@property (nonatomic, readwrite, strong) NSNumber *table;
@property (nonatomic, readwrite, copy) NSString *ref;
@property (nonatomic, readwrite, copy) NSString *reportNo;
@property (nonatomic, readwrite, copy) NSString *detail;
@property (nonatomic, readwrite, strong) NSNumber *disc;
@property (nonatomic, readwrite, strong) NSNumber *rate;
@property (nonatomic, readwrite, copy) NSString *location;
@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *milky;
@property (nonatomic, readwrite, copy) NSString *browness;
@property (nonatomic, readwrite, assign) BOOL isbuy;
@property (nonatomic, readwrite, copy) NSString *los;
@property (nonatomic, readwrite, assign) BOOL isdisp;
@property (nonatomic, readwrite, copy) NSString *cert; 
@property (nonatomic, readwrite, copy) NSString *types;
@property (nonatomic, readwrite, copy) NSString *locationEn;
@property (nonatomic, readwrite, assign) BOOL isown;
@property (nonatomic, readwrite, copy) NSString *designNo;
@property (nonatomic, readwrite, copy) NSString *designTypeCn;
@property (nonatomic, readwrite, copy) NSString *barCode;
@property (nonatomic, readwrite, copy) NSString *material;
@property (nonatomic, readwrite, copy) NSString *dHand;
@property (nonatomic, readwrite, copy) NSString *weight;
@property (nonatomic, readwrite, copy) NSString *materialWeight;
@property (nonatomic, readwrite, copy) NSString *sizeType;
@property (nonatomic, readwrite, copy) NSString *sizeShape;
@property (nonatomic, readwrite, copy) NSString *sizeShapeLevel;
@property (nonatomic, readwrite, copy) NSString *stoneNum;
@property (nonatomic, readwrite, assign) double stoneSize;
@property (nonatomic, readwrite, copy) NSString *stoneRemark;
@property (nonatomic, readwrite, copy) NSString *styleNo;
@property (nonatomic, readwrite, copy) NSString *caizhi;
@property (nonatomic, readwrite, copy) NSString *hand;
@property (nonatomic, readwrite, copy) NSString *mark;
@property (nonatomic, readwrite, copy) NSString *date;
@property (nonatomic, readwrite, copy) NSString *kezi;
@property (nonatomic, readwrite, copy) NSString *num;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, copy) NSString *temp1;
@property (nonatomic, readwrite, copy) NSString *temp2;
@property (nonatomic, readwrite, copy) NSString *temp3;
@property (nonatomic, readwrite, copy) NSString *temp4;
@property (nonatomic, readwrite, copy) NSString *shopcar;
@property (nonatomic, readwrite, assign) NSInteger source;
@property (nonatomic, readwrite, strong) NSNumber *price;

@end

NS_ASSUME_NONNULL_END
