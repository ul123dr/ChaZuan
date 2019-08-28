//
//  FancySearchViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancySearchViewModel.h"
#import "DollarRate.h"
#import "DiamSearchModel.h"

@interface FancySearchViewModel ()

@property (nonatomic, readwrite, strong) DiamSearchModel *diam;

@property (nonatomic, readwrite, strong) NSArray *sizeArray;
@property (nonatomic, readwrite, strong) RACSubject *sizeSub;
@property (nonatomic, readwrite, strong) NSArray *certArray;
@property (nonatomic, readwrite, strong) RACSubject *certSub;

@property (nonatomic, readwrite, strong) NSArray *shapeSelect;
@property (nonatomic, readwrite, strong) RACSubject *shapeSub;

@property (nonatomic, readwrite, strong) NSArray *strengthSelect;
@property (nonatomic, readwrite, strong) RACSubject *strengthSub;

@property (nonatomic, readwrite, strong) NSArray *lustreSelect;
@property (nonatomic, readwrite, strong) RACSubject *lustreSub;

@property (nonatomic, readwrite, strong) NSArray *colorSelect;
@property (nonatomic, readwrite, strong) RACSubject *colorSub;

@property (nonatomic, readwrite, strong) NSArray *claritySelect;
@property (nonatomic, readwrite, strong) RACSubject *claritySub;

@property (nonatomic, readwrite, strong) NSArray *cutSelect;
@property (nonatomic, readwrite, strong) RACSubject *cutSub;

@property (nonatomic, readwrite, strong) NSArray *flourSelect;
@property (nonatomic, readwrite, strong) RACSubject *flourSub;

@property (nonatomic, readwrite, strong) RACSubject *clickSub;

@property (nonatomic, readwrite, strong) RACCommand *resetCommand;
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
@property (nonatomic, readwrite, strong) RACCommand *navSearchCommand;
@property (nonatomic, readwrite, strong) RACCommand *rateCommand;

@end

@implementation FancySearchViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.sizeSub = [RACSubject subject];
    self.sizeBtnTitle = @"克拉段";
    self.certBtnTitle = @"GIA";
    self.certSub = [RACSubject subject];
    self.shapeSub = [RACSubject subject];
    self.strengthSub = [RACSubject subject];
    self.lustreSub = [RACSubject subject];
    self.colorSub = [RACSubject subject];
    self.claritySub = [RACSubject subject];
    self.cutSub = [RACSubject subject];
    self.flourSub = [RACSubject subject];
    self.clickSub = [RACSubject subject];
    self.diam.addNum = @"0";
    
    self.diam = [[DiamSearchModel alloc] init];
    
    self.sizeArray = @[@"克拉段",@"0.3 - 0.39",@"0.4 - 0.49",@"0.5 - 0.59",@"0.6 - 0.69",@"0.7 - 0.79",@"0.8 - 0.89",@"0.9 - 0.99",@"1.00 - 1.09",@"1.1 - 1.49",@"1.5 - 1.99",@"2.0 - 2.99",@"3.0 - 3.99",@"4.0 - 4.99",@"5.0 - 20"];
    self.certArray = @[@"GIA",@"IGI",@"EGL",@"HRD",@"NGTC",@"Other"];
    
    @weakify(self);
    self.navSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SearchViewModel *viewModel = [[SearchViewModel alloc] initWithServices:self.services params:@{ViewModelTypeKey:@1}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.rateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        URLParameters *parameters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_METAL_BRAND parameters:subscript.dictionary];
        return [[[self.services.client enqueueParameter:parameters resultClass:DollarRate.class] doNext:^(HTTPResponse *response) {
            @strongify(self);
            DollarRate *dr = response.parsedResult;
            self.diam.dollarRate = [NSString stringWithFormat:@"%.2f", dr.dollarRate.floatValue];
        }] doError:^(NSError *error) {
            @strongify(self);
            self.diam.dollarRate = @"0.00";
        }];
    }];
    [self.rateCommand execute:nil];
    
    self.resetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.shapeSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.strengthSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.lustreSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.colorSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.claritySelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.cutSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.flourSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.sizeBtnTitle = @"克拉段";
        self.certBtnTitle = @"GIA";
        self.diam.sizeMin = @"";
        self.diam.sizeMax = @"";
        self.diam.certNo = @"";
        self.diam.detail = @"";
        self.diam.dRef = @"";
        self.diam.addNum = @"0.00";
        return [RACSignal empty];
    }];
    
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (kStringIsNotEmpty(self.diam.shape)) {
            self.diam.shape = [self.diam.shape stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.shape = [self.diam.shape substringWithRange:NSMakeRange(0, self.diam.shape.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.strength)) {
            self.diam.strength = [self.diam.strength stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.strength = [self.diam.strength substringWithRange:NSMakeRange(0, self.diam.strength.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.lustre)) {
            self.diam.lustre = [self.diam.lustre stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.lustre = [self.diam.lustre substringWithRange:NSMakeRange(0, self.diam.lustre.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.color)) {
            self.diam.color = [self.diam.color stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.color = [self.diam.color substringWithRange:NSMakeRange(0, self.diam.color.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.clarity)) {
            self.diam.clarity = [self.diam.clarity stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.clarity = [self.diam.clarity substringWithRange:NSMakeRange(0, self.diam.clarity.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.flour)) {
            self.diam.flour = [self.diam.flour stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.flour = [self.diam.flour substringWithRange:NSMakeRange(0, self.diam.flour.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.polish)) {
            self.diam.polish = [self.diam.polish stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.polish = [self.diam.polish substringWithRange:NSMakeRange(0, self.diam.polish.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.sym)) {
            self.diam.sym = [self.diam.sym stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.sym = [self.diam.sym substringWithRange:NSMakeRange(0, self.diam.sym.length-1)];
        }
        DiamSearchResultViewModel *viewModel = [[DiamSearchResultViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"彩钻结果",ViewModelModelKey:self.diam,ViewModelTypeKey:@2}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    [self.shapeSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.shapeSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.shapeSelect = [array copy];
    }];
    
    [self.strengthSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.strengthSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.strengthSelect = [array copy];
    }];
    [self.lustreSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.lustreSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.lustreSelect = [array copy];
    }];
    [self.colorSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.colorSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.colorSelect = [array copy];
    }];
    [self.claritySub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.claritySelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.claritySelect = [array copy];
    }];
    [self.cutSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.cutSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.cutSelect = [array copy];
    }];
    [self.flourSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.flourSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.flourSelect = [array copy];
    }];
    
    [self _dealDataSource];
}

- (void)_dealDataSource {
    BOOL hasAdd = [SingleInstance boolForKey:FancyRapKey];
    BOOL hasRate = ![[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.zuanshi.hk"] && [SingleInstance boolForKey:DollarShowKey];
    DiamGroupViewModel *group1 = [DiamGroupViewModel groupViewModel];
    group1.footerHeight = ZGCConvertToPx(10);
    FancySearchItemViewModel *search = [FancySearchItemViewModel itemViewModelWithTitle:@""];
    RACChannelTo(self.diam, certNo) = RACChannelTo(search, certNo);
    if (hasAdd) {
        RACChannelTo(self.diam, addNum) = RACChannelTo(search, addNum);
        if (hasRate)
            RACChannelTo(search, rate) = RACChannelTo(self.diam, dollarRate);
    }
    RACChannelTo(self.diam, sizeMin) = RACChannelTo(search, sizeMin);
    RACChannelTo(self.diam, sizeMax) = RACChannelTo(search, sizeMax);
    RAC(search, sizeBtnTitle) = RACObserve(self, sizeBtnTitle);
    RAC(search, certBtnTitle) = RACObserve(self, certBtnTitle);
    RAC(self.diam, cert) = RACObserve(self, certBtnTitle);
    search.sizeSub = self.sizeSub;
    search.certSub = self.certSub;
    group1.itemViewModels = @[search];
    
    CGFloat searchHeight = ZGCConvertToPx(172);
    if (hasAdd) {
        searchHeight += ZGCConvertToPx(54);
    }
    search.rowHeight = searchHeight;
    group1.itemViewModels = @[search];
    
    DiamGroupViewModel *group2 = [DiamGroupViewModel groupViewModel];
    group2.titleStr = @"形状";
    group2.headerBackColor = UIColor.whiteColor;
    group2.headerHeight = ZGCConvertToPx(44);
    group2.footerHeight = ZGCConvertToPx(10);
    FancyShapeItemViewModel *shape = [FancyShapeItemViewModel itemViewModelWithTitle:@""];
    shape.rowHeight = ZGCConvertToPx(146);
    RACChannelTo(self, shapeSelect) = RACChannelTo(shape, selectArr);
    RAC(group2, valueStr) = RACObserve(shape, selectTitle);
    RAC(self.diam, shape) = RACObserve(shape, selectTitle);
    shape.clickSub = self.shapeSub;
    __block DiamGroupViewModel *blockGroup2 = group2;
    group2.operation = ^{
        blockGroup2.closed = !blockGroup2.closed;
        blockGroup2.itemViewModels = blockGroup2.closed?@[]:@[shape];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:1 withObject:blockGroup2];
        self.dataSource = [source copy];
    };
    group2.itemViewModels = @[shape];
    
    DiamGroupViewModel *group3 = [DiamGroupViewModel groupViewModel];
    group3.titleStr = @"强度";
    group3.headerBackColor = UIColor.whiteColor;
    group3.headerHeight = ZGCConvertToPx(44);
    group3.footerHeight = ZGCConvertToPx(10);
    StrengthItemViewModel *strength = [StrengthItemViewModel itemViewModelWithTitle:@""];
    strength.rowHeight = ZGCConvertToPx(136);
    RACChannelTo(self, strengthSelect) = RACChannelTo(strength, selectArr);
    RAC(group3, valueStr) = RACObserve(strength, selectTitle);
    RAC(self.diam, strength) = RACObserve(strength, selectTitle);
    strength.clickSub = self.strengthSub;
    __block DiamGroupViewModel *blockGroup3 = group3;
    group3.operation = ^{
        blockGroup3.closed = !blockGroup3.closed;
        blockGroup3.itemViewModels = blockGroup3.closed?@[]:@[strength];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:2 withObject:blockGroup3];
        self.dataSource = [source copy];
    };
    group3.itemViewModels = @[strength];
    
    DiamGroupViewModel *group4 = [DiamGroupViewModel groupViewModel];
    group4.titleStr = @"光彩";
    group4.headerBackColor = UIColor.whiteColor;
    group4.headerHeight = ZGCConvertToPx(44);
    group4.footerHeight = ZGCConvertToPx(10);
    LustreItemViewModel *lustre = [LustreItemViewModel itemViewModelWithTitle:@""];
    lustre.rowHeight = ZGCConvertToPx(178);
    RACChannelTo(self, lustreSelect) = RACChannelTo(lustre, selectArr);
    RAC(group4, valueStr) = RACObserve(lustre, selectTitle);
    RAC(self.diam, lustre) = RACObserve(lustre, selectTitle);
    lustre.clickSub = self.lustreSub;
    __block DiamGroupViewModel *blockGroup4 = group4;
    group4.operation = ^{
        blockGroup4.closed = !blockGroup4.closed;
        blockGroup4.itemViewModels = blockGroup4.closed?@[]:@[lustre];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:3 withObject:blockGroup4];
        self.dataSource = [source copy];
    };
    group4.itemViewModels = @[lustre];
    
    DiamGroupViewModel *group5 = [DiamGroupViewModel groupViewModel];
    group5.titleStr = @"颜色";
    group5.headerBackColor = UIColor.whiteColor;
    group5.headerHeight = ZGCConvertToPx(44);
    group5.footerHeight = ZGCConvertToPx(10);
    FancyColorItemViewModel *color = [FancyColorItemViewModel itemViewModelWithTitle:@""];
    color.rowHeight = ZGCConvertToPx(94);
    RACChannelTo(self, colorSelect) = RACChannelTo(color, selectArr);
    RAC(group5, valueStr) = RACObserve(color, selectTitle);
    RAC(self.diam, color) = RACObserve(color, selectTitle);
    color.clickSub = self.colorSub;
    __block DiamGroupViewModel *blockGroup5 = group5;
    group5.operation = ^{
        blockGroup5.closed = !blockGroup5.closed;
        blockGroup5.itemViewModels = blockGroup5.closed?@[]:@[color];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:4 withObject:blockGroup5];
        self.dataSource = [source copy];
    };
    group5.itemViewModels = @[color];
    
    DiamGroupViewModel *group6 = [DiamGroupViewModel groupViewModel];
    group6.titleStr = @"净度";
    group6.headerBackColor = UIColor.whiteColor;
    group6.headerHeight = ZGCConvertToPx(44);
    group6.footerHeight = ZGCConvertToPx(10);
    ClarityItemViewModel *clarity = [ClarityItemViewModel itemViewModelWithTitle:@""];
    clarity.rowHeight = ZGCConvertToPx(94);
    RACChannelTo(self, claritySelect) = RACChannelTo(clarity, selectArr);
    RAC(group6, valueStr) = RACObserve(clarity, selectTitle);
    RAC(self.diam, clarity) = RACObserve(clarity, selectTitle);
    clarity.clickSub = self.claritySub;
    __block DiamGroupViewModel *blockGroup6 = group6;
    group6.operation = ^{
        blockGroup6.closed = !blockGroup6.closed;
        blockGroup6.itemViewModels = blockGroup6.closed?@[]:@[clarity];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:5 withObject:blockGroup6];
        self.dataSource = [source copy];
    };
    group6.itemViewModels = @[clarity];
    
    DiamGroupViewModel *group7 = [DiamGroupViewModel groupViewModel];
    group7.footerHeight = ZGCConvertToPx(10);
    FancyCutItemViewModel *cut = [FancyCutItemViewModel itemViewModelWithTitle:@""];
    cut.rowHeight = ZGCConvertToPx(88);
    RACChannelTo(self, cutSelect) = RACChannelTo(cut, selectArr);
//    RAC(self.diam, cut) = RACObserve(cut, cutSelectTitle);
    RAC(self.diam, polish) = RACObserve(cut, polishSelectTitle);
    RAC(self.diam, sym) = RACObserve(cut, symSelectTitle);
    cut.clickSub = self.cutSub;
    group7.itemViewModels = @[cut];
    
    DiamGroupViewModel *group8 = [DiamGroupViewModel groupViewModel];
    group8.footerHeight = ZGCConvertToPx(10);
    FlourItemViewModel *flour = [FlourItemViewModel itemViewModelWithTitle:@""];
    RACChannelTo(self, flourSelect) = RACChannelTo(flour, selectArr);
    RAC(self.diam, flour) = RACObserve(flour, selectTitle);
    flour.clickSub = self.flourSub;
    group8.itemViewModels = @[flour];
    
    self.dataSource = @[group1, group2, group3, group4, group5, group6, group7, group8];
}

@end
