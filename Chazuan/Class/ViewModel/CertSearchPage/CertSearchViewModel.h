//
//  CertSearchViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "CertSelectItemViewModel.h"
#import "CertSearchItemViewModel.h"
#import "CertInfoItemViewModel.h"
#import "PdfViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertSearchViewModel : BaseTableViewModel

@property (nonatomic, readwrite, assign) NSInteger type;

@property (nonatomic, readonly, assign) BOOL open;
@property (nonatomic, readwrite, assign) CGFloat selectHeight;

@property (nonatomic, readonly, strong) RACCommand *searchCommand;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
