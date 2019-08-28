//
//  CycleViewCell.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CycleViewCell : UICollectionViewCell

- (void)bindModel:(CycleCollectionModel *)model;

@end

NS_ASSUME_NONNULL_END
