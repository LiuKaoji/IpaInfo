//
//  AppInfo.h
//  IpaInfo
//
//  Created by Kaoji on 12/08/2022.
//

#import <Foundation/Foundation.h>
#import "IpaReader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppInfo : NSObject

@property (nonatomic, strong) NSDictionary *infoDict;// info.plist->映射
@property (nonatomic, copy) NSString *bundleId;//标识符
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *version;//版本号
@property (nonatomic, copy) NSString *revision;//修订版本号

/**
 *  基于iPA路径实例化读取 info.plist 的关键信息
 *
 *
 * @return AppInfo：AppInfo的实例化对象
 */
- (instancetype)initWithIpaPath:(const char *)path;

/**
 *  对比传入的修订版本号
 *
 *
 * @return int：-2: 错误  -1:app版本>mac本地版本  0: 版本一致 1: app版本<mac本地版本
 */
- (int)compareRevision:(const char *)revision;

@end

NS_ASSUME_NONNULL_END
