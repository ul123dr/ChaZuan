//
//  CertSearchModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/4.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "Page.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertSearchList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *black;
@property (nonatomic, readwrite, copy) NSString *browness;
@property (nonatomic, readwrite, copy) NSString *cert;
@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *certificate;
@property (nonatomic, readwrite, copy) NSString *clarity;
@property (nonatomic, readwrite, copy) NSString *color;
@property (nonatomic, readwrite, copy) NSString *cut;
@property (nonatomic, readwrite, copy) NSString *location;
@property (nonatomic, readwrite, copy) NSString *m1;
@property (nonatomic, readwrite, copy) NSString *m2;
@property (nonatomic, readwrite, copy) NSString *m3;
@property (nonatomic, readwrite, copy) NSString *polish;
@property (nonatomic, readwrite, copy) NSString *shape;
@property (nonatomic, readwrite, copy) NSString *ref;
@property (nonatomic, readwrite, copy) NSString *flour;
@property (nonatomic, readwrite, copy) NSString *detail;
@property (nonatomic, readwrite, copy) NSString *oldRef;
@property (nonatomic, readwrite, copy) NSString *reportNo;
@property (nonatomic, readwrite, copy) NSString *shapeEn;
@property (nonatomic, readwrite, copy) NSString *sym;
@property (nonatomic, readwrite, copy) NSString *status;
@property (nonatomic, readwrite, copy) NSString *daylight;
@property (nonatomic, readwrite, copy) NSString *disc;
@property (nonatomic, readwrite, copy) NSString *disc1;
@property (nonatomic, readwrite, copy) NSString *green;
@property (nonatomic, readwrite, copy) NSString *locationEn;
@property (nonatomic, readwrite, copy) NSString *rap;
@property (nonatomic, readwrite, copy) NSString *temp;
@property (nonatomic, readwrite, copy) NSString *upFileName;
@property (nonatomic, readwrite, copy) NSString *types;
@property (nonatomic, readwrite, copy) NSString *milky;
@property (nonatomic, readwrite, copy) NSString *depth;
@property (nonatomic, readwrite, copy) NSString *table;
@property (nonatomic, readwrite, strong) NSNumber *size;
@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, assign) BOOL isown;
@property (nonatomic, readwrite, assign) BOOL isOwnFilterStock;
@property (nonatomic, readwrite, strong) NSNumber *insertType;
@property (nonatomic, readwrite, strong) NSNumber *isBgm;
@property (nonatomic, readwrite, strong) NSNumber *isSh;
@property (nonatomic, readwrite, strong) NSNumber *isSizeNormal;
@property (nonatomic, readwrite, strong) NSNumber *isbuy;
@property (nonatomic, readwrite, strong) NSNumber *isdisp;
@property (nonatomic, readwrite, strong) NSNumber *orderBy;
@property (nonatomic, readwrite, strong) NSNumber *orderSx;
@property (nonatomic, readwrite, strong) NSNumber *orderTj;
@property (nonatomic, readwrite, strong) NSNumber *rate;
@property (nonatomic, readwrite, strong) NSNumber *rateAdd;
@property (nonatomic, readwrite, strong) NSNumber *sysStatus;
@property (nonatomic, readwrite, copy) NSString *video;
@property (nonatomic, readwrite, copy) NSString *bc;
@property (nonatomic, readwrite, copy) NSString *bt;
@property (nonatomic, readwrite, copy) NSString *los;
@property (nonatomic, readwrite, copy) NSString *eyeClean;

@end

@interface CertSearchModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) Page *page;

@end

NS_ASSUME_NONNULL_END
