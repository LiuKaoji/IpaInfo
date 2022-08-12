//
//  IpaReader.h
//  IpaInfo
//
//  Created by Kaoji on 12/08/2022.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IpaFileType) {
    /// 安装包信息
    IpaFileType_infoPlist,
    /// 签名证书
    IpaFileType_mobileprovision,
    /// iTunes信息
    IpaFileType_iTunesMetadata,
};

@interface IpaReader : NSObject

/////////////////////////////////////////////////////////////////////////////////
//
//                   读取IPA包资源
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  读取IPA包指定类型的文件
 *
 *
 * @return NSData：该文件的二进制数据的
 */
+(NSData *)read:(IpaFileType)type inPath:(const char *)path;

+(const char *)nameForType:(IpaFileType)type;

@end

