//
//  CertSelectCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSelectCell.h"

@interface CertSelectCell ()

@property (nonatomic, readwrite, strong) CertSelectItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *certData;
@property (nonatomic, readwrite, strong) NSMutableArray *btnArray;
// 当前选中button
@property (nonatomic, readwrite, strong) ZGButton *selectedBtn;
@property (nonatomic, readwrite, strong) ZGButton *openBtn;

@end

@implementation CertSelectCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"CertSelectCell";
    CertSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(CertSelectItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [[RACObserve(viewModel, cartData) ignore:nil] subscribeNext:^(NSArray *data) {
        @strongify(self);
        self.certData = data;
        [self.btnArray removeAllObjects];
        [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self _setupSubviews];
    }];
    [RACObserve(viewModel, open) subscribeNext:^(NSNumber *open) {
        @strongify(self);
        self.openBtn.selected = open.boolValue;
        [self _setupSubviewsConstraint:open.boolValue];
    }];
    [RACObserve(viewModel, certIndex) subscribeNext:^(NSNumber *index) {
        @strongify(self);
        if (index.integerValue < self.btnArray.count) {
            ZGButton *btn = self.btnArray[index.integerValue];
            self.selectedBtn.selected = NO;
            btn.selected = YES;
            self.selectedBtn = btn;
        }
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
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.btnArray = [NSMutableArray array];
}

- (void)_setupSubviews {
    if (kObjectIsNil(self.certData) || self.certData.count == 0) return;
    @weakify(self);
    ZGButton *tempBtn;
    for (int i = 0; i < self.certData.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        [btn.titleLabel setFont:kFont(15)];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN] forState:UIControlStateSelected];
        [btn setTitle:self.certData[i] forState:UIControlStateNormal];
        btn.layer.borderColor = kHexColor(@"#E0E0E0").CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 2;
        btn.tag = i;
        btn.clipsToBounds = YES;
        [self.contentView addSubview:btn];
        [self.btnArray addObject:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            if (sender.tag == self.selectedBtn.tag) return;
            self.selectedBtn.selected = NO;
            sender.selected = YES;
            self.selectedBtn = sender;
            self.viewModel.certIndex = sender.tag;
        }];
        tempBtn = btn;
    }
    ZGButton *openBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [openBtn setImage:ImageNamed(@"certSearch_down") forState:UIControlStateNormal];
    [openBtn setImage:ImageNamed(@"certSearch_up") forState:UIControlStateSelected];
    [openBtn setTitle:@"展开" forState:UIControlStateNormal];
    [openBtn setTitle:@"收起" forState:UIControlStateSelected];
    [openBtn.titleLabel setFont:kFont(12)];
    [openBtn setTitleColor:kHexColor(@"#4c5860") forState:UIControlStateNormal];
    self.openBtn = openBtn;
    [self.contentView addSubview:openBtn];
    
    [[openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *btn) {
        btn.enabled = NO;
        btn.selected = !btn.selected;
        @strongify(self);
        self.viewModel.open = btn.selected;
        [self _setupSubviewsConstraint:btn.selected];
    }];
//    [self _setupSubviewsConstraint:NO];
}

- (void)_setupSubviewsConstraint:(BOOL)open {
    if (kObjectIsNil(self.certData) || self.certData.count == 0) return;
    ZGButton *tempBtn;
    for (int i = 0; i < self.certData.count; i++) {
        ZGButton *btn = self.btnArray[i];
        btn.hidden = NO;
        if (open) {
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (i%4==0) {
                    make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
                } else {
                    make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(12));
                    if (i%4==3) {
                        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
                    }
                }
                if (i/4==0) {
                    make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(30));
                } else {
                    if (i%4==0) make.top.mas_equalTo(tempBtn.mas_bottom).offset(ZGCConvertToPx(12));
                    else make.top.mas_equalTo(tempBtn);
                    if (i==self.certData.count-1) {
                        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-61));
                    }
                }
                if (tempBtn) make.width.height.mas_equalTo(tempBtn);
            }];
            tempBtn = btn;
        } else {
            if (i < 4) {
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(30));
                    if (tempBtn) {
                        make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(12));
                    } else {
                        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
                    }
                    if (i == 3) {
                        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
                        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-61));
                    }
                    if (tempBtn) make.width.height.mas_equalTo(tempBtn);
                }];
                tempBtn = btn;
            } else {
                btn.hidden = YES;
            }
        }
    }
    self.openBtn.enabled = YES;
    [self.openBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempBtn.mas_bottom).offset(ZGCConvertToPx(30));
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(30));
    }];
    [self.contentView layoutIfNeeded];
}

@end
