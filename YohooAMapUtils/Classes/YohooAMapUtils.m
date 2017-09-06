//
//  YohooAMapUtils.m
//  Pods
//
//  Created by 傅雁锋 on 2017/9/6.
//
//

#import "YohooAMapUtils.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface YohooAMapUtils() <AMapLocationManagerDelegate, AMapSearchDelegate> {
    AMapLocationManager *manager;
    AMapSearchAPI *search;
    NSString *searchTypes;
    
    BOOL isLocating;
}

@end

@implementation YohooAMapUtils

- (BOOL)isNotEmpty:(NSString *)string {
    return !(string == nil || string.length == 0);
}

- (instancetype)initWithAppKey:(NSString *)appKey types:(NSString *)types {
    self = [super init];
    
    if (self) {
        [AMapServices sharedServices].apiKey = appKey;
        manager = [[AMapLocationManager alloc] init];
        [manager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        manager.locationTimeout = 2;
        
        search = [[AMapSearchAPI alloc] init];
        search.delegate = self;
        
        searchTypes = types;
    }
    
    return self;
}

- (void)startLocate {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        
        if (isLocating) {
            return;
        }
        
        __weak YohooAMapUtils *weakSelf = self;
        isLocating = true;
        [manager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            if (error) {
                [weakSelf locateFail:error];
                return ;
            }
            
            [weakSelf locateSuccessful:location regeocode:regeocode];
        }];
        
    } else {
        [self locateAuthorizationFail];
    }
}

- (void)locateAuthorizationFail {
    isLocating = false;
    if (_delegate && [_delegate respondsToSelector:@selector(onLocateError:)]) {
        [_delegate onLocateError:LocationErrorAuthorization];
    }
}

- (void)locateFail:(NSError *)error {
    isLocating = false;
    if (_delegate && [_delegate respondsToSelector:@selector(onLocateError:)]) {
        [_delegate onLocateError:LocationErrorLocateFail];
    }
}

- (void)locateSuccessful:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode {
    isLocating = false;
    YohooPoi *poi = [[YohooPoi alloc] init];
    poi.uid = @"-1";
    poi.lat = location.coordinate.latitude;
    poi.lng = location.coordinate.longitude;
    poi.province = regeocode.province;
    poi.city = regeocode.city;
    poi.district = regeocode.district;
    poi.address = regeocode.formattedAddress;
    
    if (_delegate && [_delegate respondsToSelector:@selector(locateSuccessful:)]) {
        [_delegate locateSuccessful:poi];
    }
}

- (void)searchPoiSuccessful:(AMapPOISearchResponse *)response {
    NSMutableArray *pois = [[NSMutableArray alloc] init];
    
    if (response.count > 0) {
        for (AMapPOI *amapPoi in response.pois) {
            YohooPoi *poi = [[YohooPoi alloc] init];
            poi.uid = amapPoi.uid;
            poi.name = amapPoi.name;
            poi.lng = amapPoi.location.longitude;
            poi.lat = amapPoi.location.latitude;
            poi.address = amapPoi.address;
            poi.province = amapPoi.province;
            poi.pcode = amapPoi.pcode;
            poi.city = amapPoi.city;
            poi.citycode = amapPoi.citycode;
            poi.district = amapPoi.district;
            poi.adcode = amapPoi.adcode;
            
            [pois addObject:poi];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(searchPoiSuccessful:)]) {
        [_delegate searchPoiSuccessful:pois];
    }
}

- (void)searchPoiWithKeyword:(NSString *)keyword cityName:(NSString *)cityName {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords = keyword;
        request.city = cityName;
        request.cityLimit = [self isNotEmpty:cityName];
        request.requireSubPOIs = false;
        request.offset = 50;
        
        [search AMapPOIKeywordsSearch:request];
    } else {
        [self locateAuthorizationFail];
    }
}

- (void)searchPoiWithAround:(YohooPoi *)location radius:(NSInteger)radius {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:location.lat longitude:location.lng];
        request.radius = radius;
        request.offset = 20;
        request.sortrule = 1;
        request.types = searchTypes;
        
        [search AMapPOIAroundSearch:request];
    } else {
        [self locateAuthorizationFail];
    }
}

#pragma mark - AMapLocationManagerDelegate

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [self searchPoiSuccessful:response];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"AMapSearchRequest didFailWithError");
}

@end
