//
//  StyleCenterViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleCenterViewController.h"
#import "StyleSegmentControl.h"
#import "SideSiftView.h"
#import <YCMenuView.h>

@interface StyleCenterViewController ()

@property (nonatomic, readwrite, strong) StyleCenterViewModel *viewModel;
@property (nonatomic, readwrite, strong) StyleSegmentControl *control;

@end

@implementation StyleCenterViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _setupNavigationItem];
    [self _initSubviewsConstraints];
    
}

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel.designCommand execute:nil];
    
    @weakify(self);
    [self.control.styleSub subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue == 0 || x.integerValue == 4) {
            self.viewModel.orderBy = x.stringValue;
            [self.viewModel.requestRemoteDataCommand execute:@1];
        } else if (x.integerValue == 1) {
            NSNumber *recommendId = @0;
            for (int i = 0; i < self.viewModel.select.recommendList.count; i++) {
                SiftList *list = self.viewModel.select.recommendList[i];
                if ([self.control.categoryBtn.titleLabel.text isEqualToString:list.name]) {
                    recommendId = list.listId;
                    break;
                }
            }
            [self _showPopSelectView:recommendId];
        } else if (x.integerValue == 5) {
            [self _showSideView];
        }
    }];

    [RACObserve(self.viewModel, goodIsNull) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [self showTipView:self.tableView andMessage:@"没有符合的数据" andImgPath:nil andBlock:nil];
        } else {
            [self hiddenTipView];
        }
    }];
}

- (void)_showSideView {
    SideSiftView *siftView = [[SideSiftView alloc] initWithFrame:self.view.bounds type:self.viewModel.type];
    [self.view addSubview:siftView];
    [siftView bindViewModel:self.viewModel];
    siftView.callback = ^(ZGButton *sender) {
        [self _showPriceListView:sender];
    };
    [siftView show];
}

- (void)_showPriceListView:(ZGButton *)btn {
    NSArray *list = @[@"价格段",@"1000-2000",@"2000-3000",@"3000-4000",@"4000-5000",@"5000-6000",@"6000-7000",@"7000-8000",@"8000-9000",@"9000-10000",@"10000-11000"];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < list.count; i++) {
        NSString *title = list[i];
        YCMenuAction *action = [YCMenuAction actionWithTitle:title image:[self.viewModel.priceBtnTitle isEqualToString:title]?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            self.viewModel.priceBtnTitle = title;
            if (i == 0) {
                self.viewModel.priceMin = @"";
                self.viewModel.priceMax = @"";
            } else {
                NSArray *priceArray = [title componentsSeparatedByString:@"-"];
                self.viewModel.priceMin = priceArray.firstObject;
                self.viewModel.priceMax = priceArray.lastObject;
            }
        }];
        [items addObject:action];
    }
    // 创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:200 relyonView:btn];
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.textFont = kFont(15);
    // 显示
    [view show];
}

- (void)didSelectAtIndex:(NSInteger)index {
    SiftList *list;
    for (int i = 0; i < self.viewModel.sideModel.recommendList.count; i++) {
        if (index == i) {
            list = self.viewModel.sideModel.recommendList[i];
            break;
        }
    }
    if (kObjectIsNotNil(list)) {
        self.viewModel.select.recommendList = @[list];
        [self.control.categoryBtn setTitle:list.name forState:UIControlStateNormal];
    } else {
        self.viewModel.select.recommendList = @[];
        [self.control.categoryBtn setTitle:@"专区" forState:UIControlStateNormal];
    }
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)_showPopSelectView:(NSNumber *)listId {
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < self.viewModel.sideModel.recommendList.count; i++) {
        SiftList *list = self.viewModel.sideModel.recommendList[i];
        
        YCMenuAction *action = [YCMenuAction actionWithTitle:list.name image:(listId.integerValue == list.listId.integerValue)?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            [self didSelectAtIndex:i];
        }];
        [items addObject:action];
    }
    if (listId.integerValue != 0) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:@"取消" image:ImageNamed(@"checkbox_nor") handler:^(YCMenuAction *action) {
            [self didSelectAtIndex:items.count-1];
        }];
        [items addObject:action];
    }
    // 创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:140 relyonView:self.control.categoryBtn];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.textFont = kFont(15);
    
    // 显示
    [view show];
}

- (void)_setupSubviews {
    StyleSegmentControl *control = [StyleSegmentControl segmentControl:self.viewModel.type];
    self.control = control;
    [self.view addSubview:control];
}

- (void)_setupNavigationItem {
    if (self.viewModel.type != StyleZT) {
        ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:ImageNamed(@"shop_cart") forState:UIControlStateNormal];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        rightBtn.rac_command = self.viewModel.shopcartCommand;
    }
}

- (void)_initSubviewsConstraints {
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ZGCConvertToPx(44));
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight+ZGCConvertToPx(44), 0, kBottomSpace, 0));
    }];
}

@end
