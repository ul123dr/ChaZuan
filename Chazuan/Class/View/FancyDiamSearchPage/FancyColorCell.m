//
//  FancyColorCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyColorCell.h"

@interface FancyColorCell ()

/// viewModel
@property (nonatomic, readwrite, strong) FancyColorItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *colorArr;
@property (nonatomic, readwrite, strong) NSMutableArray *colorBtns;

@end

@implementation FancyColorCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"FancyColorCell";
    FancyColorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(FancyColorItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, selectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
        @strongify(self);
        NSMutableArray *titleArr = [NSMutableArray arrayWithArray:[viewModel.selectTitle componentsSeparatedByString:@"，"]];
        [titleArr removeLastObject];
        for (int i = 0; i < selectArr.count; i++) {
            BOOL select = [selectArr[i] boolValue];
            ZGButton *btn = self.colorBtns[i];
            btn.selected = select;
            // 处理title
            NSString *name = self.colorArr[i];
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
    self.colorBtns = [NSMutableArray array];
    self.colorArr = @[@"Yellow",@"Pink",@"Red",@"Blue",@"Green",@"Orange",@"Purple",@"Black",@"Brown",@"Others"];
}

- (void)_setupSubviews {
    for (int i = 0; i < self.colorArr.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = COLOR_LINE.CGColor;
        btn.layer.borderWidth = 1;
        [btn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:kFont(14)];
        [btn setTitle:self.colorArr[i] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.colorBtns addObject:btn];
        
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
    for (int i = 0; i < self.colorBtns.count; i++) {
        ZGButton *btn = self.colorBtns[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%5 == 0) {
                make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            } else {
                make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(10));
                if (i%5 == 4)
                    make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
            }
            if (i/5 == 0) {
                make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            } else {
                if (i%5==0)
                    make.top.mas_equalTo(flourBtn.mas_bottom).offset(ZGCConvertToPx(10));
                else
                    make.top.mas_equalTo(flourBtn);
                if (i == self.colorBtns.count-1)
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
            }
            if (tempBtn) make.size.mas_equalTo(tempBtn);
        }];
        tempBtn = btn;
        if (i%5 == 0) flourBtn = btn;
    }
}
@end
