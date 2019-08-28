//
//  FormCollectionViewFlowLayout.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FormCollectionViewFlowLayoutDataSource <NSObject>

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FormCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 需要灵活item 尺寸 就需要遵守
 */
@property (nonatomic,weak)id <FormCollectionViewFlowLayoutDataSource>dataSource;

/**
 锁定行数
 */
@property (nonatomic,assign)NSInteger suspendRowNum;

/**
 锁定列数
 */
@property (nonatomic,assign)NSInteger suspendSectionNum;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
