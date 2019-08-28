//
//  Constant.h
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

/// MARK: - Block
typedef void (^VoidBlock)(void);
typedef BOOL (^BoolBlock)(void);
typedef NSInteger  (^IntBlock) (void);
typedef id   (^IDBlock)  (void);

typedef void (^VoidBlock_int)(NSInteger);
typedef BOOL (^BoolBlock_int)(NSInteger);
typedef NSInteger  (^IntBlock_int) (NSInteger);
typedef id   (^IDBlock_int)  (NSInteger);

typedef void (^VoidBlock_string)(NSString *);
typedef BOOL (^BoolBlock_string)(NSString *);
typedef NSInteger  (^IntBlock_string) (NSString *);
typedef id   (^IDBlock_string)  (NSString *);

typedef void (^VoidBlock_id)(id);
typedef BOOL (^BoolBlock_id)(id);
typedef NSInteger  (^IntBlock_id) (id);
typedef id   (^IDBlock_id)  (id);

typedef void (^VoidBlock_Bool)(BOOL);
typedef BOOL (^BoolBlock_Bool)(BOOL);
typedef NSInteger  (^IntBlock_Bool) (BOOL);
typedef id   (^IDBlock_Bool)  (BOOL);


/// MARK: - 用户相关
// MARK: 用户名
FOUNDATION_EXTERN NSString * const ZGCUserNameKey;
// MARK: 密码
FOUNDATION_EXTERN NSString * const ZGCPasswordKey;
// MARK: 是否已登录
FOUNDATION_EXTERN NSString * const ZGCIsLoginKey;
// MARK: 是否记住密码
FOUNDATION_EXTERN NSString * const ZGCIsRememberPwdKey;
// MARK: 是否自动登录
FOUNDATION_EXTERN NSString * const ZGCIsAutoLoginKey;
// MARK: userId
FOUNDATION_EXTERN NSString * const ZGCUserIdKey;
// MARK: uid登录请求存储数据
FOUNDATION_EXTERN NSString * const ZGCUIDKey;
// MARK: sign
FOUNDATION_EXTERN NSString * const ZGCSignKey;
// MARK: level
FOUNDATION_EXTERN NSString * const ZGCLevelKey;
// MARK: wwww
FOUNDATION_EXTERN NSString * const ZGCUserWwwKey;
// MARK: ManagerKey
FOUNDATION_EXTERN NSString * const ZGCManagerIdKey;
// MARK: sellerId
FOUNDATION_EXTERN NSString * const UserSellerIdKey;
// MARK: sellerId
FOUNDATION_EXTERN NSString * const UserBuyerIdKey;
// MARK: DiamondShowPowerMasterKey
FOUNDATION_EXTERN NSString * const DiamondShowPowerMasterKey;
// MARK: showAddress
FOUNDATION_EXTERN NSString * const AddressShowKey;
// MARK: certShow
FOUNDATION_EXTERN NSString * const CertShowKey;
// MARK: rapIpShow
FOUNDATION_EXTERN NSString * const RapIdShowKey;
// MARK: rapShow
FOUNDATION_EXTERN NSString * const RapShowKey;
// MARK: rapBuyShow
FOUNDATION_EXTERN NSString * const RapBuyShowKey;
// MARK: discShow
FOUNDATION_EXTERN NSString * const DiscShowKey;
// MARK: mbgShow
FOUNDATION_EXTERN NSString * const MbgShowKey;
// MARK: blackShow
FOUNDATION_EXTERN NSString * const BlackShowKey;
// MARK: eyeClean
FOUNDATION_EXTERN NSString * const EyeCleanShowKey;
// MARK: d_t
FOUNDATION_EXTERN NSString * const DTShowKey;
// MARK: fancyRap
FOUNDATION_EXTERN NSString * const FancyRapKey;
// MARK: imgShow
FOUNDATION_EXTERN NSString * const ImgShowKey;
// MARK: dollarShow
FOUNDATION_EXTERN NSString * const DollarShowKey;
// MARK: GoodsNumberShow
FOUNDATION_EXTERN NSString * const GoodsNumberShowKey;
// MARK: sizeShow
FOUNDATION_EXTERN NSString * const SizeShowKey;

/// MARK: - 请求相关
// MARK: token
FOUNDATION_EXTERN NSString * const HTTPRequestTokenKey;
// MARK: 私钥key
FOUNDATION_EXTERN NSString * const HTTPRequestServiceKey;
// MARK: 私钥value
FOUNDATION_EXTERN NSString * const HTTPRequestServiceKeyValue;
// MARK: 签名
FOUNDATION_EXTERN NSString * const HTTPRequestSignKey;
// MARK: 状态码
FOUNDATION_EXTERN NSString * const HTTPServiceResponseCodeKey;
// MARK: 消息
FOUNDATION_EXTERN NSString * const HTTPServiceResponseMsgKey;
// MARK: 数据
FOUNDATION_EXTERN NSString * const HTTPServiceResponseDataKey;
// MARK: 数据列表
FOUNDATION_EXTERN NSString * const HTTPServiceResponseListKey;
// MARK: errorDoman
FOUNDATION_EXTERN NSString * const HTTPServiceErrorDomain;
// MARK: 错误链接
FOUNDATION_EXTERN NSString * const HTTPServiceErrorRequestURLKey;
// MARK: 错误码
FOUNDATION_EXTERN NSString * const HTTPServiceErrorStatusCodeKey;
// MARK: 服务器返回错误信息
FOUNDATION_EXTERN NSString * const HTTPServiceErrorDescriptionKey;

/// MARK: - 数据相关
// MARK: 用户信息的名称
FOUNDATION_EXTERN NSString * const UserDataFileName;
// MARK: RSA加密模数
FOUNDATION_EXTERN NSString * const ZGCRSAModKey;

/// MARK: - 页面相关
// MARK: 传递唯一ID的key：例如：商品id 用户id...
FOUNDATION_EXTERN NSString *const ViewModelIDKey;
// MARK: 传递导航栏title的key：例如 导航栏的title...
FOUNDATION_EXTERN NSString *const ViewModelTitleKey;
// MARK: 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
FOUNDATION_EXTERN NSString *const ViewModelUtilKey;
// MARK: 传递webView Request的key：例如 webView request...
FOUNDATION_EXTERN NSString *const ViewModelRequestKey;
// MARK: 传递type的key：例如 ...
FOUNDATION_EXTERN NSString *const ViewModelTypeKey;
// MARK: 传递搜索orderNo
FOUNDATION_EXTERN NSString *const ViewModelSearchOrderNoKey;
// MARK: PDF传递链接
FOUNDATION_EXTERN NSString *const ViewModelPdfUrlKey;
// MARK: PDF类型
FOUNDATION_EXTERN NSString *const ViewModelPdfTypeKey;
// MARK: model对象
FOUNDATION_EXTERN NSString *const ViewModelModelKey;
// MARK: certNo对象
FOUNDATION_EXTERN NSString *const ViewModelCertNoKey;

// MARK: 页面动画
FOUNDATION_EXTERN NSString * const ZGCViewAnimationShow;
FOUNDATION_EXTERN NSString * const ZGCViewAnimationHide;

/// MARK: - 通知相关
// MARK: 用户数据配置完成
FOUNDATION_EXTERN NSString * const UserDataConfigureCompleteNotification;
FOUNDATION_EXTERN NSString * const UserDataConfigureCompleteUserInfoKey;
FOUNDATION_EXTERN NSString * const UserDataConfigureCompleteTypeKey;
// MARK: 用户在其他地方登陆
FOUNDATION_EXTERN NSString * const UserDataLoginAtOtherPlaceNotification;
// MARK: 添加账号成功
FOUNDATION_EXTERN NSString * const AddAccountSuccessNotification;
