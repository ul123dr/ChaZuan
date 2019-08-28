//
//  OtherLoginModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogList : MHObject

@property (nonatomic, readwrite, copy) NSString *loginDate;
@property (nonatomic, readwrite, copy) NSString *loginIp;

@end

@interface OtherLoginModel : MHObject

@property (nonatomic, readwrite, strong) NSArray *list;

@end

NS_ASSUME_NONNULL_END
