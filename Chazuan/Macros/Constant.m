//
//  Constant.m
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "Constant.h"

/// MARK: - 用户相关
// 用户名
NSString * const ZGCUserNameKey             = @"UN";
// 密码
NSString * const ZGCPasswordKey             = @"UP";
// 是否已登录
NSString * const ZGCIsLoginKey              = @"isLogin";
// 是否记住密码
NSString * const ZGCIsRememberPwdKey        = @"isRememberPwd";
// 是否自动登录
NSString * const ZGCIsAutoLoginKey          = @"isAutoLogin";
// userId
NSString * const ZGCUserIdKey               = @"UI";
// uid登录请求存储数据
NSString * const ZGCUIDKey                  = @"UU";
// key
NSString * const ZGCSignKey                 = @"UK";
// level
NSString * const ZGCLevelKey                = @"UL";
// www
NSString * const ZGCUserWwwKey              = @"www";
// ManagerKey
NSString * const ZGCManagerIdKey            = @"MI";
// sellerId
NSString * const UserSellerIdKey            = @"SId";
// sellerId
NSString * const UserBuyerIdKey             = @"BId";
// DiamondShowPowerMasterKey
NSString * const DiamondShowPowerMasterKey  = @"DiamondShowPowerMasterKey";
// showAddress
NSString * const AddressShowKey             = @"AddrShow";
// certShow
NSString * const CertShowKey                = @"CertShow";
// rapIpShow
NSString * const RapIdShowKey               = @"RapIdShow";
// rapShow
NSString * const RapShowKey                 = @"RapShow";
// rapBuyShow
NSString * const RapBuyShowKey              = @"RapBuyShow";
// discShow
NSString * const DiscShowKey                = @"DiscShow";
// mbgShow
NSString * const MbgShowKey                 = @"MbgShow";
// blackShow
NSString * const BlackShowKey               = @"BlackShow";
// eyeClean
NSString * const EyeCleanShowKey            = @"EyeCleanShowKey";
// d_t
NSString * const DTShowKey                  = @"DTShowKey";
// fancyRap
NSString * const FancyRapKey                = @"FancyRap";
// imgShow
NSString * const ImgShowKey                 = @"ImgShow";
// dollarShow
NSString * const DollarShowKey              = @"DollarShow";
// GoodsNumberShow
NSString * const GoodsNumberShowKey         = @"GoodsNumberShow";
// sizeShow
NSString * const SizeShowKey                = @"SizeShow";

/// MARK: - 请求相关
// token
NSString * const HTTPRequestTokenKey                    = @"token";
// 私钥key
NSString * const HTTPRequestServiceKey                  = @"privatekey";
// 私钥value
NSString * const HTTPRequestServiceKeyValue             = @"/** 你的私钥 **/";
// 签名
NSString * const HTTPRequestSignKey                     = @"sign";
// 状态码
NSString * const HTTPServiceResponseCodeKey             = @"code";
// 消息
NSString * const HTTPServiceResponseMsgKey              = @"desc";
// 数据
NSString * const HTTPServiceResponseDataKey             = @"data";
// 数据列表
NSString * const HTTPServiceResponseListKey             = @"list";
// errorDoman
NSString * const HTTPServiceErrorDomain                 = @"HTTPServiceErrorDomain";
// 错误链接
NSString * const HTTPServiceErrorRequestURLKey          = @"HTTPServiceErrorRequestURLKey";
// 错误码
NSString * const HTTPServiceErrorStatusCodeKey          = @"HTTPServiceErrorStatusCodeKey";
// 服务器返回错误信息
NSString * const HTTPServiceErrorDescriptionKey         = @"HTTPServiceErrorDescriptionKey";


/// MARK: - 数据相关
// 用户信息的名称
NSString * const UserDataFileName               = @"senba_empty_user.data";
// RSA加密模数
NSString * const ZGCRSAModKey                   = @"rsa_mod_data";

/// MARK: - 页面相关
// 传递唯一ID的key：例如：商品id 用户id...
NSString *const ViewModelIDKey                      = @"ViewModelIDKey";
// 传递导航栏title的key：例如 导航栏的title...
NSString *const ViewModelTitleKey                   = @"ViewModelTitleKey";
// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
NSString *const ViewModelUtilKey                    = @"ViewModelUtilKey";
// 传递webView Request的key：例如 webView request...
NSString *const ViewModelRequestKey                 = @"ViewModelRequestKey";
// 传递type的key：例如 ...
NSString *const ViewModelTypeKey                    = @"ViewModelTypeKey";
// 传递搜索orderNo
NSString *const ViewModelSearchOrderNoKey           = @"SearchOrderNo";
// PDF传递链接
NSString *const ViewModelPdfUrlKey                  = @"ViewModelPdfUrl";
// PDF类型
NSString *const ViewModelPdfTypeKey                 = @"ViewModelPdfType";
// model对象
NSString *const ViewModelModelKey                   = @"ViewModelModelKey";
// certNo对象
NSString *const ViewModelCertNoKey                  = @"ViewModelCertNoKey";

// 页面动画
NSString * const ZGCViewAnimationShow               = @"ZGCViewAnimationShow";
NSString * const ZGCViewAnimationHide               = @"ZGCViewAnimationHide";

/// MARK: - 通知相关
// 用户数据配置完成
NSString * const UserDataConfigureCompleteNotification          = @"UserDataConfigureCompleteNotification";
NSString * const UserDataConfigureCompleteUserInfoKey           = @"UserDataConfigureCompleteUserInfoKey";
NSString * const UserDataConfigureCompleteTypeKey               = @"UserDataConfigureCompleteTypeKey";
// 用户在其他地方登陆
NSString * const UserDataLoginAtOtherPlaceNotification          = @"UserDataLoginAtOtherPlaceNotification";
// 添加账号成功
NSString * const AddAccountSuccessNotification                  = @"AddAccountSuccessNotification";
