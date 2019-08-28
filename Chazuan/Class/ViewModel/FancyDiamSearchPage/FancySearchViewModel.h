//
//  FancySearchViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "SearchViewModel.h"
#import "DiamSearchModel.h"
#import "DiamGroupViewModel.h"
#import "FancySearchItemViewModel.h"
#import "FancyShapeItemViewModel.h"
#import "StrengthItemViewModel.h"
#import "LustreItemViewModel.h"
#import "FancyColorItemViewModel.h"
#import "ClarityItemViewModel.h"
#import "FancyCutItemViewModel.h"
#import "FlourItemViewModel.h"
#import "DiamSearchResultViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FancySearchViewModel : BaseTableViewModel

@property (nonatomic, readonly, strong) DiamSearchModel *diam;
@property (nonatomic, readwrite, copy) NSString *sizeBtnTitle;
@property (nonatomic, readonly, strong) NSArray *sizeArray;
@property (nonatomic, readonly, strong) RACSubject *sizeSub;
@property (nonatomic, readwrite, copy) NSString *certBtnTitle;
@property (nonatomic, readonly, strong) NSArray *certArray;
@property (nonatomic, readonly, strong) RACSubject *certSub;

@property (nonatomic, readonly, strong) RACCommand *resetCommand;
@property (nonatomic, readonly, strong) RACCommand *searchCommand;
@property (nonatomic, readonly, strong) RACCommand *navSearchCommand;

@end

NS_ASSUME_NONNULL_END
