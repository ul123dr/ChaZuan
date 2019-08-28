//
//  ContactInfoViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ContactInfoViewModel.h"

@interface ContactInfoViewModel ()

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation ContactInfoViewModel

- (void)initialize {
    [super initialize];
    
    if (self.services.client.currentUser.list.count == 0) {
        [self.requestRemoteDataCommand execute:nil];
    } else {
        self.dataSource = [self _fetchPersonData];
    }
}

- (NSArray *)_fetchPersonData {
    UserList *userInfo = self.services.client.currentUser.list[0];
    ContactItemViewModel *nameViewModel = [ContactItemViewModel itemViewModelWithTitle:@"姓名"];
    nameViewModel.subTitle = userInfo.realname;
    ContactItemViewModel *sexViewModel = [ContactItemViewModel itemViewModelWithTitle:@"性别"];
    sexViewModel.subTitle = userInfo.sex==1?@"男":@"女";
    ContactItemViewModel *phoneViewModel = [ContactItemViewModel itemViewModelWithTitle:@"联系电话"];
    phoneViewModel.subTitle = userInfo.mobile;
    ContactItemViewModel *qqViewModel = [ContactItemViewModel itemViewModelWithTitle:@"QQ"];
    qqViewModel.subTitle = userInfo.qq.stringValue;
    ContactItemViewModel *wechatViewModel = [ContactItemViewModel itemViewModelWithTitle:@"微信"];
    wechatViewModel.subTitle = userInfo.weixin;
    ContactItemViewModel *mailViewModel = [ContactItemViewModel itemViewModelWithTitle:@"邮箱"];
    mailViewModel.subTitle = userInfo.email;
    return @[nameViewModel, sexViewModel, phoneViewModel, qqViewModel, wechatViewModel, mailViewModel];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    self.error = nil;
    
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
        [self.services popViewModelAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
    }];
}

@end
