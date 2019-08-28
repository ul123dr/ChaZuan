//
//  ProfileViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ProfileViewModel.h"

@interface ProfileViewModel ()

@property (nonatomic, readwrite, strong) UserList *userInfo;

@end

@implementation ProfileViewModel

- (void)initialize {
    [super initialize];
    
    if (self.services.client.currentUser.list.count == 0) {
        [self.requestRemoteDataCommand execute:nil];
    } else {
        self.dataSource = [self _fetchPersonData];
    }
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        CommonItemViewModel *itemViewModel = self.dataSource[indexPath.row];
        if (itemViewModel.operation) {
            itemViewModel.operation();
        } else if (itemViewModel.destViewModelClass) {
            Class viewModelClass = itemViewModel.destViewModelClass;
            NSString *text;
            if ([itemViewModel isKindOfClass:AvatarItemViewModel.class]) text = ((AvatarItemViewModel*)itemViewModel).avatar;
            else text = itemViewModel.subTitle;
            NSString *placeholder = @"请输入信息";
            if ([itemViewModel.title isEqualToString:@"手机号"]) {
                placeholder = @"请输入手机号";
            } else if ([itemViewModel.title isEqualToString:@"联系人"]) {
                placeholder = @"请输入联系人姓名";
            } else if ([itemViewModel.title isEqualToString:@"公司名称"]) {
                placeholder = @"请输入公司名称";
            }
            BaseViewModel *viewModel = [[viewModelClass alloc] initWithServices:self.services params:@{ViewModelTitleKey:itemViewModel.title,ViewModelUtilKey:text,ViewModelTypeKey:placeholder}];
            @weakify(self);
            __block CommonItemViewModel *blockViewModel = itemViewModel;
            viewModel.callback = ^(id text) {
                @strongify(self);
                if ([blockViewModel.title isEqualToString:@"头像"]) {
                    self.userInfo.avatar = text;
                    User *user = self.services.client.currentUser;
                    user.list = @[self.userInfo];
                    [self.services.client saveUser:user];
                } else if ([blockViewModel.title isEqualToString:@"手机号"]) {
                    self.userInfo.mobile = text;
                    User *user = self.services.client.currentUser;
                    user.list = @[self.userInfo];
                    [self.services.client saveUser:user];
                } else if ([blockViewModel.title isEqualToString:@"联系人"]) {
                    self.userInfo.realname = text;
                    User *user = self.services.client.currentUser;
                    user.list = @[self.userInfo];
                    [self.services.client saveUser:user];
                } else if ([blockViewModel.title isEqualToString:@"公司名称"]) {
                    SharedAppDelegate.manager.company = text;
                }
            };
            [self.services pushViewModel:viewModel animated:YES];
        } else {}
        return [RACSignal empty];
    }];
}

- (NSArray *)_fetchPersonData {
    self.userInfo = self.services.client.currentUser.list[0];
    AvatarItemViewModel *avatarViewModel = [AvatarItemViewModel itemViewModelWithTitle:@"头像"];
    RAC(avatarViewModel, avatar) = [RACObserve(self.userInfo, avatar) map:^id(NSString *avatar) {
        if (kStringIsNotEmpty(avatar)) return [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], avatar];
        else return @"personal_msg_03";
    }];
    avatarViewModel.rowHeight = ZGCConvertToPx(88);
    avatarViewModel.shouldHideDisclosureIndicator = YES;
    avatarViewModel.destViewModelClass = ChangeProfileViewModel.class;
    CommonItemViewModel *accountViewModel = [CommonItemViewModel itemViewModelWithTitle:@"账号"];
    accountViewModel.subTitle = [[NSString alloc] initWithData:[[NSData dataWithHexString:SingleInstance.getUserName] aes256DecryptWithkey:[@"1234567812345678" dataUsingEncoding:NSUTF8StringEncoding] iv:nil] encoding:NSUTF8StringEncoding];
    accountViewModel.cellStyle = UITableViewCellStyleValue1;
    accountViewModel.subColor = kHexColor(@"#1C2B36");
    CommonItemViewModel *phoneViewModel = [CommonItemViewModel itemViewModelWithTitle:@"手机号"];
    RAC(phoneViewModel, subTitle) = RACObserve(self.userInfo, mobile);
    phoneViewModel.shouldHideDisclosureIndicator = NO;
    phoneViewModel.cellStyle = UITableViewCellStyleValue1;
    phoneViewModel.subColor = kHexColor(@"#1C2B36");
    phoneViewModel.destViewModelClass = ChangeProfileViewModel.class;
    CommonItemViewModel *contactViewModel = [CommonItemViewModel itemViewModelWithTitle:@"联系人"];
    RAC(contactViewModel, subTitle) = RACObserve(self.userInfo, realname);
    contactViewModel.shouldHideDisclosureIndicator = NO;
    contactViewModel.cellStyle = UITableViewCellStyleValue1;
    contactViewModel.subColor = kHexColor(@"#1C2B36");
    contactViewModel.destViewModelClass = ChangeProfileViewModel.class;
    CommonItemViewModel *companyViewModel = [CommonItemViewModel itemViewModelWithTitle:@"公司名称"];
    RAC(companyViewModel, subTitle) = RACObserve(SharedAppDelegate.manager, company);
    companyViewModel.shouldHideDisclosureIndicator = NO;
    companyViewModel.cellStyle = UITableViewCellStyleValue1;
    companyViewModel.subColor = kHexColor(@"#1C2B36");
    companyViewModel.destViewModelClass = ChangeProfileViewModel.class;
    return @[avatarViewModel, accountViewModel, phoneViewModel, contactViewModel, companyViewModel];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_CONTACT_INFO parameters:subscript.dictionary];
    @weakify(self);
    return [[[self.services.client enqueueParameter:paramters resultClass:User.class] doNext:^(HTTPResponse *response) {
        @strongify(self);
        User *user = response.parsedResult;
        if (user.appCheckCode) {
            [self.services.client loginAtOtherPlace];
        } else {
            user.sign = [SingleInstance stringForKey:ZGCSignKey];
            [self.services.client loginUser:user];
            self.dataSource = [self _fetchPersonData];
        }
    }] doError:^(NSError *error) {
        @strongify(self);
        [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
        [self.services popViewModelAnimated:YES];
    }];
}

@end
