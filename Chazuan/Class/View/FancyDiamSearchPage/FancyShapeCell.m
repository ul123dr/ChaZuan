//
//  FancyShapeCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyShapeCell.h"
#import "ShapeButton.h"

@interface FancyShapeCell ()

/// viewModel
@property (nonatomic, readwrite, strong) FancyShapeItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *shapeArr;
@property (nonatomic, readwrite, strong) NSMutableArray *shapeBtns;

@end

@implementation FancyShapeCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"FancyShapeCell";
    FancyShapeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(FancyShapeItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, selectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
        @strongify(self);
        NSMutableArray *titleArr = [NSMutableArray arrayWithArray:[viewModel.selectTitle componentsSeparatedByString:@"，"]];
        [titleArr removeLastObject];
        for (int i = 0; i < selectArr.count; i++) {
            BOOL select = [selectArr[i] boolValue];
            ShapeButton *btn = self.shapeBtns[i];
            NSDictionary *dict = self.shapeArr[i];
            [btn.imageIcon setImage:ImageNamed(select?[dict objectForKey:@"selImage"]:[dict objectForKey:@"image"])];
            btn.nameLabel.textColor = select?kHexColor(@"#3882FF"):kHexColor(@"#1C2B36");
            btn.selected = select;
            // 处理title
            NSString *name = [dict objectForKey:@"name"];
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
    self.shapeBtns = [NSMutableArray array];
    self.shapeArr = @[@{@"val":@"Round",@"name":@"圆形",@"image":@"yuan_shape",@"selImage":@"yuan_shape_blue"},
                      @{@"val":@"Pear",@"name":@"梨形",@"image":@"li_shape",@"selImage":@"li_shape_blue"},
                      @{@"val":@"Princess",@"name":@"公主方",@"image":@"gong_shape",@"selImage":@"gong_shape_blue"},
                      @{@"val":@"Heart",@"name":@"心形",@"image":@"xin_shape",@"selImage":@"xin_shape_blue"},
                      @{@"val":@"Marquise",@"name":@"马眼形",@"image":@"ma_shape",@"selImage":@"ma_shape_blue"},
                      @{@"val":@"Oval",@"name":@"椭圆形",@"image":@"duo_shape",@"selImage":@"duo_shape_blue"},
                      @{@"val":@"Radiant",@"name":@"雷蒂恩",@"image":@"lei_shape",@"selImage":@"lei_shape_blue"},
                      @{@"val":@"Emerald",@"name":@"祖母绿",@"image":@"zu_shape",@"selImage":@"zu_shape_blue"},
                      @{@"val":@"Cushion",@"name":@"垫形",@"image":@"dian_shape",@"selImage":@"dian_shape_blue"},
                      @{@"val":@"triangle",@"name":@"三角形",@"image":@"san_shape",@"selImage":@"san_shape_blue"}];
}

- (void)_setupSubviews {
    for (int i = 0; i < self.shapeArr.count; i++) {
        NSDictionary *shapeDic = self.shapeArr[i];
        ShapeButton *btn = [ShapeButton buttonWithType:UIButtonTypeCustom];
        btn.nameLabel.text = [shapeDic objectForKey:@"name"];
        [self.contentView addSubview:btn];
        [self.shapeBtns addObject:btn];
        
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
    for (int i = 0; i < self.shapeBtns.count; i++) {
        ZGButton *btn = self.shapeBtns[i];
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
