//
//  FormCollectionViewFlowLayout.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FormCollectionViewFlowLayout.h"

@interface FormCollectionViewFlowLayout ()

/** 所有item的布局  */
@property (nonatomic, strong) NSMutableArray *itemAttributes;
/** 一行里面所有item的宽，每一行都是一样的  */
@property (nonatomic, strong) NSMutableArray *itemsSize;
/** collectionView的contentSize大小  */
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation FormCollectionViewFlowLayout


#pragma mark - private
/**
 设置 行 里面的 item 的Size
 （每一列的宽度一样，所以只需要确定一行的item的宽度）
 */
- (void)calculateItemsSize{
    
    for (NSInteger section = 0; section<[self.collectionView numberOfSections]; section++) {
        NSMutableArray *sectionsSize = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            CGSize itemSize = [_dataSource sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
            [sectionsSize addObject:itemSizeValue];
        }
        [self.itemsSize addObject:sectionsSize];
    }
}


/**
 每一个滚动都会走这里，去确定每一个item的位置
 */
- (void)prepareLayout{
    
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    NSUInteger column           = 0;//列
    CGFloat xOffset             = 0.0;//X方向的偏移量
    CGFloat yOffset             = 0.0;//Y方向的偏移量
    CGFloat contentWidth        = 0.0;//collectionView.contentSize的宽度
    CGFloat contentHeight       = 0.0;//collectionView.contentSize的高度
    
    
    if (self.itemAttributes.count > 0) {
        
        for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems        = [self.collectionView numberOfItemsInSection:section];
            
            for (NSUInteger row = 0; row < numberOfItems; row++) {
                // 非锁定区域 不固定 直接过滤
                if (row >= self.suspendRowNum && section >= self.suspendSectionNum) {
                    continue;
                }
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
                
                // 锁定行
                if (section <self.suspendSectionNum) {
                    
                    CGRect frame            = attributes.frame;
                    float offsetY           = 0;
                    if (index > 0) {
                        for (int y = 0; y < section; y++) {
                            offsetY +=  [self.itemsSize[y][row] CGSizeValue].height;
                        }
                    }
                    frame.origin.y          = self.collectionView.contentOffset.y + offsetY;
                    attributes.frame        = frame;
                }
                
                // 锁定列
                if (row < self.suspendRowNum) {
                    CGRect frame            = attributes.frame;
                    float offsetX           = 0;
                    if (index > 0) {
                        for (int i = 0; i < row; i++) {
                            offsetX +=  [self.itemsSize[section][i] CGSizeValue].width;
                        }
                    }
                    
                    frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                    attributes.frame = frame;
                }
            }
        }
        
        return;
    }
    
    
    self.itemAttributes                     = [@[] mutableCopy];
    self.itemsSize                          = [@[] mutableCopy];
    
    if (self.itemsSize.count != [self.collectionView numberOfSections] * [self.collectionView numberOfItemsInSection:0]) {
        [self calculateItemsSize];
    }
    
    for (NSInteger section = 0; section <  [self.collectionView numberOfSections]; section ++) {
        
        NSMutableArray *sectionAttributes   = [@[] mutableCopy];
        
        for (NSUInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
            
            CGSize itemSize                 = [self.itemsSize[section][row] CGSizeValue];
            NSIndexPath *indexPath          = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame                = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            
            if (section < self.suspendSectionNum && row < self.suspendRowNum) {
                attributes.zIndex = 2015;
            }else if (section < self.suspendSectionNum || row < self.suspendRowNum) {
                attributes.zIndex = 2014;
            }
            
            if (section < self.suspendSectionNum) {
                
                CGRect frame                = attributes.frame;
                float offsetY               = 0;
                if (rindex > 0) {
                    for (int y = 0; y < section; y++) {
                        offsetY += [self.itemsSize[y][row] CGSizeValue].height;
                    }
                }
                frame.origin.y              = self.collectionView.contentOffset.y+offsetY;
                //                frame.origin.y = self.collectionView.contentOffset.y;
                
                attributes.frame            = frame;
            }
            
            if (row < self.suspendRowNum) {
                
                CGRect frame                = attributes.frame;
                float offsetX               = 0;
                if (index > 0) {
                    for (int i = 0; i < row; i++) {
                        offsetX += [self.itemsSize[section][i] CGSizeValue].width;
                    }
                }
                
                frame.origin.x              = self.collectionView.contentOffset.x + offsetX;
                attributes.frame            = frame;
            }
            
            [sectionAttributes addObject:attributes];
            
            xOffset                         = xOffset + itemSize.width;
            column ++;
            if (column == [self.collectionView numberOfItemsInSection:0]) {
                
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                // 重置基本变量
                column                      = 0;
                xOffset                     = 0;
                yOffset += itemSize.height;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // 获取右下角最有一个item，确定collectionView的contentSize大小
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight                           = attributes.frame.origin.y + attributes.frame.size.height;
    _contentSize                            = CGSizeMake(contentWidth, contentHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            CGRect frame = [evaluatedObject frame];
            return CGRectIntersectsRect(rect, frame);
        }]]];
    }
    
    return attributes;
}

- (CGSize)collectionViewContentSize{
    return  _contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (void)reload{
    if (self.itemAttributes) {
        [self.itemAttributes removeAllObjects];
    }
    if (self.itemsSize) {
        [self.itemsSize removeAllObjects];
    }
}

@end
