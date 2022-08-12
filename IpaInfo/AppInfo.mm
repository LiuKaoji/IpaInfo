//
//  AppInfo.m
//  IpaInfo
//
//  Created by Kaoji on 12/08/2022.
//

#import "AppInfo.h"
#include "stdio.h"
#include "unzip.h"
#include "string.h"

@implementation AppInfo

- (instancetype)initWithIpaPath:(const char *)path  {
    if (self = [super init]){
       NSData *data = [IpaReader read: IpaFileType_infoPlist inPath:path];
        if(data){
            NSError *error;
            NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
            NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData: data options:kCFPropertyListMutableContainers format: &format error:&error];
            _infoDict = dictionary;
        }
    }
    return self;
}

-(NSString *)name{
    return _infoDict[@"CFBundleName"];
}

-(NSString *)version{
    return _infoDict[@"CFBundleShortVersionString"];
}


-(NSString *)revision{
    return _infoDict[@"CFBundleVersion"];
}

-(NSString *)bundleId{
    return _infoDict[@"CFBundleIdentifier"];
}

- (int)compareRevision:(const char *)revision{
    NSString *ipaRevison = self.revision;
    if (ipaRevison.length == 0){
        return -2;
    }
    return [self compareInstalledVersion:revision ipaVersion:ipaRevison.UTF8String];
}

-(int)compareInstalledVersion:(const char *)v1 ipaVersion:(const char *)v2{
  
    const char *p_v1 = v1;
    const char *p_v2 = v2;
    
    while (*p_v1 && *p_v2) {
        char buf_v1[32] = {0};
        char buf_v2[32] = {0};
        
        const char *i_v1 = strchr(p_v1, '.');
        const char *i_v2 = strchr(p_v2, '.');
        
        if (!i_v1 || !i_v2) break;
        
        if (i_v1 != p_v1) {
            strncpy(buf_v1, p_v1, i_v1 - p_v1);
            p_v1 = i_v1;
        }
        else
            p_v1++;
        
        if (i_v2 != p_v2) {
            strncpy(buf_v2, p_v2, i_v2 - p_v2);
            p_v2 = i_v2;
        }
        else
            p_v2++;

        int order = atoi(buf_v1) - atoi(buf_v2);
        if (order != 0)
            return order < 0 ? -1 : 1;
    }
    
    double res = atof(p_v1) - atof(p_v2);
    
    if (res < 0) return -1;
    if (res > 0) return 1;
    return 0;
}

@end
