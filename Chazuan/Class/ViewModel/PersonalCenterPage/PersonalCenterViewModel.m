//
//  PersonalCenterViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PersonalCenterViewModel.h"

@interface PersonalCenterViewModel ()

@property (nonatomic, readwrite, strong) RACCommand *logoutCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation PersonalCenterViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    
    @weakify(self);
    self.logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.error = nil;
        
        Alert(@"确定要退出登录吗？", @"取消", @"确定", ^(BOOL action) {
            if (action) {
                [self.services.client logoutUser];
                [self.services popViewModelAnimated:YES];
            }
        });
        return [RACSignal empty];
    }];
    
    // 选中 cell 命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        if (indexPath.section == 0) {
            CommonGroupViewModel *groupViewModel = self.dataSource[indexPath.section];
            CommonItemViewModel *itemViewModel = groupViewModel.itemViewModels[indexPath.row];
            
            if (itemViewModel.operation) {
                itemViewModel.operation();
            } else if (itemViewModel.destViewModelClass) {
                Class viewModelClass = itemViewModel.destViewModelClass;
                BaseViewModel *viewModel = [[viewModelClass alloc] initWithServices:self.services params:@{ViewModelTitleKey:itemViewModel.title}];
                [self.services pushViewModel:viewModel animated:YES];
            } else {}
        }
        return [RACSignal empty];
    }];
    
    if (self.services.client.currentUser.list.count == 0) {
        [self.requestRemoteDataCommand execute:nil];
    } else {
        self.dataSource = @[[self _fetchPersonData], [self _fetchLogoutData]];
    }
}

- (CommonGroupViewModel *)_fetchPersonData {
    UserList *userInfo = self.services.client.currentUser.list[0];
    
    CommonGroupViewModel *groupViewModel = [CommonGroupViewModel groupViewModel];
    groupViewModel.headerHeight = 10.f;
    groupViewModel.footerHeight = 30.f;
    
    PersonalItemViewModel *personViewMdoel = [PersonalItemViewModel itemViewModelWithTitle:userInfo.realname icon:[userInfo.avatar hasPrefix:@"http"]?userInfo.avatar:[NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], userInfo.avatar]];
    personViewMdoel.cellStyle = UITableViewCellStyleSubtitle;
    personViewMdoel.subTitle = [SingleInstance getRoleName:self.services.client.currentUser.userType];
    personViewMdoel.rowHeight = ZGCConvertToPx(88);
    personViewMdoel.destViewModelClass = ProfileViewModel.class;
    personViewMdoel.shouldHideDisclosureIndicator = NO;
    CommonItemViewModel *accountViewModel = [CommonItemViewModel itemViewModelWithTitle:@"账户管理"];
    accountViewModel.shouldHideDisclosureIndicator = NO;
    accountViewModel.destViewModelClass = AccountViewModel.class;
    CommonItemViewModel *changePwdViewModel = [CommonItemViewModel itemViewModelWithTitle:@"修改密码"];
    changePwdViewModel.shouldHideDisclosureIndicator = NO;
    changePwdViewModel.destViewModelClass = ChangePasswordViewModel.class;
    CommonItemViewModel *noteViewModel = [CommonItemViewModel itemViewModelWithTitle:@"消息通知"];
    noteViewModel.shouldHideDisclosureIndicator = NO;
    noteViewModel.destViewModelClass = NoteViewModel.class;
    CommonItemViewModel *contactViewModel = [CommonItemViewModel itemViewModelWithTitle:@"联系信息"];
    contactViewModel.shouldHideDisclosureIndicator = NO;
    contactViewModel.destViewModelClass = ContactInfoViewModel.class;
    CommonItemViewModel *levelRateViewModel = [CommonItemViewModel itemViewModelWithTitle:@"等级折扣"];
    levelRateViewModel.shouldHideDisclosureIndicator = NO;
    levelRateViewModel.destViewModelClass = VipRateViewModel.class;
    CommonItemViewModel *serverViewModel = [CommonItemViewModel itemViewModelWithTitle:@"版本信息"];
    serverViewModel.cellStyle = UITableViewCellStyleValue1;
    serverViewModel.shouldHideDisclosureIndicator = YES;
    serverViewModel.subTitle = @"1.0.0";
    CommonItemViewModel *settingViewModel = [CommonItemViewModel itemViewModelWithTitle:@"设置"];
    settingViewModel.shouldHideDisclosureIndicator = NO;
    settingViewModel.destViewModelClass = SettingViewModel.class;
    CommonItemViewModel *qrcodeViewModel = [CommonItemViewModel itemViewModelWithTitle:@"推广二维码"];
    qrcodeViewModel.shouldHideDisclosureIndicator = NO;
    qrcodeViewModel.destViewModelClass = QRCodeViewModel.class;
    
    groupViewModel.itemViewModels = @[personViewMdoel, accountViewModel, changePwdViewModel, noteViewModel, contactViewModel, levelRateViewModel, serverViewModel, settingViewModel, qrcodeViewModel];
    
    return groupViewModel;
}

- (CommonGroupViewModel *)_fetchLogoutData {
    CommonGroupViewModel *groupViewModel = [CommonGroupViewModel groupViewModel];
    groupViewModel.headerHeight = 10.f;
    DoneItemViewModel *doneViewModel = [DoneItemViewModel itemViewModelWithTitle:@"退出"];
    doneViewModel.doneCommand = self.logoutCommand;
    groupViewModel.itemViewModels = @[doneViewModel];
    return groupViewModel;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
    subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
    subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
    subscript[@"id"] = [SingleInstance stringForKey:ZGCUserIdKey];
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_USER_INFO parameters:subscript.dictionary];
    @weakify(self);
    return [[[self.services.client enqueueParameter:paramters resultClass:User.class] doNext:^(HTTPResponse *response) {
        @strongify(self);
        User *user = response.parsedResult;
        if (user.appCheckCode) {
            [self.services.client logoutUser];
            [self.services popViewModelAnimated:YES];
        } else {
            user.sign = [SingleInstance stringForKey:ZGCSignKey];
            [self.services.client loginUser:user];
            self.dataSource = @[[self _fetchPersonData], [self _fetchLogoutData]];
        }
    }] doError:^(NSError *error) {
        @strongify(self);
        [self.services popViewModelAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
    }];
}

@end
