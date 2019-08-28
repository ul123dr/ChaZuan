//
//  AccountRoleModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "Page.h"
#import "ObjectT.h"
#import "Role.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountRoleModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) ObjectT *objectT;
@property (nonatomic, readwrite, strong) Page *page;
@property (nonatomic, readwrite, strong) NSArray *list;

@end

NS_ASSUME_NONNULL_END
