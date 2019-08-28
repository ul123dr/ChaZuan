//
//  QuoteViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QuoteViewModel.h"
#import "DiamResultList.h"

@interface QuoteViewModel ()

@property (nonatomic, readwrite, assign) BOOL diamQuoteShow;
@property (nonatomic, readwrite, strong) NSArray *list;

@property (nonatomic, readwrite, strong) RACSubject *cSub;

@end

@implementation QuoteViewModel

- (void)initialize {
    [super initialize];
    
    self.shouldMultiSections = YES;
    self.list = self.params[ViewModelModelKey];
    self.diamQuoteShow = [self.params[ViewModelTypeKey] boolValue];
    self.cSub = [RACSubject subject];
    
    [self _dealList];
    
    [self.cSub subscribeNext:^(QuoteItemViewModel *item) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = item.content;
        [SVProgressHUD showSuccessWithStatus:@"已复制，您可以任意粘贴了"];
    }];
}

- (void)_dealList {
    QuoteGroupViewModel *group1 = [QuoteGroupViewModel groupViewModel];
    group1.title = @"带证书号";
    group1.cSub = self.cSub;
    group1.headerHeight = ZGCConvertToPx(44);
    group1.footerHeight = ZGCConvertToPx(15);
    
    QuoteGroupViewModel *group2 = [QuoteGroupViewModel groupViewModel];
    group2.title = @"不带证书号";
    group2.cSub = self.cSub;
    group2.headerHeight = ZGCConvertToPx(44);
    group2.footerHeight = ZGCConvertToPx(15);
    
    QuoteGroupViewModel *group3 = [QuoteGroupViewModel groupViewModel];
    group3.title = @"带预售折扣";
    group3.cSub = self.cSub;
    group3.headerHeight = ZGCConvertToPx(44);
    group3.footerHeight = ZGCConvertToPx(45);
    
    if (self.diamQuoteShow)
        group3.footer = @"形状、克拉、颜色、净度、切工、抛光、对称、荧光、RMB/粒、证书类型、证书编号";
    else
        group3.footer = @"形状、克拉、规格、净度、抛光、对称、荧光、RMB/粒、证书类型、证书编号";
    
    QuoteItemViewModel *item1 = [QuoteItemViewModel itemViewModelWithTitle:@""];
    QuoteItemViewModel *item2 = [QuoteItemViewModel itemViewModelWithTitle:@""];
    QuoteItemViewModel *item3 = [QuoteItemViewModel itemViewModelWithTitle:@""];
    
    NSMutableArray *item1Arr = [NSMutableArray array];
    NSMutableArray *item2Arr = [NSMutableArray array];
    NSMutableArray *item3Arr = [NSMutableArray array];
    
    for (int i = 0; i < self.list.count; i++) {
        DiamResultList *list = self.list[i];
        NSString *str1 = @"", *str2 = @"", *str3 = @"";
        
        NSString *shape = kStringIsNotEmpty(list.shape)?list.shape:@"";
        NSString *size = kStringIsNotEmpty(list.dSize.stringValue)?[@" " stringByAppendingString:list.dSize.stringValue]:@"";
        NSString *color = kStringIsNotEmpty(list.color)?[@" " stringByAppendingString:list.color]:@"";
        NSString *clarity = kStringIsNotEmpty(list.clarity)?[@" " stringByAppendingString:list.clarity]:@"";
        NSString *cut = kStringIsNotEmpty(list.cut)?[@" " stringByAppendingString:list.cut]:@"";
        NSString *polish = kStringIsNotEmpty(list.polish)?[@" " stringByAppendingString:list.polish]:@"";
        NSString *sym = kStringIsNotEmpty(list.sym)?[@" " stringByAppendingString:list.sym]:@"";
        NSString *flour = kStringIsNotEmpty(list.flour)?[@" " stringByAppendingString:list.flour]:@"";
        NSString *disc = kStringIsNotEmpty(list.disc)?[@" " stringByAppendingFormat:@"%.2f", -list.disc.floatValue+list.num.floatValue]:@"";
        NSString *rmb1 = [NSString stringWithFormat:@" RMB/粒：%.2f", list.rap.floatValue*list.dollarRate.floatValue*((100-list.disc.floatValue+list.num.floatValue)/100.0)*list.dSize.floatValue];
        NSString *rmb2 = [NSString stringWithFormat:@" RMB/粒：%.2f", list.rap.floatValue*list.dollarRate.floatValue*list.num.floatValue*list.dSize.floatValue];
        NSString *cert = kStringIsNotEmpty(list.cert)?[@" " stringByAppendingString:list.cert]:@"";
        NSString *certNo = kStringIsNotEmpty(list.certNo)?[@" " stringByAppendingString:list.certNo]:@"";
        
        if (self.diamQuoteShow) {
            str1 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@", shape, size, color, clarity, cut, polish, sym, flour, rmb1, cert, certNo];
            str2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@", shape, size, color, clarity, cut, polish, sym, flour, rmb1, cert];
        } else {
            str1 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@", shape, size, color, clarity, polish, sym, flour, rmb2, cert, certNo];
            str2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", shape, size, color, clarity, polish, sym, flour, rmb2, cert];
        }
        str3 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@", shape, size, color, clarity, cut, polish, sym, flour, disc, rmb1, cert, certNo];
        
        [item1Arr addObject:str1];
        [item2Arr addObject:str2];
        [item3Arr addObject:str3];
    }
    
    item1.content = [item1Arr componentsJoinedByString:@"\n\n"];
    item1.rowHeight = sizeOfString(item1.content, kFont(14), kScreenW-ZGCConvertToPx(20)).height+ZGCConvertToPx(30);
    item2.content = [item2Arr componentsJoinedByString:@"\n\n"];
    item2.rowHeight = sizeOfString(item2.content, kFont(14), kScreenW-ZGCConvertToPx(20)).height+ZGCConvertToPx(30);
    item3.content = [item3Arr componentsJoinedByString:@"\n\n"];
    item3.rowHeight = sizeOfString(item3.content, kFont(14), kScreenW-ZGCConvertToPx(20)).height+ZGCConvertToPx(30);
    
    group1.itemViewModels = @[item1];
    group2.itemViewModels = @[item2];
    group3.itemViewModels = @[item3];
    
    self.dataSource = @[group1, group2, group3];
}

@end
