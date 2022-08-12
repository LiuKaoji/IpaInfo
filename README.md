# IpaInfo

## 简介
命令行工具 免解压读取ipa信息

## Info.plist
* **读取app版本等基本信息
```bash
$ ./IpaInfo -info ./application.ipa
```

## iTunesMetadata.plist
* **读取iTunes购买信息
```bash
$ ./IpaInfo -meta ./application.ipa
```
## embed.mobileprovision
* **读取app签名信息
```bash
$ ./IpaInfo -cert ./application.ipa
```

## 比较安装包与输入版本的大小
* ** -2：错误 -1：安装包更新  0：版本一致 1：安装包更旧
```bash
$ ./IpaInfo -compare ./application.ipa 1.2.8
```


