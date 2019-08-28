//
//  NoteItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
