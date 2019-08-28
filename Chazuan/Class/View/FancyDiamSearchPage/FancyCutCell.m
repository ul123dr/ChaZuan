//
//  FancyCutCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyCutCell.h"

@interface FancyCutCell ()

/// viewModel
@property (nonatomic, readwrite, strong) FancyCutItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *titleArr;
@property (nonatomic, readwrite, strong) NSMutableArray *btns;

@property (nonatomic, readwrite, strong) UILabel *polishLabel;
@property (nonatomic, readwrite, strong) UILabel *symLabel;

@end

@implementation FancyCutCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"FancyCutCell";
    FancyCutCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(FancyCutItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, selectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
        @strongify(self);
//        NSMutableArray *cutArr = [NSMutableArray arrayWithArray:[viewModel.cutSelectTitle componentsSeparatedByString:@","]];
        NSMutableArray *polishArr = [NSMutableArray arrayWithArray:[viewModel.polishSelectTitle componentsSeparatedByString:@","]];
        NSMutableArray *symArr = [NSMutableArray arrayWithArray:[viewModel.symSelectTitle componentsSeparatedByString:@","]];
//        [cutArr removeLastObject];
        [polishArr removeLastObject];
        [symArr removeLastObject];
        for (int i = 0; i < selectArr.count; i++) {
            BOOL select = [selectArr[i] boolValue];
            ZGButton *btn = self.btns[i];
            btn.selected = select;
            
            NSString *name = self.titleArr[i];
//            if (i >= 4 && i < 8) {
//                if (select) {
//                    if (![cutArr containsObject:name])
//                        [cutArr addObject:name];
//                } else {
//                    if ([cutArr containsObject:name])
//                        [cutArr removeObject:name];
//                }
//            }
            if (i >= 0 && i < 4) {
                if (select) {
                    if (![polishArr containsObject:name])
                        [polishArr addObject:name];
                } else {
                    if ([polishArr containsObject:name])
                        [polishArr removeObject:name];
                }
            }
            if (i >= 4 && i < 8) {
                if (select) {
                    if (![symArr containsObject:name])
                        [symArr addObject:name];
                } else {
                    if ([symArr containsObject:name])
                        [symArr removeObject:name];
                }
            }
        }
//        if (cutArr.count > 0)
//            viewModel.cutSelectTitle = [[cutArr componentsJoinedByString:@","] stringByAppendingString:@","];
//        else
//            viewModel.cutSelectTitle = @"";
        if (polishArr.count > 0)
            viewModel.polishSelectTitle = [[polishArr componentsJoinedByString:@","] stringByAppendingString:@","];
        else
            viewModel.polishSelectTitle = @"";
        if (symArr.count > 0)
            viewModel.symSelectTitle = [[symArr componentsJoinedByString:@","] stringByAppendingString:@","];
        else
            viewModel.symSelectTitle = @"";
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
    self.titleArr = @[@"EX",@"VG",@"GD",@"FR",@"EX",@"VG",@"GD",@"FR"];
    self.btns = [NSMutableArray array];
}

- (void)_setupSubviews {
    UILabel *polishLabel = [[UILabel alloc] init];
    polishLabel.font = kFont(15);
    polishLabel.textColor = kHexColor(@"#1C2B36");
    polishLabel.text = @"抛光";
    self.polishLabel = polishLabel;
    [self.contentView addSubview:polishLabel];
    
    UILabel *symLabel = [[UILabel alloc] init];
    symLabel.font = kFont(15);
    symLabel.textColor = kHexColor(@"#1C2B36");
    symLabel.text = @"对称";
    self.symLabel = symLabel;
    [self.contentView addSubview:symLabel];
    
    for (int i = 0; i < self.titleArr.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = COLOR_LINE.CGColor;
        btn.layer.borderWidth = 1;
        [btn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:kFont(14)];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.btns addObject:btn];
        
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            [self.viewModel.clickSub sendNext:[RACTuple tupleWithObjects:@(i),@(sender.selected), nil]];
        }];
    }
}

- (void)_setupSubviewsConstraint {
    [self.polishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.width.mas_equalTo(ZGCConvertToPx(73));
    }];
    [self.symLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.polishLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.size.mas_equalTo(self.polishLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    ZGButton *tempBtn, *flourBtn;
    for (int i = 0; i < self.btns.count; i++) {
        ZGButton *btn = self.btns[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%4 == 0) {
                make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(83));
            } else {
                make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(10));
                if (i%4 == 3)
                    make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
            }
            if (i/4 == 0) {
                make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(6));
            } else {
                if (i%4==0)
                    make.top.mas_equalTo(flourBtn.mas_bottom).offset(ZGCConvertToPx(12));
                else
                    make.top.mas_equalTo(flourBtn);
                if (i == self.btns.count-1)
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-6));
            }
            if (tempBtn) make.size.mas_equalTo(tempBtn);
        }];
        tempBtn = btn;
        if (i%4 == 0) flourBtn = btn;
    }
}
@end
