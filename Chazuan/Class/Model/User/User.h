//
//  User.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserList : MHObject

@property (nonatomic, readwrite, copy) NSString *sessionkey;
@property (nonatomic, readwrite, copy) NSString *weixin;
@property (nonatomic, readwrite, copy) NSString *diamondShowPower; 
@property (nonatomic, readwrite, assign) NSInteger ownLogoNum; 
@property (nonatomic, readwrite, assign) NSInteger sex;
@property (nonatomic, readwrite, assign) NSInteger loginTimes;
@property (nonatomic, readwrite, copy) NSString *realname;
@property (nonatomic, readwrite, strong) NSNumber *listId; 
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, copy) NSString *mobile;
@property (nonatomic, readwrite, strong) NSNumber *qq;
@property (nonatomic, readwrite, copy) NSString *avatar;
@property (nonatomic, readwrite, copy) NSString *lastdate;
@property (nonatomic, readwrite, copy) NSString *lastip;
@property (nonatomic, readwrite, copy) NSString *caredate;
@property (nonatomic, readwrite, copy) NSString *bday;
@property (nonatomic, readwrite, assign) NSInteger isOwnLogo;
@property (nonatomic, readwrite, assign) BOOL isExport;
@property (nonatomic, readwrite, copy) NSString *isOwnLogoDateEnd;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;

//{"groupby_double_add":"","groupby_rate_discount":"","salesmen_pow":"0,0","sign":"","sessionkey":""}

@end

@interface User : MHObject

@property (nonatomic, readwrite, strong) NSNumber *userId; //id
@property (nonatomic, readwrite, assign) NSInteger userLevel; 
@property (nonatomic, readwrite, assign) NSInteger userType;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password; // 562D1847DD2C0C6C180FE3F95A7A08F6
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *ripId;
@property (nonatomic, readwrite, copy) NSString *regdate;
@property (nonatomic, readwrite, copy) NSString *regip;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, assign) NSInteger pcormobile;
@property (nonatomic, readwrite, copy) NSString *zocaiCode;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, assign) NSInteger gid;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *sessionkey;

@end

NS_ASSUME_NONNULL_END
