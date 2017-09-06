//
//  YohooAMapViewController.m
//  YohooAMapUtils
//
//  Created by fyfdayan on 09/06/2017.
//  Copyright (c) 2017 fyfdayan. All rights reserved.
//

#import "YohooAMapViewController.h"
#import <YohooAMapUtils/YohooAMapUtils.h>

//@"100000|120000|060100"
//0a0ba2a31dcce15743ab15ffbdfe0963
@interface YohooAMapViewController () <YohooAMapUtilsDelegate> {
    YohooAMapUtils *mapUtils;
}

@end

@implementation YohooAMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mapUtils = [[YohooAMapUtils alloc] initWithAppKey:@"0a0ba2a31dcce15743ab15ffbdfe0963" types:@"100000|120000|060100"];
    mapUtils.delegate = self;
    
    [mapUtils startLocate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLocateError:(YohooLocationError)errorCode {
    
}

- (void)locateSuccessful:(YohooPoi *)address {
    address.name = address.city;
    
    [mapUtils searchPoiWithAround:address radius:1000];
}

- (void)searchPoiSuccessful:(NSArray *)pois {
    for (YohooPoi *poi in pois) {
        NSLog(@"poi.name = %@", poi.name);
    }
}

@end
