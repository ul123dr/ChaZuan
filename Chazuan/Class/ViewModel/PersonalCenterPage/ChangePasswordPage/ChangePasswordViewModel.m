//
//  ChangePasswordViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ChangePasswordViewModel.h"
#import "RSAEncryptTool.h"

@interface ChangePasswordViewModel ()

@property (nonatomic, readwrite, copy) NSString *oPassword;
@property (nonatomic, readwrite, copy) NSString *nPassword;
@property (nonatomic, readwrite, copy) NSString *rnPassword;

@property (nonatomic, readwrite, strong) RACCommand *doneCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation ChangePasswordViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    
    @weakify(self);
    self.doneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSString *password = [[NSString alloc] initWithData:[[NSData dataWithHexString:SingleInstance.getPassword] aes256DecryptWithkey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil] encoding:NSUTF8StringEncoding];
        NSString *errorMsg;
        if (kStringIsEmpty(self.oPassword)) errorMsg = @"请输入原密码！";
        else if (![self.oPassword isEqualToString:password]) errorMsg = @"原密码不正确！";
        else if (kStringIsEmpty(self.nPassword)) errorMsg = @"请输入新密码！";
        else if (self.nPassword.length < 6 || self.nPassword.length > 25) errorMsg = @"请输入6-25位字符密码";
        else if (![self.nPassword zgc_isPasswordCharacters]) errorMsg = @"请输入以字母开头字符密码";
        else if (kStringIsEmpty(self.rnPassword)) errorMsg = @"请再次输入新密码！";
        else if (![self.nPassword isEqualToString:self.rnPassword]) errorMsg = @"密码不一致！";
        if (kStringIsNotEmpty(errorMsg)) {
            [SVProgressHUD showInfoWithStatus:errorMsg];
            return [RACSignal empty];
        }
        NSData *passwordData = [[self.nPassword dataUsingEncoding:NSUTF8StringEncoding] aes256EncryptWithKey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
        [SingleInstance setPassword:[passwordData hexString]];
        
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"id"] = [SingleInstance stringForKey:ZGCUserIdKey];
        subscript[@"password"] = [RSAEncryptTool encryptPublicKey:self.nPassword Mod:[SingleInstance stringForKey:ZGCRSAModKey]];
//        [RSAEncryptTool encryptPublicKey:[self.nPassword UTF8String] Mod:[[SingleInstance stringForKey:ZGCRSAModKey] UTF8String] Exp:[@"10001" UTF8String]];
    
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_PASSWORD_UPDATE parameters:subscript.dictionary];
        @weakify(self);
        return [[[self.services.client enqueueParameter:paramters resultClass:User.class] doNext:^(HTTPResponse *response) {
            @strongify(self);
            User *user = response.parsedResult;
            if (user.appCheckCode) {
                [self.services.client loginAtOtherPlace];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                [self.services popViewModelAnimated:YES];
            }
        }] doError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"密码修改失败"];
        }];
    }];
    
    [self _fetchDataSource];
}

- (void)_fetchDataSource {
    // 第一组
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = 30.f;
    PasswordItemViewModel *oldViewModel = [PasswordItemViewModel itemViewModelWithTitle:@"原密码"];
    oldViewModel.placeHolder = @"请输入原密码";
    RAC(self, oPassword) = RACObserve(oldViewModel, password);
    PasswordItemViewModel *newViewModel = [PasswordItemViewModel itemViewModelWithTitle:@"新密码"];
    newViewModel.placeHolder = @"请输入6-25位字符密码";
    RAC(self, nPassword) = RACObserve(newViewModel, password);
    PasswordItemViewModel *renewViewModel = [PasswordItemViewModel itemViewModelWithTitle:@"确认密码"];
    renewViewModel.placeHolder = @"请再次输入新密码";
    RAC(self, rnPassword) = RACObserve(renewViewModel, password);
    
    group1.itemViewModels = @[oldViewModel, newViewModel, renewViewModel];
    
    // 第二组
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.headerHeight = 10.f;
    DoneItemViewModel *doneViewModel = [DoneItemViewModel itemViewModelWithTitle:@"查 询"];
    doneViewModel.doneCommand = self.doneCommand;
    group2.itemViewModels = @[doneViewModel];
    
    self.dataSource = @[group1, group2];
}

@end
