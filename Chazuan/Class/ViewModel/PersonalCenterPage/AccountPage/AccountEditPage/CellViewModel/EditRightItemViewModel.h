//
//  EditRightItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditRightItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, assign) BOOL shouldEdited;
@property (nonatomic, readwrite, assign) BOOL show;
@property (nonatomic, readwrite, copy) NSString *leftStr;
@property (nonatomic, readwrite, copy) NSString *rightStr;
@property (nonatomic, readwrite, assign) BOOL allowed;

@end

NS_ASSUME_NONNULL_END
