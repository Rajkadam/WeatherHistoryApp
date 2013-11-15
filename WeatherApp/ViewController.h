//
//  ViewController.h
//  WeatherApp
//
//  Created by Raj Kadam on 13/11/13.
//  Copyright (c) 2013 Raj kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipTransition.h"
#import <CoreLocation/CLLocationManager.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>
{
    CGSize screenSize;
   
    UIButton* showBtn,*currentCityBtn;
    UITextField *cityText;
    int count;
    CLLocationManager *locationManager;
    CLLocation *location;
    NSString* currentCity;
    NSCharacterSet *blockedCharacters;
}
@property (assign, nonatomic) MPFlipStyle flipStyle;
@property NSMutableArray* allCities;
-(IBAction) editingChanged:(UITextField*)sender;
@end
