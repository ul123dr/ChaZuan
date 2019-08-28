//
//  GoodInfoGroupViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodInfoGroupViewModel : CommonGroupViewModel

@property (nonatomic, readwrite, copy) NSAttributedString *attrHeader;

@property (nonatomic, readwrite, strong) RACCommand *addCommond;
@property (nonatomic, readwrite, strong) RACCommand *resetCommond;

@end

NS_ASSUME_NONNULL_END
