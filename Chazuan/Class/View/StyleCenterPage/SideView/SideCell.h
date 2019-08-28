//
//  SideCell.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideCell : UICollectionViewCell

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) BOOL sideSelected;

@end

NS_ASSUME_NONNULL_END
