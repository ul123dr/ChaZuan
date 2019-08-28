//
//  DiamSearchModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamSearchModel : MHObject

@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *detail;
@property (nonatomic, readwrite, copy) NSString *dRef;
@property (nonatomic, readwrite, copy) NSString *addNum;
@property (nonatomic, readwrite, copy) NSString *dollarRate;
@property (nonatomic, readwrite, copy) NSString *sizeMin;
@property (nonatomic, readwrite, copy) NSString *sizeMax;
@property (nonatomic, readwrite, copy) NSString *cert;
@property (nonatomic, readwrite, copy) NSString *shape;
@property (nonatomic, readwrite, copy) NSString *color;
@property (nonatomic, readwrite, copy) NSString *clarity;
@property (nonatomic, readwrite, copy) NSString *cut;
@property (nonatomic, readwrite, copy) NSString *polish;
@property (nonatomic, readwrite, copy) NSString *sym;
@property (nonatomic, readwrite, copy) NSString *milk;
@property (nonatomic, readwrite, copy) NSString *browness;
@property (nonatomic, readwrite, copy) NSString *green;
@property (nonatomic, readwrite, copy) NSString *black;
@property (nonatomic, readwrite, copy) NSString *flour;
@property (nonatomic, readwrite, copy) NSString *location;
@property (nonatomic, readwrite, copy) NSString *status;
@property (nonatomic, readwrite, copy) NSString *strength;
@property (nonatomic, readwrite, copy) NSString *lustre;
@property (nonatomic, readwrite, strong) NSArray *mgb;
@property (nonatomic, readwrite, strong) NSArray *blackChoose;

@end

NS_ASSUME_NONNULL_END
