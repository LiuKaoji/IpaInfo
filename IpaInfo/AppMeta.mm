//
//  AppCert.m
//  IpaInfo
//
//  Created by Kaoji on 12/08/2022.
//

#import "AppMeta.h"

@interface AppMeta ()

@end

@implementation AppMeta
#pragma mark - PublicMethod

- (instancetype)initWithIpaPath:(const char *)path  {
    if (self = [super init]){
       NSData *data = [IpaReader read: IpaFileType_iTunesMetadata inPath:path];
        if(data){
            NSError *error;
            NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
            NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData: data options:kCFPropertyListMutableContainers format: &format error:&error];
            _metaDict = dictionary;
        }
    }
    return self;
}

-(NSString *)appleId{
    return _metaDict[@"apple-id"];
}

-(NSString *)userName{
    return _metaDict[@"userName"];
}


-(NSString *)bundlsoftwareVersionBundleIdeId{
    return _metaDict[@"bundlsoftwareVersionBundleIdeId"];
}

-(BOOL)sideLoadedDeviceBasedVPP{
    return [_metaDict[@"sideLoadedDeviceBasedVPP"] boolValue];
}

@end
