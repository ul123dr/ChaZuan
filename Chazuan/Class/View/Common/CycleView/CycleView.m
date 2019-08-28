//
//  CycleView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CycleView.h"
#import "CycleViewCell.h"
#import "CycleViewFlowLayout.h"

@interface CycleView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) CycleViewFlowLayout *flowLayout;
@property (nonatomic, readwrite, strong) UIPageControl *pageControl;
@property (nonatomic, readwrite, strong) NSMutableArray *cellModels;
@property (nonatomic, readwrite, assign) BOOL isSingleData;
@property (nonatomic, readwrite, strong) NSTimer *timer;
@property (nonatomic, readwrite, assign) NSTimeInterval animationDuration;
@property (nonatomic, readwrite, assign) BOOL isShowTitle;

@end

@implementation CycleView

- (void)dealloc {
    // 销毁时，先销毁时间
    [self setTimerInvalidate];
}

+ (instancetype)cycleView {
    return [[self alloc] init];
}

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

#pragma mark - Public Method
- (void)setModels:(NSArray *)models {
    if (models.count == 0) return;
    CycleCollectionModel *model = models.firstObject;
    self.isShowTitle = kStringIsNotEmpty(validateString(model.title));
    self.isSingleData = models.count == 1;
    
    self.cellModels = [NSMutableArray arrayWithArray:models];
    
    if (!self.isSingleData) {
        // 循环数据设置
        [self.cellModels addObject:models.firstObject];
        [self.cellModels insertObject:models.lastObject atIndex:0];
        
        // 这里需要reload下collectionView，不然数据不会加载
        [self.collectionView reloadData];
        // 解决刷新数据源，再设置ContentOffset的位置不改变问题
        [self.collectionView layoutIfNeeded];
        
        [self.collectionView setContentOffset:CGPointMake(kScreenW, 0)];
    } else {
        // 重新装载数据
        [self.collectionView reloadData];
    }
    
    self.pageControl.numberOfPages = models.count;
    if (self.isShowTitle) {
        self.pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(kScreenW/4.0);
        }];
    }
    
    [self.superview layoutIfNeeded];
    [self startTimer];
}

/* 停止计时器 */
- (void)setTimerInvalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startTimer {
    [self setTimerInvalidate];
    if (self.isSingleData) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration
                                                  target:self
                                                selector:@selector(_animationTimerDidFired)
                                                userInfo:nil
                                                 repeats:YES];
}

#pragma mark - Delegate
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cellModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CycleCell";
    CycleViewCell *cycleCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cycleCell bindModel:self.cellModels[indexPath.row]];
    return cycleCell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger page = self.collectionView.contentOffset.x/self.collectionView.bounds.size.width;
    if (page == 0 && self.cellModels.count > 2) {//滚动到左边
        page = self.cellModels.count - 2;
    } else if (page == self.cellModels.count - 1) {//滚动到右边
        page = 0;
    } else {
        page -= 1;
    }
    if (_actionBlock) self.actionBlock(page);
}

// 手动拖拽结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isSingleData) return;
    [self _cycleScroll];
    // 设置滚动间隔
    if (_timer) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];
    }
}

// 自动轮播结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self _cycleScroll];
}

#pragma mark - 辅助方法
// 循环显示
- (void)_cycleScroll {
    NSInteger page = (self.collectionView.contentOffset.x+0.25)/self.collectionView.bounds.size.width;
    if (page == 0 && self.cellModels.count > 2) {//滚动到左边
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * (self.cellModels.count - 2), 0);
        self.pageControl.currentPage = self.cellModels.count - 2;
    } else if (page == self.cellModels.count - 1) {//滚动到右边
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width, 0);
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = page - 1;
    }
}

/* 播放下一个 */
- (void)_animationTimerDidFired {
    // 手指拖拽时禁止自动轮播
    if (self.collectionView.isDragging) return;
    CGFloat targetX =  self.collectionView.contentOffset.x + self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(targetX, 0) animated:true];
}

#pragma mark - 创建页面
- (void)_setup {
    self.clipsToBounds = YES;
    
    self.animationDuration = 3; //3秒
}

- (void)_setupSubviews {
    CycleViewFlowLayout *flowLayout = [[CycleViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(kScreenW, ZGCConvertToPx(228));
    self.flowLayout = flowLayout;
    
    CGRect collectionFrame = CGRectMake(0, 0, kScreenW, ZGCConvertToPx(228));
    
    // collection 创建时就要设置frame，不然 cell 显示不出来
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:self.flowLayout];
    collectionView.backgroundColor = kHexColor(@"#F5F5F5");
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:CycleViewCell.class forCellWithReuseIdentifier:@"CycleCell"];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = kHexColor(@"#DBD1CF");
    pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}

- (void)_setupSubviewsConstraint {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_bottom).offset(ZGCConvertToPx(-12));
    }];
}

@end
