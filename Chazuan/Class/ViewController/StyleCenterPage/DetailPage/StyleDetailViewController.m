//
//  StyleDetailViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleDetailViewController.h"
#import "StyleBottomView.h"
#import "TableViewFooterView.h"
#import "PGDatePickManager.h"
#import <YCMenuView.h>
#import "StyleHeaderView.h"
#import "StyleFooterView.h"
#import "StyleSelectView.h"

@interface StyleDetailViewController ()<PGDatePickerDelegate>

@property (nonatomic, readwrite, strong) StyleDetailViewModel *viewModel;
@property (nonatomic, readwrite, strong) StyleBottomView *bottomView;

@end

@implementation StyleDetailViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _initSubviewsConstraints];
    
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
//    [self.viewModel.picClickSub subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        NSMutableArray *items = [NSMutableArray new];
//
//        CGFloat count = self.viewModel.picInfos.count;
//        for (NSUInteger i = 0; i < count; i++) {
//            UIView *imgView = self.subviews[i];
//            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//            item.thumbView = imgView;
//            item.largeImageURL = meta.url;
//            item.largeImageSize = CGSizeMake(meta.width, meta.height);
//            [items addObject:item];
//        }
//        YYPhotoGroupView *photoBrowser = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//        [photoBrowser presentFromImageView:sender.view toContainer:self.window animated:YES completion:NULL];
//    }];
    
    [self.viewModel.selectSub subscribeNext:^(RACTuple *x) {
        @strongify(self);
        [self _showPopSelectView:x];
    }];
    
    [self.viewModel.dateSub subscribeNext:^(id input) {
        @strongify(self);
        [self _showDateSelectView];
    }];
    
    [self.viewModel.showGoodSub subscribeNext:^(NSArray *selectArray) {
        @strongify(self);
        [self _showGoodSelectView];
    }];
    
    // hud
    [self.viewModel.cartCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    [self.viewModel.orderCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    [self.viewModel.designCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
}

- (void)_showGoodSelectView {
    StyleSelectView *selectView = [[StyleSelectView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:selectView];
    [selectView bindViewModel:self.viewModel];
    [selectView show];
}

- (void)_showDateSelectView {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyleAlertBottomButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.language = @"zh-Hans";
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.datePickerMode = PGDatePickerModeDate;
    if (kStringIsNotEmpty(self.viewModel.add.date)) [datePicker setDate:[NSDate dateWithString:self.viewModel.add.date format:@"yyyy/MM/dd"]];
    [self presentViewController:datePickManager animated:false completion:nil];
    
    // 自定义收起动画逻辑
    datePickManager.customDismissAnimation = ^NSTimeInterval(UIView *dismissView, UIView *contentView) {
        NSTimeInterval duration = 0.3f;
        [UIView animateWithDuration:duration animations:^{
            contentView.frame = (CGRect){{contentView.frame.origin.x, CGRectGetMaxY(self.view.bounds)}, contentView.bounds.size};
        } completion:^(BOOL finished) {
        }];
        return duration;
    };
}

- (void)_showPopSelectView:(RACTuple *)x {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *str in self.viewModel.popArray) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:str image:[x.first isEqualToString:str]?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            switch (self.viewModel.index) {
                case 0:
                    self.viewModel.add.size = str;
                    break;
                case 1:
                    self.viewModel.add.tabs = str;
                    break;
                case 2:
                    self.viewModel.add.handsize = str;
                    break;
                default:
                    break;
            }
        }];
        [items addObject:action];
    }
    CGPoint point = [self.view convertPoint:CGPointFromString(x.third) fromView:(UITableViewCell*)(x.second)];
    // 创建YCMenuView(根据关联点或者关联视图)
    //        YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:140 relyonView:sender];
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:self.viewModel.index==2?180:140 atPoint:point];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.offset = ZGCConvertToPx(22); // 关联点和弹出视图的偏移距离
    view.textFont = kFont(15);
    
    // 显示
    [view show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2 && self.viewModel.selectArray.count > 0) {
        StyleHeaderView *headerView = [StyleHeaderView headerWithTableView:tableView];
        GoodInfoGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        [headerView bindViewModel:groupViewModel];
        return headerView;
    }
    TableViewHeaderView *headerView = [TableViewHeaderView headerWithTableView:tableView];
    CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [headerView bindViewModel:groupViewModel];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2 && self.viewModel.selectArray.count > 0) {
        StyleFooterView *footerView = [StyleFooterView footerWithTableView:tableView];
        GoodInfoGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        [footerView bindViewModel:groupViewModel];
        return footerView;
    }
    TableViewFooterView *footerView = [TableViewFooterView footerWithTableView:tableView];
    CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [footerView bindViewModel:groupViewModel];
    return footerView;
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *today = [NSDate date];
    NSString *todayStr = [formatter stringFromDate:today];
    today = [NSDate dateWithString:todayStr format:@"yyyy/MM/dd"];
    NSDate *date = [NSDate setYear:dateComponents.year month:dateComponents.month day:dateComponents.day hour:0 minute:0];
    if (date.timeIntervalSince1970 < today.timeIntervalSince1970)
        [SVProgressHUD showInfoWithStatus:@"出货日期不能小于下单日期"];
    else
        self.viewModel.add.date = [formatter stringFromDate:date];
}

- (void)_setupSubviews {
    StyleBottomView *bottomView = [[StyleBottomView alloc] initWithType:self.viewModel.type];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    @weakify(self);
    if (self.viewModel.type != StyleZT) {
        bottomView.homeBtn.rac_command = self.viewModel.homeCommand;
//        bottomView.addCartBtn.rac_command = self.viewModel.cartCommand;
        [[bottomView.addCartBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            [self.viewModel.cartCommand execute:@0];
        }];
    }
//    bottomView.orderBtn.rac_command = self.viewModel.orderCommand;
    [[bottomView.orderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.orderCommand execute:@0];
    }];
    
    self.tableView.backgroundColor = UIColor.whiteColor;
}

- (void)_initSubviewsConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kBottomHeight, 0));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomSpace);
    }];
}

@end
