//
//  NoteViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "NoteItemViewModel.h"
#import "NoteModel.h"
#import "DateSelectViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteViewModel : BaseTableViewModel

//@property (nonatomic, readonly, strong) RACCommand *deleteCommand;
@property (nonatomic, readonly, strong) RACCommand *searchCommand;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
