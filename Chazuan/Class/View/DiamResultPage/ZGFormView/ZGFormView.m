//
//  ZGFormView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ZGFormView.h"
#import "FormCollectionViewFlowLayout.h"

static NSString *kHeadCellIdentifier = @"kHeadCellIdentifier";
static NSString *kCellIdentifier = @"kCellIdentifier";

@interface ZGFormView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FormCollectionViewFlowLayoutDataSource>

/**
 主要渲染CollectionView
 */
@property (nonatomic, strong) UICollectionView *mainCV;

@property (nonatomic, strong) FormCollectionViewFlowLayout *mainLayout;

@property (nonatomic, assign) FormViewType fixationType;

@property (nonatomic, assign) NSInteger suspendRow;

@property (nonatomic, assign) NSInteger suspendSection;

@end

@implementation ZGFormView

- (instancetype)initWithFrame:(CGRect)frame type:(FormViewType)type {
    if (self = [super initWithFrame:frame]) {
        self.fixationType = type;
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

#pragma mark - method
- (void)reload {
    self.suspendRow = 0;
    self.suspendSection = 0;
    self.mainLayout.suspendRowNum = self.suspendRow;
    self.mainLayout.suspendSectionNum = self.suspendSection;
    [self.mainLayout reload];
    [self.mainCV reloadData];
}

- (void)registerClass:(Class)cellClass isHeader:(BOOL)isHeader {
    if (isHeader) [self.mainCV registerClass:cellClass forCellWithReuseIdentifier:kHeadCellIdentifier];
    else [self.mainCV registerClass:cellClass forCellWithReuseIdentifier:kCellIdentifier];
}

#pragma mark - DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource formView:self numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataSource numberOfSectionsInFormView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHeadCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell = [self.dataSource collectionViewCell:cell collectionViewType:FormCollectionViewTypeSuspendSecion cellForItemAtIndexPath:indexPath];
    return cell;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource formView:self sizeForItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource formView:self sizeForItemAtIndexPath:indexPath];
}

#pragma mark - init
- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainCV.frame = self.bounds;
}

- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
    self.clipsToBounds = YES;
    
    self.suspendRowColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    self.suspendSectionColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    self.mainColor = UIColor.whiteColor;
}

- (void)_setupSubviews {
    FormCollectionViewFlowLayout *mainLayout = [[FormCollectionViewFlowLayout alloc] init];
    mainLayout.suspendRowNum = self.suspendRow;
    mainLayout.suspendSectionNum = self.suspendSection;
    mainLayout.dataSource = self;
    self.mainLayout = mainLayout;
    
    UICollectionView *mainCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    mainCV.backgroundColor = [UIColor whiteColor];
    mainCV.directionalLockEnabled = YES;
    mainCV.delegate = self;
    mainCV.dataSource = self;
    mainCV.bounces = NO;
    mainCV.showsHorizontalScrollIndicator = NO;
    mainCV.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        mainCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.mainCV = mainCV;
    [self addSubview:mainCV];
}

- (void)_setupSubviewsConstraint {
    [self.mainCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (NSInteger)suspendRow{
    if (!_suspendRow) {
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(formView:numberOfSuspendItemsInSection:)]) {
            _suspendRow = [self.dataSource formView:self numberOfSuspendItemsInSection:0];
        }else{
            switch (_fixationType) {
                case FormViewTypeSectionAndRowFixation:
                    return 1;
                case FormViewTypeSectionFixation:
                    return 0;
                case FormViewTypeRowFixation:
                    return 1;
                case FormViewTypeNoneFixation:
                    return 0;
            }
        }
    }
    return _suspendRow;
}


- (NSInteger)suspendSection{
    if (!_suspendSection) {
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(numberOfSuspendSectionsInFormView:)])
        {
            _suspendSection = [_dataSource numberOfSuspendSectionsInFormView:self];
        }else{
            switch (_fixationType) {
                case FormViewTypeSectionAndRowFixation:
                    return 1;
                case FormViewTypeSectionFixation:
                    return 1;
                case FormViewTypeRowFixation:
                    return 0;
                case FormViewTypeNoneFixation:
                    return 0;
            }
        }
    }
    return _suspendSection;
}

@end

