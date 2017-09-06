//
//  YohooPoi.h
//  Pods
//
//  Created by 傅雁锋 on 2017/9/6.
//
//

#import <Foundation/Foundation.h>

@interface YohooPoi : NSObject

@property (copy, nonatomic) NSString *uid;
//名称
@property (nonatomic, copy)   NSString     *name;
//经纬度
@property (nonatomic)   double lng;
@property (nonatomic)   double lat;
//地址
@property (nonatomic, copy)   NSString     *address;
//省
@property (nonatomic, copy)   NSString     *province;
//省编码
@property (nonatomic, copy)   NSString     *pcode;
//城市名称
@property (nonatomic, copy)   NSString     *city;
//城市编码
@property (nonatomic, copy)   NSString     *citycode;
//区域名称
@property (nonatomic, copy)   NSString     *district;
//区域编码
@property (nonatomic, copy)   NSString     *adcode;

@end
