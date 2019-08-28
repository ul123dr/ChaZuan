//
//  CalculatorViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CalculatorViewModel.h"

@interface CalculatorViewModel ()

@property (nonatomic, readwrite, strong) NSArray *colorArr;
@property (nonatomic, readwrite, strong) NSArray *clarityArr;

@property (nonatomic, readwrite, strong) RACCommand *quoteCommand;

@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation CalculatorViewModel

- (void)initialize {
    [super initialize];
    self.backgroundColor = COLOR_BG;
    
    self.colorArr = @[@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N"];
    self.clarityArr = @[@"FL",@"IF",@"VVS1",@"VVS2",@"VS1",@"VS2",@"SI1",@"SI2",@"SI3",@"I1",@"I2"];
    self.rap = @"0";
    self.rate = @"6.50";
    self.discount = @"0";
    self.dollarPrice = @"0";
    self.rmbPrice = @"0";
    self.dollarCT = @"0.00/CT";
    self.rmbCT = @"0.00/CT";
    
    @weakify(self);
    [[RACSignal merge:@[RACObserve(self, type), RACObserve(self, color), RACObserve(self, clarity), RACObserve(self, carat)]] subscribeNext:^(id x) {
        @strongify(self);
        if (kStringIsNotEmpty(self.carat) && self.carat.floatValue > 0)
            [self.quoteCommand execute:nil];
        else {
            self.rap = @"0";
            self.dollarPrice = @"0";
            self.rmbPrice = @"0";
        }
    }];
    
    [RACObserve(self, rate) subscribeNext:^(NSString *rate) {
        @strongify(self);
        if (self.textType != 2) return;
        CGFloat rap = self.rap.floatValue;
        CGFloat size = self.carat.floatValue;
        CGFloat discount = (100.0-self.discount.floatValue)/100.0;
        if (kStringIsNotEmpty(rate)&&rate.floatValue>0) {
            self.rmbPrice = [NSString stringWithFormat:@"%.2f", rap*size*discount*rate.floatValue];
            self.dollarPrice = [NSString stringWithFormat:@"%.2f", rap*size*discount];
        } else {
            self.rmbPrice = @"0";
            self.dollarPrice = @"0";
        }
    }];

    [RACObserve(self, discount) subscribeNext:^(NSString *discount) {
        @strongify(self);
        if (self.textType != 3) return;
        if (kStringIsNotEmpty(discount)&&discount.floatValue>0&&discount.floatValue<=100) {
            CGFloat disc = 1.0-discount.floatValue/100.0;
            self.dollarPrice = [NSString stringWithFormat:@"%.2f", self.rap.floatValue*self.carat.floatValue*disc];
            self.rmbPrice = [NSString stringWithFormat:@"%.2f", self.rap.floatValue*self.carat.floatValue*disc*self.rate.floatValue];
        } else {
            self.dollarPrice = [NSString stringWithFormat:@"%.2f", self.rap.floatValue*self.carat.floatValue];
            self.rmbPrice = [NSString stringWithFormat:@"%.2f", self.rap.floatValue*self.carat.floatValue*self.rate.floatValue];
        }
    }];

    [RACObserve(self, dollarPrice) subscribeNext:^(NSString *dollarPrice) {
        @strongify(self);
        self.dollarCT = [NSString stringWithFormat:@"%.2f/CT", self.rap.floatValue];
        if (self.textType != 4) return;
        if (kStringIsNotEmpty(dollarPrice)&&dollarPrice.floatValue>0) {
            self.rmbPrice = [NSString stringWithFormat:@"%.2f", dollarPrice.floatValue*self.rate.floatValue];
            self.discount = [NSString stringWithFormat:@"%.2f", (1.0-dollarPrice.floatValue/(self.rap.floatValue*self.carat.floatValue))*100.0];
        } else {
            self.rmbPrice = @"0";
            self.discount = @"100";
        }
    }];

    [RACObserve(self, rmbPrice) subscribeNext:^(NSString *rmbPrice) {
        @strongify(self);
        self.rmbCT = [NSString stringWithFormat:@"%.2f/CT", self.rap.floatValue*self.rate.floatValue];
        if (self.textType != 5) return;
        if (kStringIsNotEmpty(rmbPrice)&&rmbPrice.floatValue>0) {
            self.dollarPrice = [NSString stringWithFormat:@"%2.f", rmbPrice.floatValue/self.rate.floatValue];
            self.discount = [NSString stringWithFormat:@"%.2f", (1.0-self.dollarPrice.floatValue/(self.rap.floatValue*self.carat.floatValue))*100.0];
        } else {
            self.dollarPrice = @"0";
            self.discount = @"100";
        }
    }];
    
    self.quoteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"shape"] = self.type;
        subscript[@"d_size"] = self.carat;
        subscript[@"color"] = self.color;
        subscript[@"clarity"] = self.clarity;
        
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_QUOTATION_PRICE parameters:subscript.dictionary];
        return [[[[self.services.client enqueueParameter:paramters resultClass:CalculatorModel.class] takeUntil:self.rac_willDeallocSignal] doNext:^(HTTPResponse *response) {
            @strongify(self);
            CalculatorModel *model = response.parsedResult;
            self.rap = model?model.price.stringValue:@"0";
            CGFloat discount = (100-self.discount.floatValue)/100.0;
            self.dollarPrice = [NSString stringWithFormat:@"%.2f", self.rap.floatValue*self.carat.floatValue*discount];
            self.rmbPrice = [NSString stringWithFormat:@"%.2f", self.rap.floatValue*self.carat.floatValue*discount*self.rate.floatValue];
        }] doError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"获取价格出错"];
        }];
    }];
}

@end
