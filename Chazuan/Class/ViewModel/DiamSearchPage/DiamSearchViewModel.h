//
//  DiamSearchViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "SearchViewModel.h"
#import "DiamSearchModel.h"
#import "DiamGroupViewModel.h"
#import "ShapeItemViewModel.h"
#import "SizeItemViewModel.h"
#import "ColorItemViewModel.h"
#import "ClarityItemViewModel.h"
#import "CutItemViewModel.h"
#import "FlourItemViewModel.h"
#import "CertItemViewModel.h"
#import "LocationItemViewModel.h"
#import "MilkItemViewModel.h"
#import "DiamSearchItemViewModel.h"
#import "DiamSearchResultViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DiamSearchModel;
@interface DiamSearchViewModel : BaseTableViewModel

@property (nonatomic, readonly, strong) DiamSearchModel *diam;
@property (nonatomic, readwrite, copy) NSString *sizeBtnTitle;
@property (nonatomic, readonly, strong) NSArray *sizeArray;
@property (nonatomic, readonly, strong) RACSubject *sizeSub;

@property (nonatomic, readonly, strong) RACCommand *resetCommand;
@property (nonatomic, readonly, strong) RACCommand *searchCommand;
@property (nonatomic, readonly, strong) RACCommand *navSearchCommand;

@end

NS_ASSUME_NONNULL_END
