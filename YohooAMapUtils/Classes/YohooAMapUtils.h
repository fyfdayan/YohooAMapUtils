//
//  YohooAMapUtils.h
//  Pods
//
//  Created by 傅雁锋 on 2017/9/6.
//
//

#import <Foundation/Foundation.h>
#import "YohooPoi.h"

typedef enum : NSUInteger {
    LocationErrorAuthorization = 0,
    LocationErrorLocateFail,
    LocationErrorSearchFail,
} YohooLocationError;

@protocol YohooAMapUtilsDelegate <NSObject>

@optional
/**
 错误
 
 @param errorCode 错误代码
 */
- (void)onLocateError:(YohooLocationError)errorCode;

/**
 定位成功
 
 @param address 位置信息
 */
- (void)locateSuccessful:(YohooPoi *)address;

/**
 查询poi成功
 
 @param pois poi信息
 */
- (void)searchPoiSuccessful:(NSArray *)pois;

@end

@interface YohooAMapUtils : NSObject

/**
 初始化

 @param appKey appkey
 @param types 搜索类型
 @return 实例
 */
- (id)initWithAppKey:(NSString *)appKey types:(NSString *)types;

/**
 开始定位
 */
- (void)startLocate;

/**
 根据关键字搜索poi
 
 @param keyword 关键字
 @param cityName 城市名称
 */
- (void)searchPoiWithKeyword:(NSString *)keyword cityName:(NSString *)cityName;

/**
 搜索周边poi
 
 @param location 中心的位置
 @param radius 查询半径，范围：0-50000，单位：米 [default = 3000]
 */
- (void)searchPoiWithAround:(YohooPoi *)location radius:(NSInteger)radius;

@property (assign, nonatomic) id<YohooAMapUtilsDelegate> delegate;

@end
