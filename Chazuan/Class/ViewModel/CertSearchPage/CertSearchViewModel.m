//
//  CertSearchViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSearchViewModel.h"
#import "CertSearchModel.h"

@interface CertSearchViewModel ()
// 证书列表
@property (nonatomic, readwrite, strong) NSArray *certList;

@property (nonatomic, readwrite, strong) NSArray *certArray;
@property (nonatomic, readwrite, assign) NSInteger certIndex;
@property (nonatomic, readwrite, assign) BOOL open;

@property (nonatomic, readwrite, copy) NSString *certName;
@property (nonatomic, readwrite, copy) NSString *searchText;

@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
@property (nonatomic, readwrite, strong) RACCommand *pdfCommand;

@property (nonatomic, readwrite, strong) CertSearchList *certModel;

// 网络请求错误
@property (nonatomic, readwrite, strong) NSError *error;

@end

@implementation CertSearchViewModel

- (void)initialize {
    [super initialize];
    
    self.backgroundColor = COLOR_BG;
    self.shouldMultiSections = YES;
    self.selectHeight = ZGCConvertToPx(123);
    
    @weakify(self);
    [RACObserve(self, certIndex) subscribeNext:^(NSNumber *index) {
        @strongify(self);
        self.certName = [self nameOfCert:self.certArray[index.integerValue]];
    }];

    [RACObserve(self, type) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.integerValue == 2) {
            self.certArray = @[@"NGTC",@"BEIDA",@"GTC",@"GIC",@"NJQSIC",@"CCGTC",@"NGSTC",@"GDTC",@"NGDTC",@"CQT",@"GIB",@"CGJC",@"GGC",@"CGJ"];
        } else {
            self.certArray = @[@"GIA",@"IGI",@"HRD",@"GRS",@"AISG",@"Gubelin",@"LOTUS",@"AGS",@"EGL"];
        }
        self.certIndex = 0;
        self.open = NO;
    }];
    
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id obj) {
        @weakify(self);
        if (![obj isKindOfClass:ZGButton.class]) {
            if (kObjectIsNotNil(obj)) {
                self.certIndex = ((NSNumber *)obj).integerValue;
            }
        }
        if (kStringIsEmpty(self.searchText)) {
            [SVProgressHUD showErrorWithStatus:@"请输入证书编号"];
            return [RACSignal empty];
        }
        self.dataSource = [self.dataSource subarrayWithRange:NSMakeRange(0, 2)];
        
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"cert"] = self.certArray[self.certIndex];
        subscript[@"certNo"] = self.searchText;
        
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_SEARCH_CERT parameters:subscript.dictionary];
        return [[[[self.services.client enqueueParameter:paramters resultClass:CertSearchModel.class] takeUntil:self.rac_willDeallocSignal] doNext:^(HTTPResponse *response) {
            @strongify(self);
            CertSearchModel *model = response.parsedResult;
            if (model.appCheckCode) {
                [self.services.client loginAtOtherPlace];
            } else {
                if (model.list.count == 0) {
                    [self goSearchOther];
                } else {
                    [self initDataSource:model.list.firstObject];
                }
            }
        }] doError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"查询失败"];
        }];
    }];
    
    self.pdfCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        PdfViewModel *viewModel = [[PdfViewModel alloc] initWithServices:self.services params:@{ViewModelTitleKey:@"证书图",ViewModelPdfUrlKey:self.certModel.certificate,ViewModelPdfTypeKey:self.certArray[self.certIndex]}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    [self initDataSource:nil];
    
    NSString *certType = self.params[ViewModelTypeKey];
    if ([self.certArray containsObject:certType]) {
        self.searchText = self.params[ViewModelCertNoKey];
        [self.searchCommand execute:@([self.certArray indexOfObject:certType])];
    }
}

- (void)goSearchOther {
    @weakify(self);
    KeyedSubscript *subscript = [KeyedSubscript subscript];
    subscript[@"cert"] = self.certArray[self.certIndex];
    subscript[@"certNo"] = self.searchText;
    
    URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_SEARCH_OTHER_CERT parameters:subscript.dictionary];
    [[[self.services.client enqueueParameter:paramters resultClass:CertSearchList.class] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(HTTPResponse *response) {
        @strongify(self);
        CertSearchList *list = response.parsedResult;
        if (kStringIsNotEmpty(list.certificate)) {
            list.certNo = self.searchText;
            list.cert = self.certArray[self.certIndex];
            [self initDataSource:list];
        } else {
            [SVProgressHUD showErrorWithStatus:@"查询失败"];
        }
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (void)initDataSource:(CertSearchList *)certList {
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = ZGCConvertToPx(20);
    CertSelectItemViewModel *certViewModel = [CertSelectItemViewModel itemViewModelWithTitle:@""];
    RAC(certViewModel, rowHeight) = [RACObserve(self, selectHeight) takeUntil:self.rac_willDeallocSignal];
    RAC(certViewModel, cartData) = [RACObserve(self, certArray) takeUntil:self.rac_willDeallocSignal];
    RACChannelTo(certViewModel, certIndex) = RACChannelTo(self, certIndex);
    RACChannelTo(certViewModel, open) = RACChannelTo(self, open);
    group1.itemViewModels = @[certViewModel];
    
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.footerHeight = ZGCConvertToPx(10);
    CertSearchItemViewModel *searchViewModel = [CertSearchItemViewModel itemViewModelWithTitle:@""];
    searchViewModel.rowHeight = ZGCConvertToPx(204);
    RACChannelTo(searchViewModel, certTitle) = RACChannelTo(self, certName);
    RACChannelTo(searchViewModel, searchText) = RACChannelTo(self, searchText);
    searchViewModel.searchCommand = self.searchCommand;
    group2.itemViewModels = @[searchViewModel];
    
    self.dataSource = [@[group1, group2] arrayByAddingObjectsFromArray:[self dataSourceWithCertList:certList]];
}

- (NSArray *)dataSourceWithCertList:(CertSearchList *)certList {
    if (kObjectIsNil(certList)) return @[];

    self.certModel = certList;
    // 证书编号、证书机构、证书图
    CommonGroupViewModel *group1 = [CommonGroupViewModel groupViewModel];
    group1.footerHeight = ZGCConvertToPx(10);
    CertInfoItemViewModel *certNoViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    certNoViewModel.name = @"证书编号";
    certNoViewModel.valueName = certList.certNo;
    CertInfoItemViewModel *certViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    certViewModel.name = @"证书机构";
    certViewModel.valueName = certList.cert;
    if (kStringIsNotEmpty(certList.certificate)) {
        CertInfoItemViewModel *certifiViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
        certifiViewModel.name = @"证书图";
        certifiViewModel.showPdf = YES;
        certifiViewModel.pdfCommand = self.pdfCommand;
        group1.itemViewModels = @[certNoViewModel, certViewModel, certifiViewModel];
    } else {
        group1.itemViewModels = @[certNoViewModel, certViewModel];
    }
    // 形状、尺寸、重量、颜色、净度
    CommonGroupViewModel *group2 = [CommonGroupViewModel groupViewModel];
    group2.footerHeight = ZGCConvertToPx(10);
    CertInfoItemViewModel *shapeViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    shapeViewModel.name = @"形状";
    shapeViewModel.valueName = formatString(certList.shape);
    CertInfoItemViewModel *sizeViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    sizeViewModel.name = @"尺寸";
    if (kStringIsNotEmpty(certList.m1) && kStringIsNotEmpty(certList.m2) && kStringIsNotEmpty(certList.m3)) {
        sizeViewModel.valueName = [NSString stringWithFormat:@"%@ x %@ x %@", certList.m1, certList.m2, certList.m3];
    } else if ([[certList.m1 uppercaseString] componentsSeparatedByString:@"X"].count == 3) {
        sizeViewModel.valueName = certList.m1;
    } else {
        sizeViewModel.valueName = @"-";
    }
    CertInfoItemViewModel *weightViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    weightViewModel.name = @"重量";
    weightViewModel.valueName = formatString(certList.size);
    CertInfoItemViewModel *colorViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    colorViewModel.name = @"颜色";
    colorViewModel.valueName = formatString(certList.color);
    CertInfoItemViewModel *clarityViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    clarityViewModel.name = @"净度";
    clarityViewModel.valueName = formatString(certList.clarity);
    group2.itemViewModels = @[shapeViewModel, sizeViewModel, weightViewModel, colorViewModel, clarityViewModel];
    // 全深比、台宽比
    CommonGroupViewModel *group3 = [CommonGroupViewModel groupViewModel];
    group3.footerHeight = ZGCConvertToPx(10);
    CertInfoItemViewModel *depthViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    depthViewModel.name = @"全深比";
    depthViewModel.valueName = formatString(certList.depth);
    CertInfoItemViewModel *tableViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    tableViewModel.name = @"台宽比";
    tableViewModel.valueName = formatString(certList.table);
    group3.itemViewModels = @[depthViewModel, tableViewModel];
    // 切工、抛光、对称
    CommonGroupViewModel *group4 = [CommonGroupViewModel groupViewModel];
    group4.footerHeight = ZGCConvertToPx(10);
    CertInfoItemViewModel *cutViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    cutViewModel.name = @"切工";
    cutViewModel.valueName = formatString(certList.cut);
    CertInfoItemViewModel *polishViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    polishViewModel.name = @"抛光";
    polishViewModel.valueName = formatString(certList.polish);
    CertInfoItemViewModel *symViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    symViewModel.name = @"对称";
    symViewModel.valueName = formatString(certList.sym);
    group4.itemViewModels = @[cutViewModel, polishViewModel, symViewModel];
    // 荧光
    CommonGroupViewModel *group5 = [CommonGroupViewModel groupViewModel];
    group5.footerHeight = ZGCConvertToPx(10);
    CertInfoItemViewModel *floorViewModel = [CertInfoItemViewModel itemViewModelWithTitle:@""];
    floorViewModel.name = @"荧光";
    floorViewModel.valueName = formatString(certList.flour);
    group5.itemViewModels = @[floorViewModel];
    
    return @[group1, group2, group3, group4, group5];
}

- (NSString *)nameOfCert:(NSString *)cert {
    NSDictionary *certDict = @{@"GIA":@"美国宝石学院",
                               @"IGI":@"国际宝石学院",
                               @"HRD":@"比利时钻石高层议会",
                               @"GRS":@"瑞士宝石研究实验所",
                               @"AIGS":@"亚洲宝石学院",
                               @"Gubelin":@"古柏林宝石实验室",
                               @"LOTUS":@"曼谷宝石实验室",
                               @"AGS":@"美国宝玉石协会",
                               @"EGL":@"欧洲宝石学院",
                               @"NGTC":@"国家珠宝玉石质量监督检验中心",
                               @"BEIDA":@"北大宝石鉴定中心",
                               @"GTC":@"广东省珠宝玉石及贵金属检测中心",
                               @"GIC":@"中国地质大学珠宝学院",
                               @"NJQSIC":@"国家首饰质量监督检验中心",
                               @"CCGTC":@"中华全国工商联珠宝业商会珠宝检测研究中心",
                               @"NGSTC":@"国家金银制品质量鉴督检验中心(南京)",
                               @"GDTC":@"广东省金银珠宝检测中心",
                               @"NGDTC":@"国家黄金钻石制品质量监督检验中心",
                               @"CQT":@"中检质技(北京)金银珠宝质量检验中心",
                               @"GIB":@"北京地大宝石检验中心",
                               @"CGJC":@"中国商业联合会珠宝首饰质量监督检测中心",
                               @"GGC":@"浙江省黄金珠宝饰品质量检测中心",
                               @"CGJ":@"国检华南珠宝检测中心"
                               };
    if (kObjectIsNil([certDict objectForKey:cert])) return cert;
    return [NSString stringWithFormat:@"%@ %@", cert, certDict[cert]];
}

@end
