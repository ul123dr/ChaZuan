//
//  DiamClarityCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamClarityCell.h"

@interface DiamClarityCell ()

/// viewModel
@property (nonatomic, readwrite, strong) ClarityItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *clarityArr;
@property (nonatomic, readwrite, strong) NSMutableArray *clarityBtns;

@end

@implementation DiamClarityCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DiamClarityCell";
    DiamClarityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(ClarityItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, selectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
        @strongify(self);
        NSMutableArray *titleArr = [NSMutableArray arrayWithArray:[viewModel.selectTitle componentsSeparatedByString:@"，"]];
        [titleArr removeLastObject];
        for (int i = 0; i < selectArr.count; i++) {
            BOOL select = [selectArr[i] boolValue];
            ZGButton *btn = self.clarityBtns[i];
            btn.selected = select;
            // 处理title
            NSString *name = self.clarityArr[i];
            if (select) {
                if (![titleArr containsObject:name])
                    [titleArr addObject:name];
            } else {
                if ([titleArr containsObject:name])
                    [titleArr removeObject:name];
            }
        }
        if (titleArr.count > 0)
            viewModel.selectTitle = [[titleArr componentsJoinedByString:@"，"] stringByAppendingString:@"，"];
        else
            viewModel.selectTitle = @"";
    }];
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
    self.clarityBtns = [NSMutableArray array];
    self.clarityArr = @[@"FL",@"IF",@"VVS1",@"VVS2",@"VS1",@"VS2",@"SI1",@"SI2",@"SI3",@"I1"];
}

- (void)_setupSubviews {
    for (int i = 0; i < self.clarityArr.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = COLOR_LINE.CGColor;
        btn.layer.borderWidth = 1;
        [btn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:kFont(14)];
        [btn setTitle:self.clarityArr[i] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.clarityBtns addObject:btn];
        
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            [self.viewModel.clickSub sendNext:[RACTuple tupleWithObjects:@(i),@(sender.selected), nil]];
        }];
    }
}

- (void)_setupSubviewsConstraint {
    ZGButton *tempBtn, *flourBtn;
    for (int i = 0; i < self.clarityBtns.count; i++) {
        ZGButton *btn = self.clarityBtns[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%5 == 0) {
                make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(5));
            } else {
                make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(10));
                if (i%5 == 4)
                    make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-5));
            }
            if (i/5 == 0) {
                make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(5));
            } else {
                if (i%5==0)
                    make.top.mas_equalTo(flourBtn.mas_bottom).offset(ZGCConvertToPx(10));
                else
                    make.top.mas_equalTo(flourBtn);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-5));
            }
            if (tempBtn) make.size.mas_equalTo(tempBtn);
        }];
        tempBtn = btn;
        if (i%5 == 0) flourBtn = btn;
    }
}

@end
