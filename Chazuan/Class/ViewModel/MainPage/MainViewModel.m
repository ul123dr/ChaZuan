//
//  MainViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MainViewModel.h"

#import "CalculatorViewModel.h"
#import "ShopCartViewModel.h"

@interface MainViewModel ()

@property (nonatomic, readwrite, strong) RACSubject *funcClickSub;
@property (nonatomic, readwrite, strong) RACCommand *shopCartCommand;
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;

@end

@implementation MainViewModel

- (void)initialize {
    [super initialize];
    self.title = @"首页";
    self.shouldMultiSections = YES;
    self.funcClickSub = [RACSubject subject];
    
    self.dataSource = @[[self _fetchCycleData],[self _fetchFuncData]];
    
    @weakify(self);
    [[RACObserve(SharedAppDelegate, manager) ignore:nil] subscribeNext:^(ManagerSpecialty *manager) {
        @strongify(self);
        if ([SingleInstance boolForKey:ZGCIsLoginKey])
            self.dataSource = @[[self _fetchLoginCycleData:manager], [self _fetchFuncData]];
        else
            self.dataSource = @[[self _fetchCycleData],[self _fetchFuncData]];
    }];
    
    [self.funcClickSub subscribeNext:^(RACTuple *x) {
        @strongify(self);
        BaseViewModel *viewModel = [[(Class)x.first alloc] initWithServices:self.services params:@{ViewModelTitleKey:x.second}];
        [self.services pushViewModel:viewModel animated:YES];
    }];
    
    self.shopCartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        BaseViewModel *viewModel;
        if (![SingleInstance boolForKey:ZGCIsLoginKey]) {
            viewModel = [[LoginViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"登录"}];
        } else {
            viewModel = [[ShopCartViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"我的购物车"}];
        }
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        BaseViewModel *viewModel;
        if (![SingleInstance boolForKey:ZGCIsLoginKey]) {
            viewModel = [[LoginViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"登录"}];
        } else {
            viewModel = [[SearchViewModel alloc] initWithServices:self.services params:@{ViewModelTypeKey:@1}];
        }
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

#pragma mark - 辅助方法
- (CommonGroupViewModel *)_fetchLoginCycleData:(ManagerSpecialty *)manager {
    CommonGroupViewModel *groupViewModel = [CommonGroupViewModel groupViewModel];
    if (kStringIsNotEmpty(manager.indexLogo)) {
        NSArray *imgs = [manager.indexLogo componentsSeparatedByString:@","];
        if (imgs.count > 3 && kStringIsNotEmpty(validateString(imgs[3]))) {
            NSMutableArray *models = [NSMutableArray array];
            for (NSString *imgurl in [imgs[3] componentsSeparatedByString:@";"]) {
                CycleCollectionModel *model = [[CycleCollectionModel alloc] init];
                if ([imgurl hasPrefix:@"http"]) model.imgUrl = imgurl;
                else model.imgUrl = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], imgurl];
                [models addObject:model];
            }
            if (models.count > 0) {
                BannerItemViewModel *viewModel = [[BannerItemViewModel alloc] initWithModel:[models copy]];
                viewModel.rowHeight = ZGCConvertToPx(228);
                groupViewModel.itemViewModels = @[viewModel];
            }
        }
    }
    return groupViewModel;
}

- (CommonGroupViewModel *)_fetchCycleData {
    CommonGroupViewModel *groupViewModel = [CommonGroupViewModel groupViewModel];
    
    CycleCollectionModel *model1 = [[CycleCollectionModel alloc] init];
    model1.imgUrl = @"banner1_20170907";
    CycleCollectionModel *model2 = [[CycleCollectionModel alloc] init];
    model2.imgUrl = @"banner2_20170907";
    
    BannerItemViewModel *viewModel = [[BannerItemViewModel alloc] initWithModel:@[model1,model2]];
    viewModel.rowHeight = ZGCConvertToPx(228);
    
    groupViewModel.itemViewModels = @[viewModel];
    return groupViewModel;
}

- (CommonGroupViewModel *)_fetchFuncData {
    CommonGroupViewModel *groupViewModel = [CommonGroupViewModel groupViewModel];
    // 第一排
    MainItemViewModel *viewModel1 = [[MainItemViewModel alloc] initWithIcon:@[@"home_diam",@"home_fancyDiam",@"home_cert"] name:@[@"白钻查询",@"彩钻查询",@"证书查询"] login:@[@(YES),@(YES),@(NO)] destClass:@[DiamSearchViewModel.class,FancySearchViewModel.class,CertSearchViewModel.class]];
    viewModel1.destViewModelClass = LoginViewModel.class;
    viewModel1.funcClickSub = self.funcClickSub;
    viewModel1.rowHeight = kScreenW/3.0;
    
    // 第二排
    MainItemViewModel *viewModel2, *viewModel3;
    if ([SingleInstance boolForKey:ZGCIsLoginKey] && SharedAppDelegate.manager.isSourceType == 2) {
       viewModel2 = [[MainItemViewModel alloc] initWithIcon:@[@"home_style",@"home_goods",@"home_style"] name:@[@"在线板房",@"成品现货",@"找托商城"] login:@[@(YES),@(YES),@(YES)] destClass:@[StyleCenterViewModel.class,StyleCenterViewModel.class,StyleCenterViewModel.class]];
        viewModel2.destViewModelClass = LoginViewModel.class;
        viewModel2.funcClickSub = self.funcClickSub;
        viewModel2.rowHeight = kScreenW/3.0;
        
        viewModel3 = [[MainItemViewModel alloc] initWithIcon:@[@"home_count",@"home_order",@"home_person"] name:@[@"计算器",@"订单中心",@"个人中心"] login:@[@(NO),@(YES),@(YES)] destClass:@[CalculatorViewModel.class,OrderCenterViewModel.class,PersonalCenterViewModel.class]];
        viewModel3.destViewModelClass = LoginViewModel.class;
        viewModel3.funcClickSub = self.funcClickSub;
        viewModel3.rowHeight = kScreenW/3.0;
        
        MainItemViewModel *viewModel4 = [[MainItemViewModel alloc] initWithIcon:@[@"home_more"] name:@[@"期待更多"] login:@[@(NO),@(NO),@(NO)] destClass:@[]];
        viewModel4.destViewModelClass = LoginViewModel.class;
        viewModel4.funcClickSub = self.funcClickSub;
        viewModel4.rowHeight = kScreenW/3.0;
        
        groupViewModel.itemViewModels = @[viewModel1,viewModel2,viewModel3, viewModel4];
    } else {
        viewModel2 = [[MainItemViewModel alloc] initWithIcon:@[@"home_style",@"home_goods",@"home_count"] name:@[@"在线板房",@"成品现货",@"计算器"] login:@[@(YES),@(YES),@(NO)] destClass:@[StyleCenterViewModel.class,StyleCenterViewModel.class,CalculatorViewModel.class]];
        viewModel2.destViewModelClass = LoginViewModel.class;
        viewModel2.funcClickSub = self.funcClickSub;
        viewModel2.rowHeight = kScreenW/3.0;
        
        viewModel3 = [[MainItemViewModel alloc] initWithIcon:@[@"home_order",@"home_person",@"home_more"] name:@[@"订单中心",@"个人中心",@"期待更多"] login:@[@(YES),@(YES),@(NO)] destClass:@[OrderCenterViewModel.class,PersonalCenterViewModel.class]];
        viewModel3.destViewModelClass = LoginViewModel.class;
        viewModel3.funcClickSub = self.funcClickSub;
        viewModel3.rowHeight = kScreenW/3.0;
        
        groupViewModel.itemViewModels = @[viewModel1,viewModel2,viewModel3];
    }
    
    return groupViewModel;
}

@end
