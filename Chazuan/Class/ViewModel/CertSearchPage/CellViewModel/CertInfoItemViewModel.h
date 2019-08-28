//
//  CertInfoItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertInfoItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *valueName;
@property (nonatomic, readwrite, assign) BOOL showPdf;
@property (nonatomic, readwrite, strong) RACCommand *pdfCommand;

@end

NS_ASSUME_NONNULL_END
