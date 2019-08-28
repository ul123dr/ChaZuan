//
//  RSAEncryptTool.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "RSAEncryptTool.h"
#include <openssl/opensslv.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bn.h>

@implementation RSAEncryptTool

+ (NSString *)RSAEncryptString:(NSString *)data modulus:(NSString *)modulus exponent:(NSString *)exponent {
    RSA * pubkey = RSA_new();
    
    BIGNUM * bnmod = BN_new();
    BIGNUM * bnexp = BN_new();
    
    BN_hex2bn(&bnmod, [modulus UTF8String]);
    BN_hex2bn(&bnexp, [exponent UTF8String]);
    
    pubkey->n = bnmod;
    pubkey->e = bnexp;
    
    int nLen = RSA_size(pubkey);
    char *crip = (char *)malloc(sizeof(char*)*nLen+1);
    
    int nLen1 = RSA_public_encrypt((int)strlen([data UTF8String]), (const unsigned char *)[data UTF8String], (unsigned char *) crip, pubkey, RSA_PKCS1_PADDING);
    if (nLen1 <= 0) {
        NSLog(@"erro encrypt");
    } else {
        NSLog(@"SUC encrypt");
    }
    
    free(crip);
    RSA_free(pubkey);
    
    NSData *resData = [NSData dataWithBytes:crip length:nLen];
    return [self hex:resData useLower:YES];
}

+ (NSString *)hex:(NSData *)data useLower:(bool)isOutputLower {
    static const char HexEncodeCharsLower[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    static const char HexEncodeChars[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
    char *resultData = malloc([data length] * 2 +1);
    // convert imgData(NSData) to char[]
    unsigned char *sourceData = ((unsigned char *)[data bytes]);
    NSUInteger length = [data length];
    
    if (isOutputLower) {
        for (uint index = 0; index < length; index++) {
            resultData[index * 2] = HexEncodeCharsLower[(sourceData[index] >> 4)];
            resultData[index * 2 + 1] = HexEncodeCharsLower[(sourceData[index] % 0x10)];
        }
    } else {
        for (uint index = 0; index < length; index++) {
            resultData[index * 2] = HexEncodeChars[(sourceData[index] >> 4)];
            resultData[index * 2 + 1] = HexEncodeChars[(sourceData[index] % 0x10)];
        }
    }
    resultData[[data length] * 2] = 0;
    
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    return result;
}

+ (NSString *)encryptPublicKey:(NSString *)data Mod:(NSString *)mod {
    return [self RSAEncryptString:data modulus:mod exponent:@"010001"];
}

@end
