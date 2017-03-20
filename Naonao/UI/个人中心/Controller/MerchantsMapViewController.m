//
//  MerchantsMapViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MerchantsMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JXMapNavigationView.h"

@interface MerchantsMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) JXMapNavigationView *mapNavigationView;
@property (nonatomic, strong) CLLocation *currentLocation;              //当前位置

@end



@implementation MerchantsMapViewController

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc] init];
    }
    return _mapNavigationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:_address.name];
    [self initializeGPSModule];
    
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navbar.frame))];
    _mapView = mapView;
    _mapView.zoomEnabled = YES;
    //显示用户当前位置
    _mapView.showsUserLocation = YES;
    _mapView.scrollEnabled = YES;
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    
    [self.view addSubview:_mapView];

    [self addPointAnnotation];
}

- (void)initializeGPSModule{

    if ([CLLocationManager locationServicesEnabled]){
        // 初始化并开始更新
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // 设置定位精度
        // kCLLocationAccuracyNearestTenMeters:精度10米
        // kCLLocationAccuracyHundredMeters:精度100 米
        // kCLLocationAccuracyKilometer:精度1000 米
        // kCLLocationAccuracyThreeKilometers:精度3000米
        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源
        // 设置寻址经度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100;

        [self.locationManager startUpdatingLocation];
        
        if(isIOS8)
        {
            //ios8新增的定位授权功能
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }
    else{
        [self.view makeToast:@"定位失败,请打开定位功能"];
    }
}

- (void)addPointAnnotation
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    //设置显示范围
    MKCoordinateRegion region;
    annotation.coordinate = CLLocationCoordinate2DMake([_address.latitude doubleValue], [_address.longitude doubleValue]);
    annotation.title = _address.name;
    annotation.subtitle = _address.address;
    [self.mapView addAnnotation:annotation];
    
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    region.center = CLLocationCoordinate2DMake([_address.latitude doubleValue], [_address.longitude doubleValue]);

    // 设置显示位置(动画)
    [_mapView setRegion:region animated:YES];
    
    // 设置地图显示的类型及根据范围进行显示
    [_mapView regionThatFits:region];
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    CLog(@"纬度:%f", newLocation.coordinate.latitude);
    CLog(@"经度:%f", newLocation.coordinate.longitude);
    
    _currentLocation = newLocation;
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CLog(@"error:%@",error);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:_currentLocation.coordinate.latitude currentLongitute:_currentLocation.coordinate.longitude TotargetLatitude:[_address.latitude doubleValue] targetLongitute:[_address.longitude doubleValue] toName:_address.name];
    [self.view addSubview:_mapNavigationView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;

    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
