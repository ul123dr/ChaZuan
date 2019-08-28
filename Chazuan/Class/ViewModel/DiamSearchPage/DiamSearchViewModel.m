//
//  DiamSearchViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSearchViewModel.h"
#import "DollarRate.h"
#import "DiamSearchModel.h"

@interface DiamSearchViewModel ()

@property (nonatomic, readwrite, strong) DiamSearchModel *diam;

@property (nonatomic, readwrite, strong) NSArray *shapeSelect;
@property (nonatomic, readwrite, strong) RACSubject *shapeSub;

@property (nonatomic, readwrite, strong) NSArray *sizeArray;
@property (nonatomic, readwrite, strong) RACSubject *sizeSub;

@property (nonatomic, readwrite, strong) NSArray *colorSelect;
@property (nonatomic, readwrite, strong) RACSubject *colorSub;

@property (nonatomic, readwrite, strong) NSArray *claritySelect;
@property (nonatomic, readwrite, strong) RACSubject *claritySub;

@property (nonatomic, readwrite, strong) NSArray *cutSelect;
@property (nonatomic, readwrite, strong) RACSubject *cutSub;

@property (nonatomic, readwrite, strong) NSArray *flourSelect;
@property (nonatomic, readwrite, strong) RACSubject *flourSub;

@property (nonatomic, readwrite, strong) NSArray *certSelect;
@property (nonatomic, readwrite, strong) RACSubject *certSub;

@property (nonatomic, readwrite, strong) NSArray *locationSelect;
@property (nonatomic, readwrite, strong) RACSubject *locationSub;

@property (nonatomic, readwrite, strong) NSArray *milkSelect;
@property (nonatomic, readwrite, strong) RACSubject *milkSub;
@property (nonatomic, readwrite, strong) NSArray *blackSelect;
@property (nonatomic, readwrite, strong) RACSubject *blackSub;

@property (nonatomic, readwrite, strong) RACCommand *resetCommand;
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
@property (nonatomic, readwrite, strong) RACCommand *navSearchCommand;
@property (nonatomic, readwrite, strong) RACCommand *rateCommand;

@end

@implementation DiamSearchViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.shapeSub = [RACSubject subject];
    self.sizeBtnTitle = @"克拉段";
    self.sizeSub = [RACSubject subject];
    self.colorSub = [RACSubject subject];
    self.claritySub = [RACSubject subject];
    self.cutSub = [RACSubject subject];
    self.flourSub = [RACSubject subject];
    self.certSub = [RACSubject subject];
    self.locationSub = [RACSubject subject];
    self.milkSub = [RACSubject subject];
    self.blackSub = [RACSubject subject];
    self.diam.addNum = @"0";
    
    self.diam = [[DiamSearchModel alloc] init];
    self.diam.status = @"";
    
    self.sizeArray = @[@"克拉段",@"0.3 - 0.39",@"0.4 - 0.49",@"0.5 - 0.59",@"0.6 - 0.69",@"0.7 - 0.79",@"0.8 - 0.89",@"0.9 - 0.99",@"1.00 - 1.09",@"1.1 - 1.49",@"1.5 - 1.99",@"2.0 - 2.99",@"3.0 - 3.99",@"4.0 - 4.99",@"5.0 - 20"];
    
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
        self.colorSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.claritySelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.cutSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.flourSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.certSelect = @[@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.locationSelect = @[@(NO),@(NO),@(NO)];
        self.milkSelect = @[@(NO),@(NO),@(NO),@(NO)];
        self.blackSelect = @[@(NO),@(NO)];
        self.sizeBtnTitle = @"克拉段";
        self.diam.sizeMin = @"";
        self.diam.sizeMax = @"";
        self.diam.certNo = @"";
        self.diam.detail = @"";
        self.diam.dRef = @"";
        self.diam.addNum = @"0.00";
        self.diam.status = @"-1";
        return [RACSignal empty];
    }];
    
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (kStringIsNotEmpty(self.diam.cert)) {
            self.diam.cert = [self.diam.cert stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.cert = [self.diam.cert substringWithRange:NSMakeRange(0, self.diam.cert.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.shape)) {
            self.diam.shape = [self.diam.shape stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.shape = [self.diam.shape substringWithRange:NSMakeRange(0, self.diam.shape.length-1)];
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
        if (kStringIsNotEmpty(self.diam.location)) {
            self.diam.location = [self.diam.location stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.location = [self.diam.location substringWithRange:NSMakeRange(0, self.diam.location.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.cut)) {
            self.diam.cut = [self.diam.cut stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.cut = [self.diam.cut substringWithRange:NSMakeRange(0, self.diam.cut.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.polish)) {
            self.diam.polish = [self.diam.polish stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.polish = [self.diam.polish substringWithRange:NSMakeRange(0, self.diam.polish.length-1)];
        }
        if (kStringIsNotEmpty(self.diam.sym)) {
            self.diam.sym = [self.diam.sym stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.diam.sym = [self.diam.sym substringWithRange:NSMakeRange(0, self.diam.sym.length-1)];
        }        
        DiamSearchResultViewModel *viewModel = [[DiamSearchResultViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"白钻结果",ViewModelModelKey:self.diam,ViewModelTypeKey:@1}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    [self.shapeSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.shapeSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.shapeSelect = [array copy];
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
        NSMutableArray *cutArray = [NSMutableArray array];
        NSMutableArray *polishArray = [NSMutableArray array];
        NSMutableArray *symArray = [NSMutableArray array];
        NSInteger index = [x.first integerValue];
        if (index < 4) {
            for (int i = 0; i < 4; i++) {
                if (i <= index && [x.second boolValue]) {
                    [cutArray addObject:@(YES)];
                    [polishArray addObject:@(YES)];
                    [symArray addObject:@(YES)];
                } else {
                    [cutArray addObject:@(NO)];
                    [polishArray addObject:@(NO)];
                    [symArray addObject:@(NO)];
                }
            }
            [array replaceObjectsInRange:NSMakeRange(0, 4) withObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO)]];
            [array replaceObjectsInRange:NSMakeRange(4, 4) withObjectsFromArray:[cutArray copy]];
            [array replaceObjectsInRange:NSMakeRange(8, 4) withObjectsFromArray:[polishArray copy]];
            [array replaceObjectsInRange:NSMakeRange(12, 4) withObjectsFromArray:[symArray copy]];
        } else {
            [array replaceObjectsInRange:NSMakeRange(0, 4) withObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO)]];
        }
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.cutSelect = [array copy];
    }];
    
    [self.flourSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.flourSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.flourSelect = [array copy];
    }];
    
    [self.certSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.certSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.certSelect = [array copy];
    }];
    
    [self.locationSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.locationSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.locationSelect = [array copy];
    }];
    
    [self.milkSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.milkSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.milkSelect = [array copy];
    }];
    
    [self.blackSub subscribeNext:^(RACTuple *x) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.blackSelect];
        [array replaceObjectAtIndex:[x.first integerValue] withObject:x.second];
        self.blackSelect = [array copy];
    }];
    
    [self _dealDataSource];
}

- (void)_dealDataSource {
    DiamGroupViewModel *group1 = [DiamGroupViewModel groupViewModel];
    group1.titleStr = @"形状";
    group1.headerBackColor = UIColor.whiteColor;
    group1.headerHeight = ZGCConvertToPx(44);
    group1.footerHeight = ZGCConvertToPx(10);
    ShapeItemViewModel *shape = [ShapeItemViewModel itemViewModelWithTitle:@""];
    shape.rowHeight = ZGCConvertToPx(146);
    RACChannelTo(self, shapeSelect) = RACChannelTo(shape, selectArr);
    RAC(group1, valueStr) = RACObserve(shape, selectTitle);
    RAC(self.diam, shape) = RACObserve(shape, selectTitle);
    shape.clickSub = self.shapeSub;
    __block DiamGroupViewModel *blockGroup1 = group1;
    group1.operation = ^{
        blockGroup1.closed = !blockGroup1.closed;
        blockGroup1.itemViewModels = blockGroup1.closed?@[]:@[shape];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:0 withObject:blockGroup1];
        self.dataSource = [source copy];
    };
    group1.itemViewModels = @[shape];
    
    DiamGroupViewModel *group2 = [DiamGroupViewModel groupViewModel];
    group2.footerHeight = ZGCConvertToPx(10);
    SizeItemViewModel *size = [SizeItemViewModel itemViewModelWithTitle:@""];
    size.rowHeight = ZGCConvertToPx(64);
    RAC(size, btnTitle) = RACObserve(self, sizeBtnTitle);
    RACChannelTo(size, sizeMin) = RACChannelTo(self.diam, sizeMin);
    RACChannelTo(size, sizeMax) = RACChannelTo(self.diam, sizeMax);
    size.sizeSub = self.sizeSub;
    group2.itemViewModels = @[size];
    
    DiamGroupViewModel *group3 = [DiamGroupViewModel groupViewModel];
    group3.titleStr = @"颜色";
    group3.headerBackColor = UIColor.whiteColor;
    group3.headerHeight = ZGCConvertToPx(44);
    group3.footerHeight = ZGCConvertToPx(10);
    ColorItemViewModel *color = [ColorItemViewModel itemViewModelWithTitle:@""];
    color.rowHeight = ZGCConvertToPx(136);
    RACChannelTo(self, colorSelect) = RACChannelTo(color, selectArr);
    RAC(group3, valueStr) = RACObserve(color, selectTitle);
    RAC(self.diam, color) = RACObserve(color, selectTitle);
    color.clickSub = self.colorSub;
    __block DiamGroupViewModel *blockGroup3 = group3;
    group3.operation = ^{
        blockGroup3.closed = !blockGroup3.closed;
        blockGroup3.itemViewModels = blockGroup3.closed?@[]:@[color];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:2 withObject:blockGroup3];
        self.dataSource = [source copy];
    };
    group3.itemViewModels = @[color];
    
    DiamGroupViewModel *group4 = [DiamGroupViewModel groupViewModel];
    group4.titleStr = @"净度";
    group4.headerBackColor = UIColor.whiteColor;
    group4.headerHeight = ZGCConvertToPx(44);
    group4.footerHeight = ZGCConvertToPx(10);
    ClarityItemViewModel *clarity = [ClarityItemViewModel itemViewModelWithTitle:@""];
    clarity.rowHeight = ZGCConvertToPx(94);
    RACChannelTo(self, claritySelect) = RACChannelTo(clarity, selectArr);
    RAC(group4, valueStr) = RACObserve(clarity, selectTitle);
    RAC(self.diam, clarity) = RACObserve(clarity, selectTitle);
    clarity.clickSub = self.claritySub;
    __block DiamGroupViewModel *blockGroup4 = group4;
    group4.operation = ^{
        blockGroup4.closed = !blockGroup4.closed;
        blockGroup4.itemViewModels = blockGroup4.closed?@[]:@[clarity];
        NSMutableArray *source = [NSMutableArray arrayWithArray:self.dataSource];
        [source replaceObjectAtIndex:3 withObject:blockGroup4];
        self.dataSource = [source copy];
    };
    group4.itemViewModels = @[clarity];
    
    DiamGroupViewModel *group5 = [DiamGroupViewModel groupViewModel];
    group5.footerHeight = ZGCConvertToPx(10);
    CutItemViewModel *cut = [CutItemViewModel itemViewModelWithTitle:@""];
    cut.rowHeight = ZGCConvertToPx(186);
    RACChannelTo(self, cutSelect) = RACChannelTo(cut, selectArr);
    RAC(self.diam, cut) = RACObserve(cut, cutSelectTitle);
    RAC(self.diam, polish) = RACObserve(cut, polishSelectTitle);
    RAC(self.diam, sym) = RACObserve(cut, symSelectTitle);
    cut.clickSub = self.cutSub;
    group5.itemViewModels = @[cut];
    
    DiamGroupViewModel *group6 = [DiamGroupViewModel groupViewModel];
    group6.footerHeight = ZGCConvertToPx(10);
    FlourItemViewModel *flour = [FlourItemViewModel itemViewModelWithTitle:@""];
    RACChannelTo(self, flourSelect) = RACChannelTo(flour, selectArr);
    RAC(self.diam, flour) = RACObserve(flour, selectTitle);
    flour.clickSub = self.flourSub;
    group6.itemViewModels = @[flour];
    
    DiamGroupViewModel *group7 = [DiamGroupViewModel groupViewModel];
    group7.footerHeight = ZGCConvertToPx(10);
    CertItemViewModel *cert = [CertItemViewModel itemViewModelWithTitle:@""];
    cert.rowHeight = ZGCConvertToPx(88);
    RACChannelTo(self, certSelect) = RACChannelTo(cert, selectArr);
    RAC(self.diam, cert) = RACObserve(cert, selectTitle);
    cert.clickSub = self.certSub;
    group7.itemViewModels = @[cert];
    
    DiamGroupViewModel *group8 = [DiamGroupViewModel groupViewModel];
    group8.footerHeight = ZGCConvertToPx(47);
    group8.showBtn = YES;
    __block DiamGroupViewModel *block8 = group8;
    group8.operation = ^{
        [self _showMoreSearch:block8];
    };
    LocationItemViewModel *location = [LocationItemViewModel itemViewModelWithTitle:@""];
    location.rowHeight = ZGCConvertToPx(44);
    RACChannelTo(self, locationSelect) = RACChannelTo(location, selectArr);
    RAC(self.diam, location) = RACObserve(location, selectTitle);
    location.clickSub = self.locationSub;
    group8.itemViewModels = @[location];
    
    self.dataSource = @[group1, group2, group3, group4, group5, group6, group7, group8];
}

- (void)_showMoreSearch:(DiamGroupViewModel *)group {
    @weakify(self);
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
    group.showBtn = NO;
    group.footerHeight = ZGCConvertToPx(10);
    [array replaceObjectAtIndex:self.dataSource.count-1 withObject:group];
    
    DiamGroupViewModel *group9 = [DiamGroupViewModel groupViewModel];
    group9.footerHeight = ZGCConvertToPx(10);
    MilkItemViewModel *milk = [MilkItemViewModel itemViewModelWithTitle:@""];
    CGFloat milkHeight = 0;
    if ([SingleInstance boolForKey:MbgShowKey]) {
        milkHeight += ZGCConvertToPx(44);
        milk.milkClickSub = self.milkSub;
        RACChannelTo(self, milkSelect) = RACChannelTo(milk, milkSelectArr);
        [RACObserve(milk, milkSelectTitle) subscribeNext:^(NSString *title) {
            @strongify(self);
            NSArray *milkArr = @[];
            NSArray *brownArr = @[];
            NSArray *greenArr = @[];
            NSArray *mbgArr = @[];
            if (kStringIsEmpty(title)) {
                self.diam.milk = @"";
                self.diam.browness = @"";
                self.diam.green = @"";
                self.diam.mgb = @[];
            } else {
                for (NSString *str in [title componentsSeparatedByString:@"，"]) {
                    if ([str isEqualToString:@"无奶咖"]) {
                        milkArr = [milkArr arrayByAddingObject:@"N"];
                        brownArr = [brownArr arrayByAddingObject:@"N"];
                        mbgArr = [mbgArr arrayByAddingObject:@"wnk"];
                    } else if ([str isEqualToString:@"无奶"]) {
                        milkArr = [milkArr arrayByAddingObject:@"N"];
                        mbgArr = [mbgArr arrayByAddingObject:@"wn"];
                    } else if ([str isEqualToString:@"无咖"]) {
                        brownArr = [brownArr arrayByAddingObject:@"N"];
                        mbgArr = [mbgArr arrayByAddingObject:@"wk"];
                    } else if ([str isEqualToString:@"无绿"]) {
                        greenArr = [greenArr arrayByAddingObject:@"N"];
                        mbgArr = [mbgArr arrayByAddingObject:@"wl"];
                    } else if ([str isEqualToString:@"待查"]) {
                        mbgArr = [mbgArr arrayByAddingObject:@"待查"];
                        milkArr = [milkArr arrayByAddingObject:@"待查"];
                        brownArr = [brownArr arrayByAddingObject:@"待查"];
                        greenArr = [greenArr arrayByAddingObject:@"待查"];
                    }
                }
                self.diam.milk = [milkArr componentsJoinedByString:@","];
                self.diam.browness = [brownArr componentsJoinedByString:@","];
                self.diam.green = [greenArr componentsJoinedByString:@","];
                self.diam.mgb = mbgArr;
            }
        }];
    }
    if ([SingleInstance boolForKey:BlackShowKey]) {
        milkHeight += ZGCConvertToPx(44);
        milk.blackClickSub = self.blackSub;
        RACChannelTo(self, blackSelect) = RACChannelTo(milk, blackSelectArr);
        [RACObserve(milk, blackSelectTitle) subscribeNext:^(NSString *title) {
            @strongify(self);
            NSArray *blackArr = @[];
            if (kStringIsEmpty(title)) {
                self.diam.black = @"";
                self.diam.blackChoose = @[];
            } else {
                for (NSString *str in [title componentsSeparatedByString:@"，"]) {
                    if ([str isEqualToString:@"无黑"]) {
                        blackArr = [blackArr arrayByAddingObject:@"N"];
                    } else if ([str isEqualToString:@"待查"]) {
                        blackArr = [blackArr arrayByAddingObject:@"待查"];
                    }
                }
                self.diam.blackChoose = blackArr;
                self.diam.black = [blackArr componentsJoinedByString:@","];
            }
        }];
    }
    if (milkHeight > 0) {
        milk.rowHeight = milkHeight;
        group9.itemViewModels = @[milk];
        [array addObject:group9];
    }
    
    BOOL hasDetail = SharedAppDelegate.manager.gid.integerValue == 0 && [SingleInstance boolForKey:RapIdShowKey];
    BOOL hasAdd = [SingleInstance boolForKey:DiscShowKey];
    BOOL hadRate = ![[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.zuanshi.hk"] && [SingleInstance boolForKey:DollarShowKey];
    
    DiamGroupViewModel *group10 = [DiamGroupViewModel groupViewModel];
    group10.footerHeight = ZGCConvertToPx(10);
    DiamSearchItemViewModel *search = [DiamSearchItemViewModel itemViewModelWithTitle:@""];
    search.rate = self.diam.dollarRate;
    RACChannelTo(self.diam, certNo) = RACChannelTo(search, certNo);
    if (hasDetail)
        RACChannelTo(self.diam, detail) = RACChannelTo(search, detail);
    RACChannelTo(self.diam, dRef) = RACChannelTo(search, dRef);
    if (hasAdd) {
        RACChannelTo(self.diam, addNum) = RACChannelTo(search, addNum);
        if (hadRate)
            RACChannelTo(search, rate) = RACChannelTo(self.diam, dollarRate);
    }
    group10.itemViewModels = @[search];
    
    CGFloat searchHeight = ZGCConvertToPx(118);
    if (hasDetail) {
        searchHeight += ZGCConvertToPx(54);
    }
    if (hasAdd) {
        searchHeight += ZGCConvertToPx(54);
    }
    search.rowHeight = searchHeight;
    [array addObject:group10];
    
    self.dataSource = [array copy];
}

@end
