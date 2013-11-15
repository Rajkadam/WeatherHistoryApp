//
//  ViewController.m
//  WeatherApp
//
//  Created by Raj Kadam on 13/11/13.
//  Copyright (c) 2013 Raj kadam. All rights reserved.
//

#import "ViewController.h"
#import "ShowWheatherViewController.h"
#import "MBProgressHUD.h"
#define WIDTH 180
#define HEIGHT 30
#define x_offset 20

@interface ViewController ()

@end
static NSString *backgroundImage;
@implementation ViewController
@synthesize allCities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        screenSize = [[UIScreen mainScreen] bounds].size;
        if(screenSize.height>=548)
            backgroundImage=@"background.png";
        else
            backgroundImage=@"background.png";
        
        allCities = [[NSMutableArray alloc] init];
        [self initializeLocationManager];
        [self UIInitialization];
    }
    
    return self;
}

-(void)UIInitialization
{
    
    count = 1;
     
    allCities = [[NSMutableArray alloc] init];
    
    UIImageView* img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width,screenSize.height-20)];
    img.image=[UIImage imageNamed:backgroundImage];
    img.backgroundColor=[UIColor grayColor];
    [self.view addSubview:img];
    
       
    UIImageView* backStripimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, screenSize.height*0.20-8, 320, HEIGHT+16)];
    backStripimg.image=[UIImage imageNamed:@"strip.png"];
    
    [self.view addSubview:backStripimg];
    
    cityText=[[UITextField alloc]init];
    cityText.borderStyle=UITextBorderStyleRoundedRect;
    cityText.textAlignment=NSTextAlignmentLeft;
    [cityText setUserInteractionEnabled:YES];
    cityText.autocorrectionType = UITextAutocorrectionTypeNo;
    [cityText sizeToFit];
    
    [cityText setFrame:CGRectMake(x_offset, screenSize.height*0.20, WIDTH, HEIGHT)];
    [cityText setKeyboardType:UIKeyboardTypeAlphabet];
    [cityText setPlaceholder:@"Enter city name"];
    
    cityText.leftViewMode=UITextFieldViewModeAlways;
    cityText.delegate = self;
    [self.view addSubview:cityText];
    
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addMoreBtn setFrame:CGRectMake(x_offset+WIDTH+20, screenSize.height*0.19,69,40)];
   
    [addMoreBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addMoreBtn addTarget:self action:@selector(addMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:addMoreBtn];
    
    
    
    backStripimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, screenSize.height*0.75-3, 320, HEIGHT+20)];
    backStripimg.image=[UIImage imageNamed:@"strip.png"];
    
    [self.view addSubview:backStripimg];
    
    showBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showBtn setFrame:CGRectMake(x_offset-5, screenSize.height*0.75,142 ,44)];
    
    [showBtn setBackgroundImage:[UIImage imageNamed:@"ViewWeather.png"] forState:UIControlStateNormal];
   
    [showBtn addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:showBtn];
    
    currentCityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currentCityBtn setFrame:CGRectMake(x_offset+WIDTH-30, screenSize.height*0.75,142,44)];
   
    [currentCityBtn addTarget:self action:@selector(currentCityClicked:) forControlEvents:UIControlEventTouchUpInside];
   [currentCityBtn setBackgroundImage:[UIImage imageNamed:@"CurrentCity.png"] forState:UIControlStateNormal];
    currentCityBtn.enabled = false;
    [self.view addSubview:currentCityBtn];

}

-(void)initializeLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // Update again when a user moves distance in meters
    [locationManager setDistanceFilter:100];

    [locationManager startUpdatingLocation];
}

-(void)currentCityClicked:(UIButton*)sender
{
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    NSMutableArray* allcityHistory = [[NSMutableArray alloc] init];
    allCities = [[NSMutableArray alloc] init];
    [allcityHistory addObject:[self jsonReqToServer:currentCity]];
   
    [allCities addObject:currentCity];
    ShowWheatherViewController* history = [[ShowWheatherViewController alloc] initWithNibName:@"ShowWheatherViewController" bundle:nil];
    history.allcities = allCities;
    history.allcitiyHistory = allcityHistory;
    history.cityTag = 0;
    
    [self presentModalViewController:history animated:YES];

    [self hideActivityIndicator];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    location = [locations objectAtIndex:0];
    CLGeocoder *theGeocoder=[[CLGeocoder alloc] init];
    [locationManager stopUpdatingLocation];
    [theGeocoder reverseGeocodeLocation:location completionHandler:
     
     ^(NSArray* placemarks, NSError* error){
         
         if ([placemarks count] > 0)
             
         {
             CLPlacemark *placeMark=[placemarks objectAtIndex:0];
             NSDictionary *temp=[placeMark addressDictionary];
             
             
             currentCity=[NSString stringWithFormat:@"%@",[temp objectForKey:@"City"]];
             NSLog(@"placemark object \n %@",currentCity);
             currentCityBtn.enabled = true;
             
             
         }
         
     }];
    
}
-(void)showHistory:(UIButton*)sender
{
    if (cityText.text.length>2) {
        [allCities addObject:cityText.text];
    }
    if (allCities.count==0) {
        NSString* msg = [NSString stringWithFormat:@"Please enter atleast one city."];
       [self showAlert:msg];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    NSMutableArray* allcityHistory = [[NSMutableArray alloc] init];
    [allcityHistory addObject:[self jsonReqToServer:[allCities objectAtIndex:0]]];
    
    ShowWheatherViewController* history = [[ShowWheatherViewController alloc] initWithNibName:@"ShowWheatherViewController" bundle:nil];
    history.allcities = allCities;
    history.allcitiyHistory = allcityHistory;
    history.cityTag = 0;
    
    [self presentModalViewController:history animated:YES];
    
    [self hideActivityIndicator];
    
}
-(void)addMoreClicked:(UIButton*)sender
{
    if (cityText.text.length>2) {
        [self addCityName:cityText.text];
        cityText.text = @"";
    }
    [cityText resignFirstResponder];
}
-(void)addCityName:(NSString*)city
{
    
    if ([allCities containsObject:city]) {
        NSString* msg = [NSString stringWithFormat:@"%@ city  already selected please add another city.",city];
        [self showAlert:msg];
        return;
    }
    if (allCities.count>4) {
        NSString* msg = [NSString stringWithFormat:@"You can not add more than 5 city at a time."];
        [self showAlert:msg];
        return;
    }
    UILabel *label=[[UILabel alloc]init];
    [label setFrame:CGRectMake(x_offset, screenSize.height*0.30+count*30, WIDTH, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont boldSystemFontOfSize:16];
   
    
    label.text=city;
    [self.view addSubview:label];
    
    
    count++;
    //[showBtn setFrame:CGRectMake(x_offset, screenSize.height*0.30+count*35,142 ,44)];
    //[currentCityBtn setFrame:CGRectMake(x_offset+WIDTH+15, screenSize.height*0.30+count*35,142,44)];
    [allCities addObject:city];
    NSLog(@"all cities : %@",allCities);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma UITextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text %@",textField.text);
    if (textField.text.length>2) {
        [self addCityName:textField.text];
        textField.text = @"";
    }
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
        
    [cityText endEditing:YES];
    [cityText resignFirstResponder];
    
}

-(void)showActivityIndicator
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
}
-(void)hideActivityIndicator
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(NSDictionary*)jsonReqToServer:(NSString*)city{
    
       NSError *errorReturned = nil;
    NSError *error = nil;
   
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[[NSDate alloc] init]];
    NSDate *today = [cal dateFromComponents:components];
    long endDate = [today timeIntervalSince1970];
    components = [[NSDateComponents alloc] init];
    [components setMonth:-1];
    NSDate *lastMonth = [cal dateByAddingComponents:components toDate:today options:0];
        
    
    long startDate = [lastMonth timeIntervalSince1970];
    NSLog(@"today %ld",endDate);
    NSLog(@"last month %ld",endDate);
    
    
    NSString *urlString =[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/history/city?q=%@&APPID=9a1782c0d83dde6f33f8d9977e82e51f&start=%ld&end=%ld",city,startDate,endDate];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
   
    
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
   
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *responseDictionary = [[NSDictionary alloc] init];
    if (responseData) {
            responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"response data %@",responseDictionary);
        
        
        if (error) {
            NSLog(@"Error encountered %@",[error localizedDescription]);
            
            return responseDictionary;
        }else{
            return responseDictionary;
        }
        
                
    }
    else
    {
        // Handle Error
    }
    
    if (errorReturned)
    {
        //...handle the error
        NSLog(@"Error occured");
    }
    
    return responseDictionary;
    
    
}
@end
