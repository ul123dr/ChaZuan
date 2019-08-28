//
//  SettingModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSNumber *dollarRate; 
@property (nonatomic, readwrite, strong) NSNumber *setId;
@property (nonatomic, readwrite, strong) NSNumber *maxTime;
@property (nonatomic, readwrite, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
