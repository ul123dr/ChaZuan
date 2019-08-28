//
//  SAMKeychain+Util.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SAMKeychain.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAMKeychain (Util)

+ (NSString *)rawLogin ;

+ (BOOL)setRawLogin:(NSString *)rawLogin ;

+ (BOOL)deleteRawLogin;

/// 设备ID or UUID
+ (NSString *)deviceId;

@end

NS_ASSUME_NONNULL_END
