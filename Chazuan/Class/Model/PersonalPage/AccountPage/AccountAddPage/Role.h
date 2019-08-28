//
//  Role.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Role : MHObject

@property (nonatomic, readwrite, assign) BOOL isTrueRef;
@property (nonatomic, readwrite, copy) NSString *createTime;
@property (nonatomic, readwrite, assign) BOOL isEyeClean;
@property (nonatomic, readwrite, assign) NSInteger goodType;
@property (nonatomic, readwrite, assign) BOOL isBgm;
@property (nonatomic, readwrite, assign) BOOL isColorRap;
@property (nonatomic, readwrite, assign) BOOL isDetail;
@property (nonatomic, readwrite, copy) NSString *roleName;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, assign) BOOL isBlack;
@property (nonatomic, readwrite, strong) NSNumber *roleId;
@property (nonatomic, readwrite, assign) BOOL isDT;
@property (nonatomic, readwrite, assign) BOOL isRegion;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, assign) BOOL isDollarRate;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, assign) BOOL isDaylight;
@property (nonatomic, readwrite, assign) BOOL isRap;
@property (nonatomic, readwrite, assign) BOOL isDollar;
@property (nonatomic, readwrite, assign) BOOL isDisc;
@property (nonatomic, readwrite, assign) BOOL isCertNo;
@property (nonatomic, readwrite, assign) BOOL isMeasurements;

@end

NS_ASSUME_NONNULL_END
