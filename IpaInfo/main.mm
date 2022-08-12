//
//  main.m
//  IpaInfo
//
//  Created by Kaoji on 11/08/2022.
//

#import <Foundation/Foundation.h>
#include "stdio.h"
#include "unzip.h"
#include "string.h"
#import "IpaReader.h"
#import "AppInfo.h"
#import "AppMeta.h"
#import "MPProvision.h"

static void usage(const char *prog)
{
  fprintf(stderr, "使用说明: "
           "\n"
           "命令行读取ipa安装包信息\n"
           "\n"
           "请使用以下指令:\n"
           "  -info    - 安装包基本信息\n"
           "  -meta    - 打印构建版本号\n"
           "  -cert    - 打印修订版本\n"
           "  -compare - 对比版本号\n"
           "\n");
}

static bool parse_args(int argc, const char **argv)
{
    if ( argc > 1 )
    {
        for ( int i = 1; i < argc; )
        {
            NSString *task = [NSString stringWithUTF8String:argv[i]];
            
            if ([task isEqualToString:@"-info"])
            {
                if ( i == argc - 1 )
                {
                    fprintf(stderr, "缺少安装包路径\n");
                    break;
                }
                
                NSURL *sourceURL = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[i+1]]];
                if (!sourceURL|| ![[NSFileManager defaultManager] fileExistsAtPath:sourceURL.path]){
                    fprintf(stderr, "安装包路径无效, 或文件不存在\n");
                    break;
                }

                AppInfo *info = [[AppInfo alloc] initWithIpaPath:argv[i+1]];
                NSLog(@"name = %@", info.name);
                NSLog(@"version = %@", info.version);
                NSLog(@"revision = %@", info.revision);
                NSLog(@"bundleId = %@", info.bundleId);
                return true;
            }
            else if ([task isEqualToString:@"-meta"])
            {
                if ( i == argc - 1 )
                {
                    fprintf(stderr, "缺少安装包路径\n");
                    break;
                }
                
                NSURL *sourceURL = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[i+1]]];
                if (!sourceURL|| ![[NSFileManager defaultManager] fileExistsAtPath:sourceURL.path]){
                    fprintf(stderr, "安装包路径无效, 或文件不存在\n");
                    break;
                }
                
                AppMeta *meta = [[AppMeta alloc] initWithIpaPath:argv[i+1]];
                if (!meta.metaDict){
                    fprintf(stderr, "无法读取 'iTunesMetadata.plist'\n");
                    break;
                }
                
                NSLog(@"userName = %@", meta.userName);
                NSLog(@"appleId = %@", meta.appleId);
                NSLog(@"bundleId = %@", meta.softwareVersionBundleId);
                NSLog(@"sideLoadedDeviceBasedVPP = %d", meta.sideLoadedDeviceBasedVPP);
                
              
                return true;
            }
            else if ([task isEqualToString:@"-cert"])
            {
                if ( i == argc - 1 )
                {
                    fprintf(stderr, "缺少安装包路径\n");
                    break;
                }
                
                NSURL *sourceURL = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[i+1]]];
                if (!sourceURL|| ![[NSFileManager defaultManager] fileExistsAtPath:sourceURL.path]){
                    fprintf(stderr, "安装包路径无效, 或文件不存在\n");
                    break;
                }
                
                NSData *data = [IpaReader read: IpaFileType_mobileprovision inPath:sourceURL.path.UTF8String];
                if (!data){
                    fprintf(stderr, "无法读取 'embed.mobileprovision'\n");
                    break;
                }
                
                MPProvision *cert = [MPProvision provisionWithData:data];
                NSLog(@"Name = %@", cert.Name);
                NSLog(@"TeamName = %@", cert.TeamName);
                NSLog(@"TeamIdentifier = %@", cert.TeamIdentifier);
                NSLog(@"CreationDate = %@", cert.CreationDate);
                NSLog(@"ExpirationDate = %@", cert.ExpirationDate);
                
                return true;
            }
            else if ([task isEqualToString:@"-compare"])
            {
                if ( i == argc - 1 && i != argc-3)
                {
                    fprintf(stderr, "参数错误\n");
                    break;
                }
                
                NSURL *sourceURL = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[i+1]]];
                if (!sourceURL|| ![[NSFileManager defaultManager] fileExistsAtPath:sourceURL.path]){
                    fprintf(stderr, "安装包路径无效, 或文件不存在\n");
                    break;
                }
                
                const char *installedVersion = argv[i+2];
                
                AppInfo *info = [[AppInfo alloc] initWithIpaPath:argv[i+1]];
                int result = [info compareRevision:installedVersion];
                NSLog(@"%d", result);
                return true;
            }
        }
    }
    usage(argv[0]);
    return false;
}

int main(int argc, const char **argv){
    return parse_args(argc, argv);
}

