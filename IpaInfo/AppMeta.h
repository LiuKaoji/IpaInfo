//
//  AppCert.h
//  IpaInfo
//
//  Created by Kaoji on 12/08/2022.
//

#import <Foundation/Foundation.h>
#import "IpaReader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppMeta : NSObject
@property (nonatomic, strong) NSDictionary *metaDict;// info.plist->映射
@property (nonatomic, copy) NSString *appleId;//标识符
@property (nonatomic, copy) NSString *userName;//名称
@property (nonatomic, copy) NSString *softwareVersionBundleId;//bundleId
@property (nonatomic, assign) BOOL sideLoadedDeviceBasedVPP;//vpp侧载

- (instancetype)init NS_UNAVAILABLE; 

/**
 *  基于iPA路径实例化读取 mobileprovision 的关键信息
 *
 *
 * @return AppInfo：AppInfo的实例化对象
 */
- (instancetype)initWithIpaPath:(const char *)path;

@end

NS_ASSUME_NONNULL_END
