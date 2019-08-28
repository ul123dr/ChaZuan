//
//  DiamResultList.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamResultList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *rate1;
@property (nonatomic, readwrite, copy) NSString *rap;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *reportNo;
@property (nonatomic, readwrite, copy) NSString *browness;
@property (nonatomic, readwrite, strong) NSNumber *orderSx;
@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, assign) BOOL isown;
@property (nonatomic, readwrite, strong) NSNumber *isSizeNormal;
@property (nonatomic, readwrite, copy) NSString *video;
@property (nonatomic, readwrite, copy) NSString *girdle;
@property (nonatomic, readwrite, copy) NSString *upFileName;
@property (nonatomic, readwrite, copy) NSString *locationEn;
@property (nonatomic, readwrite, copy) NSString *disc;
@property (nonatomic, readwrite, copy) NSString *bc;
@property (nonatomic, readwrite, strong) NSNumber *totalPage;
@property (nonatomic, readwrite, copy) NSString *shapeEn;
@property (nonatomic, readwrite, strong) NSNumber *insertType;
@property (nonatomic, readwrite, assign) BOOL isOwnFilterStock;
@property (nonatomic, readwrite, copy) NSString *types;
@property (nonatomic, readwrite, copy) NSString *flour;
@property (nonatomic, readwrite, strong) NSNumber *isdisp;
@property (nonatomic, readwrite, strong) NSNumber *sysStatus;
@property (nonatomic, readwrite, copy) NSString *wt;
@property (nonatomic, readwrite, copy) NSString *location;
@property (nonatomic, readwrite, copy) NSString *los;
@property (nonatomic, readwrite, copy) NSString *dRef;
@property (nonatomic, readwrite, copy) NSString *updateTime;
@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *temp;
@property (nonatomic, readwrite, copy) NSString *color;
@property (nonatomic, readwrite, copy) NSString *polish;
@property (nonatomic, readwrite, copy) NSString *m1;
@property (nonatomic, readwrite, copy) NSString *m2;
@property (nonatomic, readwrite, copy) NSString *m3;
@property (nonatomic, readwrite, copy) NSString *green;
@property (nonatomic, readwrite, strong) NSNumber *totalRecord;
@property (nonatomic, readwrite, copy) NSString *sym;
@property (nonatomic, readwrite, copy) NSString *eyeClean;
@property (nonatomic, readwrite, strong) NSNumber *countRate;
@property (nonatomic, readwrite, copy) NSString *dDepth;
@property (nonatomic, readwrite, copy) NSString *disc1;
@property (nonatomic, readwrite, copy) NSString *milky;
@property (nonatomic, readwrite, copy) NSString *cert;
@property (nonatomic, readwrite, strong) NSNumber *currentPage;
@property (nonatomic, readwrite, copy) NSString *sessionkey;
@property (nonatomic, readwrite, copy) NSString *wc;
@property (nonatomic, readwrite, copy) NSString *daylight;
@property (nonatomic, readwrite, strong) NSNumber *dSize;
@property (nonatomic, readwrite, copy) NSString *oldRef;
@property (nonatomic, readwrite, copy) NSString *clarity;
@property (nonatomic, readwrite, strong) NSNumber *rate;
@property (nonatomic, readwrite, strong) NSNumber *orderTj;
@property (nonatomic, readwrite, strong) NSNumber *pageSize;
@property (nonatomic, readwrite, copy) NSString *shape;
@property (nonatomic, readwrite, copy) NSString *disc2;
@property (nonatomic, readwrite, copy) NSString *dTable;
@property (nonatomic, readwrite, copy) NSString *bt;
@property (nonatomic, readwrite, strong) NSNumber *orderBy;
@property (nonatomic, readwrite, copy) NSString *detail;
@property (nonatomic, readwrite, strong) NSNumber *isbuy;
@property (nonatomic, readwrite, strong) NSNumber *isSh;
@property (nonatomic, readwrite, strong) NSNumber *rateAdd;
@property (nonatomic, readwrite, copy) NSString *cut;
@property (nonatomic, readwrite, strong) NSNumber *isBgm;
@property (nonatomic, readwrite, copy) NSString *num;
@property (nonatomic, readwrite, copy) NSString *dollarRate;

@end

NS_ASSUME_NONNULL_END
