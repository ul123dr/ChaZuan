//
//  StyleSelectView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/29.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleSelectView.h"
#import "StyleDetailViewModel.h"
#import "PopGoodCell.h"

@interface StyleSelectView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readwrite, strong) StyleDetailViewModel *viewModel;

@property (nonatomic, readwrite, strong) UIView *backView;
@property (nonatomic, readwrite, strong) UIView *contentView;
@property (nonatomic, readwrite, strong) UILabel *stoneLabel;
@property (nonatomic, readwrite, strong) UIScrollView *stoneSelectScroll;
@property (nonatomic, readwrite, strong) UILabel *handLabel;
@property (nonatomic, readwrite, strong) UIScrollView *handSelectScroll;
@property (nonatomic, readwrite, strong) UIView *dividerLine;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) UILabel *noneLabel;

@property (nonatomic, readwrite, strong) ZGButton *stoneSelectBtn;
@property (nonatomic, readwrite, strong) ZGButton *handSelectBtn;

@property (nonatomic, readwrite, strong) NSMutableArray *sizeBtnArray;
@property (nonatomic, readwrite, strong) NSMutableArray *handBtnArray;
//@property (nonatomic, readwrite, strong) NSArray *dataList;
//@property (nonatomic, readwrite, strong) NSArray *selectList;

@end

@implementation StyleSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self _setup];
        // 创建控件
        [self _setupSubviews];
        // 控件布局
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)bindViewModel:(StyleDetailViewModel *)viewModel {
    self.viewModel = viewModel;
//    self.dataList = viewModel.detailModel.list;
//    self.selectList = viewModel.selectArray;
    @weakify(self);
    [RACObserve(viewModel, sizeIndex) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue != -1) {
            ZGButton *sizeBtn = self.sizeBtnArray[viewModel.sizeIndex];
            sizeBtn.selected = YES;
            self.stoneSelectBtn = sizeBtn;
        }
        [self _getDataWithSize:x.integerValue hand:self.viewModel.handIndex];
    }];
    [RACObserve(viewModel, handIndex) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue != -1) {
            ZGButton *handBtn = self.handBtnArray[viewModel.handIndex];
            handBtn.selected = YES;
            self.handSelectBtn = handBtn;
        }
        [self _getDataWithSize:self.viewModel.sizeIndex hand:x.integerValue];
    }];
    [RACObserve(viewModel, popDatas) subscribeNext:^(NSArray *data) {
        self.noneLabel.hidden = data.count != 0;
        [self.tableView reloadData];
    }];
}

- (void)_getDataWithSize:(NSInteger)sizeIndex hand:(NSInteger)handIndex {
    NSString *sizeMin, *sizeMax, *hand;
    if (sizeIndex != -1) {
        NSArray *size = [self.stoneSelectBtn.titleLabel.text componentsSeparatedByString:@" "];
        sizeMin = size.firstObject;
        sizeMax = size.lastObject;
    }
    if (handIndex != -1) {
        hand = self.handSelectBtn.titleLabel.text;
    }
    [self.viewModel searchList:sizeMin max:sizeMax hand:hand];
}

- (void)show {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(0, 0, kScreenW, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = CGRectMake(0, kScreenH, kScreenW, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         self.backgroundColor = kHexColorAlpha(@"#000000", 0.5);;
                         [self removeFromSuperview];
                     }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.popDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.type == StyleGoodsList) return ZGCConvertToPx(230);
    else return ZGCConvertToPx(94);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopGoodCell *cell = (PopGoodCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[PopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    StyleDetailList *list = self.viewModel.popDatas[indexPath.row];
    [cell bindModel:self.viewModel.popDatas[indexPath.row] type:self.viewModel.type];
    @weakify(self);
    [[[cell.clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if ([list.status.stringValue zgc_parseInt]==2) {
            [SVProgressHUD showInfoWithStatus:@"借出的现货无法下单！"];
            return;
        }
        self.viewModel.selectArray = [self.viewModel.selectArray?:@[] arrayByAddingObject:list];
        [self dismiss];
    }];
    for (StyleDetailList *selectList in self.viewModel.selectArray) {
        if (selectList.detailId.integerValue == list.detailId.integerValue)
            [cell doSelectCell];
    }
    return cell;
}

- (void)_setup {
    self.sizeBtnArray = [NSMutableArray array];
    self.handBtnArray = [NSMutableArray array];
}

- (void)_setupSubviews {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kHexColorAlpha(@"#000000", 0.5);
    self.backView = backView;
    [self addSubview:backView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [self dismiss];
    }];
    [backView addGestureRecognizer:tapGR];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 8;
    self.contentView = contentView;
    [self addSubview:contentView];
    
    UILabel *stoneLabel = [[UILabel alloc] init];
    stoneLabel.text = @"主石筛选";
    stoneLabel.textColor = kHexColor(@"#020D2C");
    stoneLabel.font = kFont(13);
    self.stoneLabel = stoneLabel;
    [contentView addSubview:stoneLabel];
    
    UIScrollView *stoneSelectScroll = [[UIScrollView alloc] init];
    stoneSelectScroll.showsVerticalScrollIndicator = NO;
    stoneSelectScroll.showsHorizontalScrollIndicator = NO;
    self.stoneSelectScroll = stoneSelectScroll;
    [contentView addSubview:stoneSelectScroll];
    
    UILabel *handLabel = [[UILabel alloc] init];
    handLabel.text = @"选择手寸";
    handLabel.textColor = kHexColor(@"#020D2C");
    handLabel.font = kFont(13);
    self.handLabel = handLabel;
    [contentView addSubview:handLabel];
    
    UIScrollView *handSelectScroll = [[UIScrollView alloc] init];
    handSelectScroll.showsVerticalScrollIndicator = NO;
    handSelectScroll.showsHorizontalScrollIndicator = NO;
    self.handSelectScroll = handSelectScroll;
    [contentView addSubview:handSelectScroll];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [contentView addSubview:dividerLine];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:PopGoodCell.class forCellReuseIdentifier:@"Cell"];
    self.tableView = tableView;
    [contentView addSubview:tableView];
    
    UILabel *noneLabel = [[UILabel alloc] init];
    noneLabel.textAlignment = NSTextAlignmentCenter;
    noneLabel.textColor = kHexColor(@"#020D2C");
    noneLabel.text = @"没有符合的数据";
    noneLabel.font = kFont(14);
    noneLabel.hidden = YES;
    self.noneLabel = noneLabel;
    [contentView addSubview:noneLabel];
    
    [self updateScroll];
}

- (void)updateScroll {
    @weakify(self);
    NSArray *sizeArray = @[@"0.01 - 0.299",@"0.3 - 0.399",@"0.4 - 0.499",@"0.5 - 0.599",@"0.6 - 0.699",@"0.7 - 0.799",@"0.8 - 0.899",@"0.9 - 0.999",@"1.00 - 1.099",@"1.1 - 1.499",@"1.5 - 1.999",@"2.0 - 2.999",@"3.0 - 3.999",@"4.0 - 4.999",@"5.0 - 999"];
    ZGButton *tempSizeBtn;
    for (int i = 0; i < sizeArray.count; i++) {
        NSString *sizeStr = sizeArray[i];
        ZGButton *sizeBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [sizeBtn setTitleColor:kHexColor(@"#020D2C") forState:UIControlStateNormal];
        [sizeBtn setTitle:sizeStr forState:UIControlStateNormal];
        [sizeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [sizeBtn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#F5F6FA")] forState:UIControlStateNormal];
        [sizeBtn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
        [sizeBtn.titleLabel setFont:kFont(13)];
        sizeBtn.clipsToBounds = YES;
        sizeBtn.layer.cornerRadius = ZGCConvertToPx(12);
        sizeBtn.tag = i;
        if (i == 0) self.stoneSelectBtn = sizeBtn;
        [self.stoneSelectScroll addSubview:sizeBtn];
        
        [sizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (tempSizeBtn) make.left.mas_equalTo(tempSizeBtn.mas_right).offset(ZGCConvertToPx(10));
            else make.left.mas_equalTo(self.stoneSelectScroll).offset(ZGCConvertToPx(5));
            make.top.mas_equalTo(self.stoneSelectScroll);
            make.bottom.mas_equalTo(self.stoneSelectScroll.mas_bottom);
            make.height.mas_equalTo(ZGCConvertToPx(24));
            make.width.mas_equalTo(ZGCConvertToPx(90));
            if (i == sizeArray.count-1) make.right.mas_equalTo(self.stoneSelectScroll.mas_right);
        }];
        tempSizeBtn = sizeBtn;
        
        [[sizeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            self.stoneSelectBtn = sender;
            self.viewModel.sizeIndex = sender.selected?sender.tag:-1;
        }];
        [self.sizeBtnArray addObject:sizeBtn];
    }
    NSArray *handArray = @[@"6#",@"7#",@"8#",@"9#",@"10#",@"11#",@"12#",@"13#",@"14#",@"15#",@"16#",@"17#",@"18#",@"19#",@"20#",@"21#",@"22#",@"23#",@"24#",@"25#",@"26#",@"27#",@"28#",@"29#",@"30#",@"31#",@"32#",@"33#"];
    ZGButton *tempHandBtn;
    for (int i = 0; i < handArray.count; i++) {
        NSString *handStr = handArray[i];
        ZGButton *handBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [handBtn setTitleColor:kHexColor(@"#020D2C") forState:UIControlStateNormal];
        [handBtn setTitle:handStr forState:UIControlStateNormal];
        [handBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [handBtn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#F5F6FA")] forState:UIControlStateNormal];
        [handBtn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
        [handBtn.titleLabel setFont:kFont(13)];
        handBtn.clipsToBounds = YES;
        handBtn.layer.cornerRadius = ZGCConvertToPx(12);
        handBtn.tag = i;
        if (i == 0) self.handSelectBtn = handBtn;
        [self.handSelectScroll addSubview:handBtn];
        
        [handBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (tempHandBtn) make.left.mas_equalTo(tempHandBtn.mas_right).offset(ZGCConvertToPx(10));
            else make.left.mas_equalTo(self.handSelectScroll).offset(ZGCConvertToPx(5));
            make.top.mas_equalTo(self.handSelectScroll);
            make.bottom.mas_equalTo(self.handSelectScroll.mas_bottom);
            make.height.mas_equalTo(ZGCConvertToPx(24));
            make.width.mas_equalTo(ZGCConvertToPx(54));
            if (i == handArray.count-1) make.right.mas_equalTo(self.handSelectScroll.mas_right);
        }];
        tempHandBtn = handBtn;
        
        [[handBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            self.handSelectBtn = sender;
            self.viewModel.handIndex = sender.selected?sender.tag:-1;
        }];
        [self.handBtnArray addObject:handBtn];
    }
}

- (void)_setupSubviewsConstraint {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(150)+kNavHeight, 0, 0, 0));
    }];
    [self.stoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(20));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.width.mas_equalTo(ZGCConvertToPx(60));
        make.height.mas_equalTo(ZGCConvertToPx(24));
    }];
    [self.stoneSelectScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(20));
        make.left.mas_equalTo(self.stoneLabel.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(24));
    }];
    [self.handLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stoneLabel.mas_bottom).offset(ZGCConvertToPx(13));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.width.mas_equalTo(ZGCConvertToPx(60));
        make.height.mas_equalTo(ZGCConvertToPx(24));
    }];
    [self.handSelectScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stoneLabel.mas_bottom).offset(ZGCConvertToPx(13));
        make.left.mas_equalTo(self.handLabel.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(24));
    }];
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.handLabel.mas_bottom).offset(ZGCConvertToPx(20));
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(1));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLine.mas_bottom);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kBottomSpace);
    }];
    [self.noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLine.mas_bottom);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(50));
    }];
}

@end
