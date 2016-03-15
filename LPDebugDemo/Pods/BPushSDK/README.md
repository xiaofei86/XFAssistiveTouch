# BaiduPush-iOS-SDK

[![CI Status](http://img.shields.io/travis/shingwasix/BaiduPush-iOS-SDK.svg?style=flat)](https://travis-ci.org/shingwasix/BaiduPush-iOS-SDK)
[![Version](https://img.shields.io/cocoapods/v/BPushSDK.svg?style=flat)](http://cocoapods.org/pods/BPushSDK)
[![License](https://img.shields.io/cocoapods/l/BPushSDK.svg?style=flat)](http://cocoapods.org/pods/BPushSDK)
[![Platform](https://img.shields.io/cocoapods/p/BPushSDK.svg?style=flat)](http://cocoapods.org/pods/BPushSDK)

百度推送iOS SDK

## 简介
此为非官方整理用于CocoaPods部署的项目，其中`Official-Sources`文件夹下的文件为百度推送官方网站下载的SDK文件。若安装后有任何问题，请先校验静态库，确保下载的文件正确。

## 校验

[libBPush.a](https://github.com/shingwasix/BaiduPush-iOS-SDK/blob/1.4.3/Official-Sources/LibBPush/libBPush.a)
- MD5:`9e0eb8730cf7a21fa38a8439bd139f8d`
- SHA1:`adc4e078c2c4d03ec3f5af12501aff51735338e4`

## 版本
1.4.3 [更新时间:2015-10-16]

## 兼容平台
iOS 5.1及以上

## 官方更新说明
1. 优化日志上传策略，更准确的获取统计数据。
2. 添加崩溃日志上传，第一时间搜集到崩溃信息，更快的优化sdk。
3. demo 去除警告，添加接受到通知后，在前台、后台、未激活状态下，点击通知跳转到指定页面,包括如何设置角标等。
4. 配合服务端适配httpsTLS1.2协议，sdk全面适配iOS9。

## 使用
可手动下载后参照[百度push服务sdk用户手册（ios版）.pdf](https://github.com/shingwasix/BaiduPush-iOS-SDK/blob/1.4.3/Official-Sources/%E7%99%BE%E5%BA%A6push%E6%9C%8D%E5%8A%A1sdk%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C%EF%BC%88ios%E7%89%88%EF%BC%89.pdf)进行配置

或

使用[CocoaPods](http://cocoapods.org/)进行安装,在`Podfile`中添加如下代码

```ruby
pod 'BPushSDK'
```

或

```ruby
pod 'SS-BaiduPushSDK'
```

## 官方下载
http://push.baidu.com/sdk/push_client_sdk_for_ios

## 官方开发文档
http://push.baidu.com/doc/ios/api

## License

LICENSE ©2015 Baidu, Inc. All rights reserved.
