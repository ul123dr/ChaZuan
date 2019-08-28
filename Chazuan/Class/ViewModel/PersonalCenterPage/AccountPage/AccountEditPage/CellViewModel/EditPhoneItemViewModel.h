//
//  EditPhoneItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditPhoneItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *value;
@property (nonatomic, readwrite, assign) BOOL shouldEdited;
@property (nonatomic, readwrite, assign) BOOL isText;
@property (nonatomic, readwrite, copy) NSString *placeholder;

@end

NS_ASSUME_NONNULL_END
