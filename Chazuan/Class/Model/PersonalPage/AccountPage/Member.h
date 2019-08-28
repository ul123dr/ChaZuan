//
//  Member.h
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Member : MHObject

@property (nonatomic, readwrite, assign) NSInteger userLevel;
@property (nonatomic, readwrite, assign) NSInteger userType;
@property (nonatomic, readwrite, copy) NSString *regip;
@property (nonatomic, readwrite, strong) NSNumber *memberId;
@property (nonatomic, readwrite, strong) NSNumber *loginTimes;
@property (nonatomic, readwrite, copy) NSString *company;
@property (nonatomic, readwrite, copy) NSString *regdate;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, strong) NSNumber *rateDoubleLzColor;
@property (nonatomic, readwrite, copy) NSString *groupbyRateDiscount;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *ownLogo;
@property (nonatomic, readwrite, copy) NSString *realname;
@property (nonatomic, readwrite, strong) NSNumber *rateDoubleLz;
@property (nonatomic, readwrite, strong) NSNumber *gid;
@property (nonatomic, readwrite, strong) NSNumber *rateDouble;
@property (nonatomic, readwrite, strong) NSNumber *rateDiscount;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, copy) NSString *diamondShowPower;
@property (nonatomic, readwrite, strong) NSNumber *sex;
@property (nonatomic, readwrite, strong) NSNumber *puid;
@property (nonatomic, readwrite, copy) NSString *bday;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *lastip;
@property (nonatomic, readwrite, copy) NSString *zocaiCode;
@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *mobile;
@property (nonatomic, readwrite, strong) NSNumber *pcormobile;
@property (nonatomic, readwrite, copy) NSString *salesmenPow;
@property (nonatomic, readwrite, strong) NSNumber *userTypeLevel;
@property (nonatomic, readwrite, copy) NSString *caredate;
@property (nonatomic, readwrite, copy) NSString *lastdate;
@property (nonatomic, readwrite, strong) NSNumber *qq;
@property (nonatomic, readwrite, strong) NSNumber *rateDoubleZt;
@property (nonatomic, readwrite, strong) NSNumber *ownLogoNum;
@property (nonatomic, readwrite, copy) NSString *groupbyDoubleAdd;
@property (nonatomic, readwrite, copy) NSString *isOwnLogoDateEnd;
@property (nonatomic, readwrite, copy) NSString *plusDateEnd;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, strong) NSNumber *isOwnLogo;
@property (nonatomic, readwrite, strong) NSNumber *isExport;
@property (nonatomic, readwrite, copy) NSString *salesmenName;
@property (nonatomic, readwrite, copy) NSString *area;
@property (nonatomic, readwrite, copy) NSString *avatar;
@property (nonatomic, readwrite, strong) NSNumber *salesmenId;
@property (nonatomic, readwrite, strong) NSNumber *buyerId;
@property (nonatomic, readwrite, strong) NSString *addressDetail;
@property (nonatomic, readwrite, strong) NSString *recommender;


@end

NS_ASSUME_NONNULL_END
