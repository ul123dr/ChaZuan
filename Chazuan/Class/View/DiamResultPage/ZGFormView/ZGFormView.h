//
//  ZGFormView.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FormViewType) {
    FormViewTypeSectionAndRowFixation, // 行列固定
    FormViewTypeSectionFixation, // 行固定
    FormViewTypeRowFixation, // 列固定
    FormViewTypeNoneFixation // 无固定
};

typedef NS_ENUM(NSUInteger, FormCollectionViewType) {
    FormCollectionViewTypeMain, // 主区域
    FormCollectionViewTypeSuspendRow, // 悬浮列区域
    FormCollectionViewTypeSuspendSecion // 悬浮行区域
};


@class ZGFormView;
@protocol FormViewDataSource <NSObject>

@required
- (NSInteger)formView:(ZGFormView *)formView numberOfItemsInSection:(NSInteger)section;

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 对应item尺寸大小
 */
- (CGSize)formView:(ZGFormView *)formView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 总列数量 默认为1
 */
- (NSInteger)numberOfSectionsInFormView:(ZGFormView *)formView;

@optional
/**
 悬浮锁定列数
 */
- (NSInteger)numberOfSuspendSectionsInFormView:(ZGFormView *)formView;
/**
 悬浮锁定行数
 
 @param formView 当前对象
 @param section 第几列
 @return 行数
 */
- (NSInteger)formView:(ZGFormView *)formView numberOfSuspendItemsInSection:(NSInteger)section;

@end

@interface ZGFormView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(FormViewType)type;

- (void)registerClass:(Class)cellClass isHeader:(BOOL)isHeader;

@property (nonatomic, weak) id<FormViewDataSource> dataSource;

@property (nonatomic, readonly, strong) UICollectionView *mainCV;

@property (nonatomic,strong) UIColor *suspendRowColor;

@property (nonatomic,strong) UIColor *suspendSectionColor;

@property (nonatomic,strong) UIColor *mainColor;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
