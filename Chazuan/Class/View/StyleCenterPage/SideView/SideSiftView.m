//
//  SideSiftView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SideSiftView.h"
#import "StyleCenterViewModel.h"
#import "SideCell.h"
#import "SideNormalHeaderView.h"
#import "StyleOneHeaderView.h"
#import "StyleTwoHeaderView.h"

@interface SideSiftView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, readwrite, assign) StyleType type;

@property (nonatomic, readwrite, strong) StyleCenterViewModel *viewModel;

@property (nonatomic, readwrite, strong) UICollectionView *collectionView;

@property (nonatomic, readwrite, strong) UIView *footerView;
@property (nonatomic, readwrite, strong) ZGButton *resetBtn;
@property (nonatomic, readwrite, strong) ZGButton *confirmBtn;

@end

@implementation SideSiftView

- (instancetype)initWithFrame:(CGRect)frame type:(StyleType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self _setup];
        [self _setupSubviews];
        [self _setupConstraint];
    }
    return self;
}

- (void)bindViewModel:(StyleCenterViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, select) ignore:nil] subscribeNext:^(SiftSelectModel *select) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)reloadData {
    [self.collectionView reloadData];
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
                         self.frame = CGRectMake(kScreenW, 0, kScreenW, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         self.backgroundColor = kHexColorAlpha(@"#000000", 0.5);;
                         [self removeFromSuperview];
                     }];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.sideArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.sideArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    SiftList *list = self.viewModel.sideArray[indexPath.section][indexPath.row];
    cell.name = list.name;
    if ([self.viewModel.sideSelectArray[indexPath.section] count] > 0) {
        SiftList *selectList = [self.viewModel.sideSelectArray[indexPath.section] firstObject];
        cell.sideSelected = list.listId == selectList.listId;
    } else {
        cell.sideSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    SiftList *list = self.viewModel.sideArray[indexPath.section][indexPath.row];
    NSArray *selectArray = self.viewModel.sideSelectArray[indexPath.section];
    if ([selectArray count] > 0) {
        SiftList *selectList = selectArray.firstObject;
        if (selectList.listId.integerValue == list.listId.integerValue) selectArray = @[];
        else selectArray = @[list];
    } else {
        selectArray = @[list];
    }
    
    [self.viewModel.sideSelectArray replaceObjectAtIndex:indexPath.section withObject:selectArray];
    
    if (self.type != StyleZT) {
        switch (indexPath.section) {
            case 1:
                self.viewModel.select.categoryList = selectArray;
                break;
            case 2:
                self.viewModel.select.describeList = selectArray;
                break;
            case 3:
                self.viewModel.select.styleList = selectArray;
                break;
            case 4:
                self.viewModel.select.scoopList = selectArray;
                break;
            case 5:
                self.viewModel.select.gemsList = selectArray;
                break;
            case 6:
                self.viewModel.select.recommendList = selectArray;
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.section) {
            case 1:
                self.viewModel.select.categoryList = selectArray;
                break;
            case 2:
                self.viewModel.select.describeList = selectArray;
                break;
            case 3:
                self.viewModel.select.scoopList = selectArray;
                break;
            default:
                break;
        }
    }
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            if (self.type != StyleGoodsList) {
                StyleOneHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"oneHeader" forIndexPath:indexPath];
                headerView.title = @"款号";
                headerView.textField.text = self.viewModel.designNo;
                RACChannelTo(self.viewModel, designNo) = headerView.textField.rac_newTextChannel;
                return headerView;
            } else {
                StyleTwoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"twoHeader" forIndexPath:indexPath];
                headerView.title1 = @"款号";
                headerView.title2 = @"条码";
                headerView.title3 = @"标签价";
                headerView.textField1.text = self.viewModel.designNo;
                headerView.textField2.text = self.viewModel.barCode;
                headerView.textField3.text = self.viewModel.priceMin;
                headerView.textField4.text = self.viewModel.priceMax;
                [RACObserve(self.viewModel, priceBtnTitle) subscribeNext:^(NSString *title) {
                    [headerView.priceBtn setTitle:title forState:UIControlStateNormal];
                }];
                RACChannelTo(self.viewModel, designNo) = headerView.textField1.rac_newTextChannel;
                RACChannelTo(self.viewModel, barCode) = headerView.textField2.rac_newTextChannel;
                RACChannelTo(self.viewModel, priceMin) = headerView.textField3.rac_newTextChannel;
                RACChannelTo(self.viewModel, priceMax) = headerView.textField4.rac_newTextChannel;
                @weakify(self);
                [[headerView.priceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
                    @strongify(self);
                    self.callback(sender);
                }];
                return headerView;
            }
        } else {
            SideNormalHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"normalHeader" forIndexPath:indexPath];
            headerView.header = self.viewModel.sideTitle[indexPath.section];
            return headerView;
        }
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusable" forIndexPath:indexPath];
        return footerView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type == StyleGoodsList) return CGSizeMake(ZGCConvertToPx(325), ZGCConvertToPx(223));
        else return CGSizeMake(ZGCConvertToPx(325), ZGCConvertToPx(71));
    }
    return CGSizeMake(ZGCConvertToPx(325), ZGCConvertToPx(39));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, ZGCConvertToPx(10), ZGCConvertToPx(10), ZGCConvertToPx(10));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

#pragma mark - init
- (void)_setup {
    self.backgroundColor = kHexColorAlpha(@"#000000", 0.5);
}

- (void)_setupSubviews {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(ZGCConvertToPx(275/4.0), ZGCConvertToPx(32));
    flow.minimumLineSpacing = ZGCConvertToPx(10);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    collectionView.allowsMultipleSelection = YES;
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.allowsMultipleSelection = YES;
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    [collectionView registerClass:SideCell.class forCellWithReuseIdentifier:@"Cell"];
    [collectionView registerClass:SideNormalHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normalHeader"];
    [collectionView registerClass:StyleOneHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"oneHeader"];
    [collectionView registerClass:StyleTwoHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"twoHeader"];
    [collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusable"];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = UIColor.whiteColor;
    footerView.layer.shadowColor = kHexColor(@"#C0C0C0").CGColor;
    footerView.layer.shadowOpacity = 0.6;
    footerView.layer.shadowRadius = 3;
    footerView.layer.shadowOffset = CGSizeMake(0, -3);
    self.footerView = footerView;
    [self addSubview:footerView];
    
    ZGButton *resetBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:kBoldFont(16)];
    [resetBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    resetBtn.layer.borderColor = COLOR_LINE.CGColor;
    resetBtn.layer.borderWidth = 0.5;
    self.resetBtn = resetBtn;
    [footerView addSubview:resetBtn];
    
    ZGButton *confirmBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:kBoldFont(16)];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.confirmBtn = confirmBtn;
    [footerView addSubview:confirmBtn];
    
    @weakify(self);
    [[resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        @weakify(self);
        [[self.viewModel.sideResetCommand execute:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }];
    
    [[confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self dismiss];
        [self.viewModel.sideConfirmCommand execute:nil];
    }];
}

- (void)_setupConstraint {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kNavHeight);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(50));
        make.right.mas_equalTo(self.mas_right);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.mas_equalTo(self.collectionView);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(kBottomHeight);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.footerView);
        make.bottom.mas_equalTo(self.footerView.mas_bottom).offset(-kBottomSpace);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.footerView);
        make.left.mas_equalTo(self.resetBtn.mas_right);
        make.width.height.mas_equalTo(self.resetBtn);
    }];
}

@end
