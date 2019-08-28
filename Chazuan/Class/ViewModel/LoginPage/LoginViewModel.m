//
//  LoginViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "LoginViewModel.h"
#import "RSAEncryptTool.h"
#import "LoginStatus.h"
#import "PublicKey.h"

@interface LoginViewModel ()

// 登录命令
@property (nonatomic, readwrite, strong) RACCommand *loginCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation LoginViewModel

- (void)initialize {
    [super initialize];
    
    if ([SingleInstance boolForKey:ZGCIsRememberPwdKey]) {
        if ([SingleInstance stringForKey:ZGCRSAModKey]) {
            self.userName = [[NSString alloc] initWithData:[[NSData dataWithHexString:SingleInstance.getUserName] aes256DecryptWithkey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil] encoding:NSUTF8StringEncoding];
            self.userPassword = [[NSString alloc] initWithData:[[NSData dataWithHexString:SingleInstance.getPassword] aes256DecryptWithkey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil] encoding:NSUTF8StringEncoding];
        }
    }
    self.rememberPwd = [SingleInstance boolForKey:ZGCIsRememberPwdKey];
    self.autoLogin = [SingleInstance boolForKey:ZGCIsAutoLoginKey];
    
    @weakify(self);
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id value) {
        @strongify(self);
        self.error = nil;
        [self.services.client logoutUser];
        
        URLParameters *aesParams = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_AES_PUBLICKEY, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:[KeyedSubscript subscript].dictionary];
        @weakify(self);
        return [[[self.services.client enqueueParameter:aesParams resultClass:PublicKey.class] doNext:^(HTTPResponse *response) {
            @strongify(self);
            PublicKey *key = response.parsedResult;
            [SingleInstance setString:key.temp forKey:ZGCRSAModKey];
            
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"www"] = ServerHttp;
            subscript[@"username"] = self.userName;
            subscript[@"password"] = [RSAEncryptTool encryptPublicKey:self.userPassword Mod:key.temp];
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_DO_LOGIN parameters:subscript.dictionary];
            @weakify(self);
            [[self.services.client enqueueParameter:paramters resultClass:LoginStatus.class] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                LoginStatus *status = response.parsedResult;
                if (status.code == 0) {
                    // 存储账号密码
                    [SingleInstance setBool:self.rememberPwd forKey:ZGCIsRememberPwdKey];
                    [SingleInstance setBool:self.autoLogin forKey:ZGCIsAutoLoginKey];
                    if (self.rememberPwd) {
                        NSData *nameData = [[self.userName dataUsingEncoding:NSUTF8StringEncoding] aes256EncryptWithKey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
                        [SingleInstance setUserName:[nameData hexString]];
                        NSData *passwordData = [[self.userPassword dataUsingEncoding:NSUTF8StringEncoding] aes256EncryptWithKey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
                        [SingleInstance setPassword:[passwordData hexString]];
                    } else {
                        [SingleInstance setBool:NO forKey:ZGCIsAutoLoginKey];
                        [SingleInstance setUserName:nil];
                        [SingleInstance setPassword:nil];
                    }
                    NSArray *data = [status.desc componentsSeparatedByString:@"-"];
                    [SingleInstance setString:validateString(data[0]) forKey:ZGCUserIdKey];
                    [SingleInstance setString:validateString(data[1]) forKey:ZGCUIDKey];
                    [SingleInstance setString:validateString(data[2]) forKey:ZGCSignKey];
//                    [SingleInstance setString:validateString(data[3]) forKey:zgcrap];
                    [SingleInstance setString:validateString(data[4]) forKey:ZGCLevelKey];
                    [SingleInstance setString:validateString(data[5]) forKey:UserSellerIdKey];
                    [SingleInstance setString:validateString(data[6]) forKey:UserBuyerIdKey];
                    [SingleInstance setString:formatWithString(data[8], @"0") forKey:DiamondShowPowerMasterKey];
                    [SingleInstance setString:status.www forKey:ZGCUserWwwKey];
                    
                    NSArray *authorData = [validateString(data[7]) componentsSeparatedByString:@","];
                    [SingleInstance setBool:[authorData[0] boolValue] forKey:AddressShowKey];
                    [SingleInstance setBool:[authorData[1] boolValue] forKey:CertShowKey];
                    [SingleInstance setBool:[authorData[2] boolValue] forKey:RapIdShowKey];
                    [SingleInstance setBool:[authorData[3] boolValue] forKey:RapShowKey];
                    [SingleInstance setBool:[authorData[4] boolValue] forKey:RapBuyShowKey];
                    [SingleInstance setBool:[authorData[5] boolValue] forKey:DiscShowKey];
                    [SingleInstance setBool:[authorData[6] boolValue] forKey:MbgShowKey];
                    [SingleInstance setBool:[authorData[7] boolValue] forKey:BlackShowKey];
                    [SingleInstance setBool:[authorData[8] boolValue] forKey:FancyRapKey];
                    [SingleInstance setBool:[authorData[9] boolValue] forKey:ImgShowKey];
                    [SingleInstance setBool:[authorData[10] boolValue] forKey:DollarShowKey];
                    [SingleInstance setBool:[authorData[11] boolValue] forKey:GoodsNumberShowKey];
                    [SingleInstance setBool:(authorData[12] || 1) forKey:SizeShowKey];
                    [SingleInstance setBool:(authorData[13] || 0) forKey:EyeCleanShowKey];
                    [SingleInstance setBool:(authorData[14] || 0) forKey:DTShowKey];
                    
                    [ZGCNotificationCenter postNotificationName:UserDataConfigureCompleteNotification object:nil userInfo:@{UserDataConfigureCompleteTypeKey:@(YES)}];
                    [self.services popViewModelAnimated:YES];
                } else {
                    [self.services.client logoutUser];
                    self.error = [NSError errorWithDomain:HTTPServiceErrorDomain code:status.code userInfo:@{HTTPServiceErrorDescriptionKey:status.desc}];
                }
            } error:^(NSError *error) {
                @strongify(self);
                self.error = error;
            }];
        }] doError:^(NSError * error) {
            [SVProgressHUD showInfoWithStatus:@"系统繁忙"];
        }];
    }];
}

@end
