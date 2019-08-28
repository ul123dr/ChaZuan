//
//  PersonalCenterViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "PersonalItemViewModel.h"
#import "DoneItemViewModel.h"
#import "SettingViewModel.h"
#import "VipRateViewModel.h"
#import "ContactInfoViewModel.h"
#import "NoteViewModel.h"
#import "ChangePasswordViewModel.h"
#import "AccountViewModel.h"
#import "ProfileViewModel.h"
#import "QRCodeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCenterViewModel : BaseTableViewModel

@property (nonatomic, readonly, strong) NSError *error; 

@end

NS_ASSUME_NONNULL_END
