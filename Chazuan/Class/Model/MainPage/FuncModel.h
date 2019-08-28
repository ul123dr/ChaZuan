//
//  FuncModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FuncModel : MHObject

@property (nonatomic, readwrite, copy) NSString *icon;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) BOOL needLogin;
@property (nonatomic, readwrite, strong) Class destViewModelClass;

@end

NS_ASSUME_NONNULL_END
