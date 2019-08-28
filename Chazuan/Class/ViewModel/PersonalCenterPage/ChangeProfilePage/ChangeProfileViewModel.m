//
//  ChangeProfileViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ChangeProfileViewModel.h"
#import "ObjectT.h"
#import "LoginStatus.h"
#import "UploadFile.h"

@interface ChangeProfileViewModel ()

@property (nonatomic, readwrite, copy) NSString *textTitle;
@property (nonatomic, readwrite, copy) NSString *text;
@property (nonatomic, readwrite, copy) NSString *placeHolder;
@property (nonatomic, readwrite, copy) NSString *changeValue;

@property (nonatomic, readwrite, strong) RACCommand *saveCommand;
@property (nonatomic, readwrite, strong) RACSubject *photoSub;
@property (nonatomic, readwrite, strong) RACSubject *uploadSub;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation ChangeProfileViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.textTitle = self.params[ViewModelTitleKey];
    self.text = self.params[ViewModelUtilKey];
    self.placeHolder = self.params[ViewModelTypeKey];
    self.title = @"个人信息修改";
    self.photoSub = [RACSubject subject];
    self.uploadSub = [RACSubject subject];
    
    @weakify(self);
    self.saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([self _checkCanSave]) {
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            NSString *path;
            subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            if ([self.textTitle isEqualToString:@"手机号"]) {
                subscript[@"param"] = self.changeValue;
                subscript[@"validateName"] = @"mobile";
                URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:[NSString stringWithFormat:@"%@%ld", POST_VILADE_MOBILE, (long)(NSDate.date.timeIntervalSince1970*1000)] parameters:subscript.dictionary];
                return [self _changeMobile:paramters];
            } else if ([self.textTitle isEqualToString:@"联系人"] || [self.textTitle isEqualToString:@"头像"]) {
                subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                subscript[@"id"] = [SingleInstance stringForKey:ZGCUserIdKey];
                subscript[@"user_type"] = @(self.services.client.currentUser.userType).stringValue;
                if ([self.textTitle isEqualToString:@"头像"]) {
                    subscript[@"temp"] = [NSString stringWithFormat:@"[{\"avatar\":\"%@\"}]", self.changeValue];
                } else {
                    subscript[@"temp"] = [NSString stringWithFormat:@"[{\"realname\":\"%@\"}]", self.changeValue];
                }
                path = POST_UPDATE_USER;
            } else if ([self.textTitle isEqualToString:@"公司名称"]) {
                subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
                subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
                subscript[@"id"] = [SingleInstance stringForKey:ZGCManagerIdKey];
                subscript[@"company"] = self.changeValue;
                path = POST_UPDATE_COMPANY;
            }
            if (kStringIsNotEmpty(path)) {
                URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:path parameters:subscript.dictionary];
                return [self _changeProfile:paramters];
            }
        }
        return [RACSignal empty];
    }];

    [self.uploadSub subscribeNext:^(UIImage *image) {
        @strongify(self);
        NSData *data = UIImageJPEGRepresentation(image, 0.7);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        @weakify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"formFile"] = encodedImageStr;
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_IMAGE_UPLOAD parameters:subscript.dictionary];
        [[self.services.client enqueueParameter:paramters resultClass:UploadFile.class] subscribeNext:^(HTTPResponse *response) {
            @strongify(self);
            UploadFile *file = response.parsedResult;
            self.text = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], file.path];
            self.changeValue = file.path;
            ZGCLog(@"fullPath: %@ path: %@", self.text, self.changeValue);
        } error:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"出错了"];
        }];
    }];
    
    [self _fetchDataSource];
}

- (RACSignal *)_changeProfile:(URLParameters *)paramters {
    @weakify(self);
    return [[[[self.services.client enqueueParameter:paramters resultClass:ObjectT.class] takeUntil:self.rac_willDeallocSignal] doNext:^(HTTPResponse *response) {
        @strongify(self);
        self.callback(self.changeValue);
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [SVProgressHUD dismissWithDelay:1.2 completion:^{
            [self.services popViewModelAnimated:YES];
        }];
    }] doError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"出错了"];
    }];
}

- (RACSignal *)_changeMobile:(URLParameters *)paramters {
    @weakify(self);
    return [[[[self.services.client enqueueParameter:paramters resultClass:LoginStatus.class] takeUntil:self.rac_willDeallocSignal] doNext:^(HTTPResponse *response) {
        @strongify(self);
        LoginStatus *status = response.parsedResult;
        if (status.code == 0) {
            KeyedSubscript *subScript = [KeyedSubscript subscript];
            subScript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            subScript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
            subScript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
            subScript[@"id"] = [SingleInstance stringForKey:ZGCUserIdKey];
            subScript[@"user_type"] = @(self.services.client.currentUser.userType).stringValue;
            subScript[@"temp"] = [NSString stringWithFormat:@"[{\"mobile\":\"%@\"}]", self.text];
            
            URLParameters *subParamters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_UPDATE_USER parameters:subScript.dictionary];
            @weakify(self);
            [[[self.services.client enqueueParameter:subParamters resultClass:ObjectT.class] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                self.callback(self.changeValue);
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [SVProgressHUD dismissWithDelay:1.2 completion:^{
                    [self.services popViewModelAnimated:YES];
                }];
            } error:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"出错了"];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:status.desc];
        }
    }] doError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"验证失败"];
    }];
}

- (BOOL)_checkCanSave {
    NSString *msg;
    if ([self.textTitle isEqualToString:@"头像"]) {
        if (kStringIsEmpty(self.changeValue)) msg = @"请先选择图片";
    } else if ([self.textTitle isEqualToString:@"手机号"]) {
        if (kStringIsEmpty(self.changeValue)) msg = @"请输入您的手机号码";
        if ([self.changeValue isEqualToString:self.text]) msg = @"输入号码没有改变";
        if (![self.changeValue zgc_isValidMobile]) msg = @"手机号码格式不正确";
    } else if ([self.textTitle isEqualToString:@"联系人"]) {
        if (kStringIsEmpty(self.changeValue)) msg = @"请输入您的姓名";
    } else if ([self.textTitle isEqualToString:@"公司名称"]) {
        if (kStringIsEmpty(self.changeValue)) msg = @"请先输入您的公司名称";
    }
    if (kStringIsNotEmpty(msg)) {
        [SVProgressHUD showInfoWithStatus:msg];
        return NO;
    }
    return YES;
}

- (void)_fetchDataSource {
    // 第一组
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = 30.f;
    if ([self.textTitle isEqualToString:@"头像"]) {
        AvatarItemViewModel *viewModel = [AvatarItemViewModel itemViewModelWithTitle:self.textTitle];
        RAC(viewModel, avatar) = RACObserve(self, text);
        viewModel.rowHeight = ZGCConvertToPx(88);
        viewModel.shouldHideDisclosureIndicator = NO;
        @weakify(self);
        viewModel.operation = ^{
            @strongify(self);
            // 访问相册
            [self.photoSub sendNext:nil];
        };
        group1.itemViewModels = @[viewModel];
    } else {
        ChangeProfileItemViewModel *viewModel = [ChangeProfileItemViewModel itemViewModelWithTitle:self.textTitle];
        RAC(self, changeValue) = RACObserve(viewModel, value);
        viewModel.value = self.text;
        viewModel.placeHolder = self.placeHolder;
        group1.itemViewModels = @[viewModel];
    }
    // 第二组
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.headerHeight = 10.f;
    DoneItemViewModel *doneViewModel = [DoneItemViewModel itemViewModelWithTitle:@"保 存"];
    doneViewModel.doneCommand = self.saveCommand;
    group2.itemViewModels = @[doneViewModel];
    
    self.dataSource = @[group1, group2];
}

@end
