//
//  StyleInfoItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleInfoItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *designNo;
@property (nonatomic, readwrite, copy) NSString *material;
@property (nonatomic, readwrite, copy) NSString *size;
@property (nonatomic, readwrite, copy) NSString *sideStone;
@property (nonatomic, readwrite, copy) NSString *designSeries;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSMutableAttributedString *record;

@end

NS_ASSUME_NONNULL_END
