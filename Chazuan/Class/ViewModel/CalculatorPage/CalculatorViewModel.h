//
//  CalculatorViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewModel.h"
#import "CalculatorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorViewModel : BaseViewModel

@property (nonatomic, readonly, strong) NSArray *colorArr;
@property (nonatomic, readonly, strong) NSArray *clarityArr;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *color;
@property (nonatomic, readwrite, copy) NSString *clarity;
@property (nonatomic, readwrite, copy) NSString *carat;
@property (nonatomic, readwrite, copy) NSString *rap;
@property (nonatomic, readwrite, copy) NSString *rate;
@property (nonatomic, readwrite, copy) NSString *discount;
@property (nonatomic, readwrite, copy) NSString *dollarPrice;
@property (nonatomic, readwrite, copy) NSString *rmbPrice;
@property (nonatomic, readwrite, copy) NSString *dollarCT;
@property (nonatomic, readwrite, copy) NSString *rmbCT;

@property (nonatomic, readwrite, assign) NSInteger textType;
@property (nonatomic, readonly, strong) RACCommand *quoteCommand;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
