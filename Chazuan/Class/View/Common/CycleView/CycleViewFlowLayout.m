//
//  CycleViewFlowLayout.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CycleViewFlowLayout.h"

@implementation CycleViewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    // 目标区域中包含的cell
    NSArray *layoutArr = [super layoutAttributesForElementsInRect:targetRect];
    // collectionView落在屏幕中点的x坐标
    CGFloat horizontalCenterX = proposedContentOffset.x + (self.collectionView.bounds.size.width / 2.0);
    CGFloat offsetAdjustment = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutArr) {
        CGFloat itemHorizontalCenterX = layoutAttributes.center.x;
        // 找出离中心点最近的
        if (fabs(itemHorizontalCenterX-horizontalCenterX) < fabs(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenterX-horizontalCenterX;
        }
    }
    //返回collectionView最终停留的位置
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutArr = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
    // 缩放动画设置
//    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutArr) {
//        CGFloat distance = (visibleRect.size.width / 2.0 + visibleRect.origin.x) - layoutAttributes.center.x;
//        CGFloat normalizedDistance = fabs(distance / 400);
//        CGFloat zoom = 1 - 0.25 * normalizedDistance;
//
//        layoutAttributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
//    }
    
    return layoutArr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
