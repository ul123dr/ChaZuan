//
//  StyleSelectItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellSelectBlock)(UITableViewCell* cell, CGPoint point);

@interface StyleSelectItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *name;

@property (nonatomic, readwrite, copy) CellSelectBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
