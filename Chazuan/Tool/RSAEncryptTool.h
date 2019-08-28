//
//  RSAEncryptTool.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSAEncryptTool : NSObject

+ (NSString *)encryptPublicKey:(NSString *)data Mod:(NSString *)mod;

@end

NS_ASSUME_NONNULL_END
