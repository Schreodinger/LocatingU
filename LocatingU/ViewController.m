//
//  ViewController.m
//  LocatingU
//
//  Created by wangAngelo on 1/7/16.
//  Copyright © 2016 angelowang. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

//#define type (int)1

@interface ViewController () <CLLocationManagerDelegate>
- (IBAction)locBtnClicked;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) AFHTTPRequestOperationManager *afManager;


@end

@implementation ViewController

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[UIDevice currentDevice].systemVersion hasPrefix:@"9"] || [[UIDevice currentDevice].systemVersion hasPrefix:@"8"]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
         
    [self.locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)updateLocationWithLongitude:(CLLocationDegrees)longitude andLatitude:(CLLocationDegrees)latitude {
    
    AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.haoservice.com/api/getLocationinfor"];
   // NSURL *url = [NSURL URLWithString:str];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //[param setValue:[NSString stringWithFormat:@"%f,%f;%f,%f",latitude,longitude,latitude,longitude] forKey:@"lnglatInfor"];
    param[@"latlng"] = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
   
    param[@"type"] = @"2";
    
#warning please add your own appKey
#warning API Address   http://www.haoservice.com/docs/8
    param[@"key"] = @"";
    
    
    
    [afManager GET:url parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject[@"result"];
        NSLog(@"------%@",result[@"Address"]);
        self.locLabel.text = result[@"Address"];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------error------");
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = locations.lastObject;
    self.longitude = loc.coordinate.longitude;
    self.latitude = loc.coordinate.latitude;
    if (loc.horizontalAccuracy > 0) {
        NSLog(@"-------------%f-------------%f",self.longitude,self.latitude);
        [manager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"-------------%@",error);
}


- (IBAction)locBtnClicked {
    
    //self.locLabel.text = [NSString stringWithFormat:@"%f / %f",self.longitude,self.latitude];
    [self updateLocationWithLongitude:self.longitude andLatitude:self.latitude];
}
@end
