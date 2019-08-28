//
//  SearchView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchView.h"
#import "AccountViewModel.h"

@interface SearchView ()<UITextFieldDelegate>

@property (nonatomic, readwrite, strong) AccountViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIView *contentView;
@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, strong) UITextField *textField;

@end

@implementation SearchView

+ (instancetype)searchView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self _setup];
        // 创建控件
        [self _setupSubviews];
        // 控件布局
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)bindViewModel:(AccountViewModel *)viewModel {
    _viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(viewModel, searchType) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue == 1) [self.selectBtn setTitle:@"账号" forState:UIControlStateNormal];
        else if (x.integerValue == 2) [self.selectBtn setTitle:@"姓名" forState:UIControlStateNormal];
        else [self.selectBtn setTitle:@"手机" forState:UIControlStateNormal];
    }];
    RACChannelTo(viewModel, searchText) = self.textField.rac_newTextChannel;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.viewModel.searchCommand execute:nil];
    return YES;
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = COLOR_BG;
}

- (void)_setupSubviews {
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = ZGCConvertToPx(16);
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = UIColor.whiteColor;
    self.contentView = contentView;
    [self addSubview:contentView];
    
    ZGButton *selectBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitle:@"账号" forState:UIControlStateNormal];
    [selectBtn setImage:ImageNamed(@"select_bottom") forState:UIControlStateNormal];
    [selectBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:kFont(13)];
    selectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -ZGCConvertToPx(32), 0, ZGCConvertToPx(32))];
    [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(ZGCConvertToPx(15.5), ZGCConvertToPx(68), ZGCConvertToPx(15.5), ZGCConvertToPx(19))];
    self.selectBtn = selectBtn;
    [contentView addSubview:selectBtn];

    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"快速搜索...";
    textField.font = kFont(14);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    self.textField = textField;
    [contentView addSubview:textField];
    
    @weakify(self);
    [[selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.searchTypeSub sendNext:nil];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(15), ZGCConvertToPx(12.5), 0, ZGCConvertToPx(12.5)));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right);
        make.top.right.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.selectBtn).multipliedBy(2.5);
    }];
}

@end
