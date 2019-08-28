//
//  StyleDetailViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "StylePicItemViewModel.h"
#import "StyleInfoItemViewModel.h"
#import "StyleAddModel.h"
#import "StyleSelectItemViewModel.h"
#import "StyleTextItemViewModel.h"
#import "GoodInfoItemViewModel.h"
#import "GoodInfoGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleDetailViewModel : BaseTableViewModel

@property (nonatomic, readonly, assign) StyleType type;

@property (nonatomic, readwrite, strong) StyleAddModel *add;

@property (nonatomic, readonly, strong) RACSubject *picClickSub;
@property (nonatomic, readonly, assign) NSInteger index;
@property (nonatomic, readonly, strong) NSArray *popArray;
@property (nonatomic, readonly, strong) RACSubject *selectSub;
@property (nonatomic, readonly, strong) RACSubject *dateSub;

@property (nonatomic, readonly, strong) RACCommand *homeCommand;
@property (nonatomic, readonly, strong) RACCommand *cartCommand;
@property (nonatomic, readonly, strong) RACCommand *orderCommand;

@property (nonatomic, readonly, strong) RACCommand *designCommand;
@property (nonatomic, readonly, strong) RACSubject *showGoodSub;

@property (nonatomic, readonly, strong) StyleDetailModel *detailModel;
@property (nonatomic, readwrite, assign) NSInteger sizeIndex;
@property (nonatomic, readwrite, assign) NSInteger handIndex;
@property (nonatomic, readonly, strong) NSArray *popDatas;
@property (nonatomic, readwrite, strong, nullable) NSArray *selectArray;

- (void)searchList:(NSString *)sizeMin max:(NSString *)sizeMax hand:(NSString *)hand;

@end

NS_ASSUME_NONNULL_END
