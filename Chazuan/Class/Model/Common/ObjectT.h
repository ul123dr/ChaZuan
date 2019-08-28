//
//  ObjectT.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjectT : MHObject

@property (nonatomic, readwrite, assign) NSInteger appCheckCode;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, copy) NSString *sessionkey;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
