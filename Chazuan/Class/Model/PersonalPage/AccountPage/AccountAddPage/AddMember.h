//
//  AddMember.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddMember : MHObject

@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *realname;
@property (nonatomic, readwrite, copy) NSString *mobile;
@property (nonatomic, readwrite, strong) NSNumber *seller;
@property (nonatomic, readwrite, strong) NSNumber *buyer;
@property (nonatomic, readwrite, assign) NSInteger level; // user_level
@property (nonatomic, readwrite, assign) NSInteger userType;
@property (nonatomic, readwrite, assign) BOOL areaShow;
@property (nonatomic, readwrite, assign) BOOL certshow;
@property (nonatomic, readwrite, assign) BOOL detailshow;
@property (nonatomic, readwrite, assign) BOOL rapshow;
@property (nonatomic, readwrite, assign) BOOL rapBuyshow;
@property (nonatomic, readwrite, assign) BOOL discshow;
@property (nonatomic, readwrite, assign) BOOL mbgshow;
@property (nonatomic, readwrite, assign) BOOL blackshow;
@property (nonatomic, readwrite, assign) BOOL fancyRapshow;
@property (nonatomic, readwrite, assign) BOOL imgShow;
@property (nonatomic, readwrite, assign) BOOL dollarShow;
@property (nonatomic, readwrite, assign) BOOL realGoodsNumberShow; // realGoodsNumber_show
@property (nonatomic, readwrite, assign) BOOL sizeShow;
@property (nonatomic, readwrite, assign) BOOL isEyeCleanShow;
@property (nonatomic, readwrite, assign) BOOL isDTShow;
@property (nonatomic, readwrite, strong) NSString *disc;
@property (nonatomic, readwrite, strong) NSString *white;
@property (nonatomic, readwrite, strong) NSString *fancy;
@property (nonatomic, readwrite, strong) NSString *rateDouble;
@property (nonatomic, readwrite, strong) NSString *rateDoubleZt;
@property (nonatomic, readwrite, assign) BOOL isExport;
@property (nonatomic, readwrite, strong) NSNumber *fromList;
@property (nonatomic, readwrite, strong) NSNumber *fromRole;
@property (nonatomic, readwrite, strong) NSString *recommender;

@property (nonatomic, readwrite, assign) NSInteger roleSelect;
@property (nonatomic, readwrite, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
