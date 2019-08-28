//
//  CertSearchItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertSearchItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *certTitle;
@property (nonatomic, readwrite, copy) NSString *searchText;
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;

@end

NS_ASSUME_NONNULL_END
