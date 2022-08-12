//
//  IpaReader.m
//  IpaInfo
//
//  Created by Kaoji on 12/08/2022.
//

#import "IpaReader.h"
#include "stdio.h"
#include "unzip.h"
#include "string.h"


@implementation IpaReader

+(NSData *)read:(IpaFileType)type inPath:(const char *)path{
    
    int err;
    char szFileName[255];
 
    //声明结构体
    unz_file_info file_info;
 
    //打开压缩文件
    unzFile uzf = unzOpen64(path);
    
    // 获取压缩包文件数量
    unz_global_info64 gi;
    err= unzGetGlobalInfo64(uzf, &gi);
    if (err != UNZ_OK){
        printf("获取文件数量失败...\n");
        return nil;
    }
    
    
    BOOL isMatchFile = NO;
    NSUInteger fileCountInZip = (NSUInteger) gi.number_entry;
    NSString *matchName = [NSString stringWithUTF8String:[IpaReader nameForType:type]];
    for (NSUInteger i = 0; i < fileCountInZip; i++){
        
        if (i == 0){
            err = unzGoToFirstFile(uzf);
            if (UNZ_OK != err)
            {
                printf("定位至第一个文件失败...\n");
                return nil;
            }
        }else{
            err = unzGoToNextFile(uzf);
            if (UNZ_OK != err)
            {
                printf("定位至下一个文件失败...\n");
                return nil;
            }
        }
        
        //获取当前选择的内部压缩文件的信息
        err = unzGetCurrentFileInfo(uzf, &file_info, szFileName, sizeof(szFileName), NULL, 0, NULL, 0);
        NSString *currentFileName = [NSString stringWithUTF8String:szFileName];
        //NSLog(@"%@", currentFileName);
        if ([currentFileName hasSuffix: matchName]) {
            isMatchFile = YES;
            break;
        }
    }
    
    if (!isMatchFile) {
        printf("没有找到指定文件类型...\n");
        return nil;
    }
 
    //定位到指定文件
    err = unzLocateFile(uzf, szFileName, 0);
    if (UNZ_OK != err)
    {
        printf("定位到指定文件失败...\n");
        return nil;
    }
    //获取当前选择的内部压缩文件的信息
    err = unzGetCurrentFileInfo(uzf, &file_info, szFileName, sizeof(szFileName), NULL, 0, NULL, 0);
 
    if (UNZ_OK != err)
    {
        printf("获取压缩文件信息失败...\n");
        return nil;
    }
    //选择打开定位到的文件
    err = unzOpenCurrentFile(uzf);
    if (err != UNZ_OK)
    {
        printf("打开指定文件失败...\n");
        return nil;
    }
    //读取内容
    unsigned long len = file_info.uncompressed_size;
    char * ptr_arr;
    ptr_arr = (char*)malloc(len); //动态分配内存
    err = unzReadCurrentFile(uzf, ptr_arr, (unsigned int)file_info.uncompressed_size);
    
    NSData *data = [NSData dataWithBytes:ptr_arr length:len];
    
    //关闭文件
    unzCloseCurrentFile(uzf);
    unzClose(uzf);
    return data;
}

+(NSData *)read:(const char *)zipPath inZip: (const char *)absolutePath{
    
    int err;
    char szFileName[255];
 
    //声明结构体
    unz_file_info file_info;
 
    //打开压缩文件
    unzFile uzf = unzOpen64(zipPath);
 
    //定位到指定文件
    err = unzLocateFile(uzf, absolutePath, 0);
    if (UNZ_OK != err)
    {
        printf("打开压缩包失败...\n");
        return nil;
    }
    //获取当前选择的内部压缩文件的信息
    err = unzGetCurrentFileInfo(uzf, &file_info, szFileName, sizeof(szFileName), NULL, 0, NULL, 0);
 
    if (UNZ_OK != err)
    {
        printf("获取压缩文件信息失败...\n");
        return nil;
    }
    //选择打开定位到的文件
    err = unzOpenCurrentFile(uzf);
    if (err != UNZ_OK)
    {
        printf("打开指定文件失败...\n");
        return nil;
    }
    //读取内容
    unsigned long len = file_info.uncompressed_size;
    char * ptr_arr;
    ptr_arr = (char*)malloc(len); //动态分配内存
    err = unzReadCurrentFile(uzf, ptr_arr, (unsigned int)file_info.uncompressed_size);
    
    NSData *data = [NSData dataWithBytes:ptr_arr length:len];

    //关闭文件
    unzCloseCurrentFile(uzf);
    unzClose(uzf);
    return data;
    
}

+(const char *)nameForType:(IpaFileType)type{
    switch (type) {
        case IpaFileType_infoPlist:
        return  ".app/Info.plist"; //因为包里可能不止一个info.plist 所以加根目录
        case IpaFileType_mobileprovision:
        return  "embedded.mobileprovision";
        case IpaFileType_iTunesMetadata:
        return  "iTunesMetadata.plist";
    }
}
@end
