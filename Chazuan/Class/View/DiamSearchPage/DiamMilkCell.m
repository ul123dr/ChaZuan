//
//  DiamMilkCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamMilkCell.h"

@interface DiamMilkCell ()

/// viewModel
@property (nonatomic, readwrite, strong) MilkItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *milkArr;
@property (nonatomic, readwrite, strong) NSMutableArray *milkBtns;

@property (nonatomic, readwrite, strong) NSArray *blackArr;
@property (nonatomic, readwrite, strong) NSMutableArray *blackBtns;

@property (nonatomic, readwrite, strong) UILabel *milkLabel;
@property (nonatomic, readwrite, strong) UILabel *blackLabel;

@end

@implementation DiamMilkCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DiamMilkCell";
    DiamMilkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(MilkItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    if ([SingleInstance boolForKey:MbgShowKey]) {
        [[RACObserve(viewModel, milkSelectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
            @strongify(self);
            NSMutableArray *titleArr = [NSMutableArray arrayWithArray:[viewModel.milkSelectTitle componentsSeparatedByString:@"，"]];
            [titleArr removeLastObject];
            for (int i = 0; i < selectArr.count; i++) {
                BOOL select = [selectArr[i] boolValue];
                ZGButton *btn = self.milkBtns[i];
                btn.selected = select;
                // 处理title
                NSString *name = self.milkArr[i];
                if (select) {
                    if (![titleArr containsObject:name])
                        [titleArr addObject:name];
                } else {
                    if ([titleArr containsObject:name])
                        [titleArr removeObject:name];
                }
            }
            if (titleArr.count > 0)
                viewModel.milkSelectTitle = [[titleArr componentsJoinedByString:@"，"] stringByAppendingString:@"，"];
            else
                viewModel.milkSelectTitle = @"";
        }];
    }
    if ([SingleInstance boolForKey:BlackShowKey]) {
        [[RACObserve(viewModel, blackSelectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
            @strongify(self);
            NSMutableArray *titleArr = [NSMutableArray arrayWithArray:[viewModel.blackSelectTitle componentsSeparatedByString:@"，"]];
            [titleArr removeLastObject];
            for (int i = 0; i < selectArr.count; i++) {
                BOOL select = [selectArr[i] boolValue];
                ZGButton *btn = self.blackBtns[i];
                btn.selected = select;
                // 处理title
                NSString *name = self.blackArr[i];
                if (select) {
                    if (![titleArr containsObject:name])
                        [titleArr addObject:name];
                } else {
                    if ([titleArr containsObject:name])
                        [titleArr removeObject:name];
                }
            }
            if (titleArr.count > 0)
                viewModel.blackSelectTitle = [[titleArr componentsJoinedByString:@"，"] stringByAppendingString:@"，"];
            else
                viewModel.blackSelectTitle = @"";
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 辅助方法
- (void)_setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.milkArr = @[@"无奶咖",@"无奶",@"无咖",@"待查"];
    self.milkBtns = [NSMutableArray array];
    self.blackArr = @[@"无黑",@"待查"];
    self.blackBtns = [NSMutableArray array];
}

- (void)_setupSubviews {
    if ([SingleInstance boolForKey:MbgShowKey]) {
        UILabel *milkLabel = [[UILabel alloc] init];
        milkLabel.font = kFont(15);
        milkLabel.textColor = kHexColor(@"#1C2B36");
        milkLabel.text = @"奶咖绿";
        self.milkLabel = milkLabel;
        [self.contentView addSubview:milkLabel];
        
        for (int i = 0; i < self.milkArr.count; i++) {
            ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
            btn.layer.borderColor = COLOR_LINE.CGColor;
            btn.layer.borderWidth = 1;
            [btn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            [btn.titleLabel setFont:kFont(14)];
            [btn setTitle:self.milkArr[i] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
            [self.milkBtns addObject:btn];
            
            @weakify(self);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
                @strongify(self);
                sender.selected = !sender.selected;
                [self.viewModel.milkClickSub sendNext:[RACTuple tupleWithObjects:@(i),@(sender.selected), nil]];
            }];
        }
    }
    
    if ([SingleInstance boolForKey:BlackShowKey]) {
        UILabel *blackLabel = [[UILabel alloc] init];
        blackLabel.font = kFont(15);
        blackLabel.textColor = kHexColor(@"#1C2B36");
        blackLabel.text = @"黑点";
        self.blackLabel = blackLabel;
        [self.contentView addSubview:blackLabel];
        
        for (int i = 0; i < self.blackArr.count; i++) {
            ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
            btn.layer.borderColor = COLOR_LINE.CGColor;
            btn.layer.borderWidth = 1;
            [btn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            [btn.titleLabel setFont:kFont(14)];
            [btn setTitle:self.blackArr[i] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
            [self.blackBtns addObject:btn];
            
            @weakify(self);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
                @strongify(self);
                sender.selected = !sender.selected;
                [self.viewModel.blackClickSub sendNext:[RACTuple tupleWithObjects:@(i),@(sender.selected), nil]];
            }];
        }
    }
}

- (void)_setupSubviewsConstraint {
    if ([SingleInstance boolForKey:MbgShowKey]) {
        [self.milkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.width.mas_equalTo(ZGCConvertToPx(73));
            if (![SingleInstance boolForKey:BlackShowKey])
                make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        ZGButton *tempBtn;
        for (int i = 0; i < self.milkBtns.count; i++) {
            ZGButton *btn = self.milkBtns[i];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i%5 == 0) {
                    make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(83));
                } else {
                    make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(10));
                }
                make.top.mas_equalTo(self.milkLabel).offset(ZGCConvertToPx(6));
                make.bottom.mas_equalTo(self.milkLabel.mas_bottom).offset(ZGCConvertToPx(-6));
                if (i == 3) make.right.mas_equalTo(self.contentView.mas_right).offset(-kScreenW/5.0+ZGCConvertToPx(33/5.0));
                if (tempBtn) make.size.mas_equalTo(tempBtn);
            }];
            tempBtn = btn;
        }
    }
    if ([SingleInstance boolForKey:BlackShowKey]) {
        [self.blackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.milkLabel) {
                make.top.mas_equalTo(self.milkLabel.mas_bottom);
                make.height.mas_equalTo(self.milkLabel);
            } else {
                make.top.mas_equalTo(self.contentView);
            }
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.width.mas_equalTo(ZGCConvertToPx(73));
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        ZGButton *tempBlackBtn;
        for (int i = 0; i < self.blackBtns.count; i++) {
            ZGButton *btn = self.blackBtns[i];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i%3 == 0) {
                    make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(83));
                } else {
                    make.left.mas_equalTo(tempBlackBtn.mas_right).offset(ZGCConvertToPx(10));
                }
                make.top.mas_equalTo(self.blackLabel).offset(ZGCConvertToPx(6));
                make.bottom.mas_equalTo(self.blackLabel.mas_bottom).offset(ZGCConvertToPx(-6));
                if (i == 1) make.right.mas_equalTo(self.contentView.mas_right).offset(-kScreenW/2.0+ZGCConvertToPx(43/2.0));
                if (tempBlackBtn) make.size.mas_equalTo(tempBlackBtn);
            }];
            tempBlackBtn = btn;
        }
    }
}

@end
