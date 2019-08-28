//
//  ShopCartList.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "CartTxt.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartList : MHObject

@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, assign) NSInteger goodType;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, strong) NSNumber *goodId;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *sessionkey;
@property (nonatomic, readwrite, copy) CartTxt *cartTxt;
@property (nonatomic, readwrite, assign) NSInteger wwwType;
@property (nonatomic, readwrite, copy) NSString *createDate;
@property (nonatomic, readwrite, copy) NSString *updateTime;
@property (nonatomic, readwrite, assign) NSInteger sysStatus;
@property (nonatomic, readwrite, strong) NSNumber *price;

@end

NS_ASSUME_NONNULL_END
