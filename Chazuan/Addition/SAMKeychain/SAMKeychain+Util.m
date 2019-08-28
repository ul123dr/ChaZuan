//
//  SAMKeychain+Util.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SAMKeychain+Util.h"

/// 登录账号的key
static NSString *const RAW_LOGIN = @"RawLogin";
static NSString *const SERVICE_NAME_IN_KEYCHAIN = @"com.Chazuan";
static NSString *const DEVICEID_ACCOUNT         = @"DeviceID";

@implementation SAMKeychain (Util)
+ (NSString *)rawLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RAW_LOGIN];
}

+ (BOOL)setRawLogin:(NSString *)rawLogin {
    if (rawLogin == nil) NSLog(@"+setRawLogin: %@", rawLogin);
    
    [[NSUserDefaults standardUserDefaults] setObject:rawLogin forKey:RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
+ (BOOL)deleteRawLogin {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


+ (NSString *)deviceId {
    NSString * deviceidStr = [SAMKeychain passwordForService:SERVICE_NAME_IN_KEYCHAIN account:DEVICEID_ACCOUNT];
    if (deviceidStr == nil) {
        deviceidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [SAMKeychain setPassword:deviceidStr forService:SERVICE_NAME_IN_KEYCHAIN account:DEVICEID_ACCOUNT];
    }
    return deviceidStr;
}

@end
