//
//  ShowWheatherViewController.m
//  WeatherApp
//
//  Created by Raj Kadam on 13/11/13.
//  Copyright (c) 2013 Raj kadam. All rights reserved.
//

#import "ShowWheatherViewController.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ShowWheatherViewController ()

@end
static NSString *backgroundImage;
@implementation ShowWheatherViewController
@synthesize allcities;
@synthesize allcitiyHistory;
@synthesize cityTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        screenSize = [[UIScreen mainScreen] bounds].size;
        if(screenSize.height>=548)
            backgroundImage=@"background1.png";
        else
            backgroundImage=@"background1.png";
        
                
        count = 0;
        pageCount = 0;
       
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initilizeUI];
}
-(void)initilizeUI
{
    
     currentCityHistory  = [[NSMutableArray alloc] initWithArray:[[allcitiyHistory objectAtIndex:cityTag] objectForKey:@"list"] copyItems:YES];
   
    NSLog(@"city history: %@",currentCityHistory);
    
    
    UIImageView* img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width,screenSize.height)];
    img.image=[UIImage imageNamed:backgroundImage];
    img.backgroundColor=[UIColor grayColor];
    [self.view addSubview:img];
    
    
    UILabel *headerLabel=[[UILabel alloc]init];
    [headerLabel setFrame:CGRectMake(0, screenSize.height*0.02, 320, 30)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.font=[UIFont boldSystemFontOfSize:22];
    headerLabel.text = [allcities objectAtIndex:cityTag];
    [self.view addSubview:headerLabel];
    
    UILabel *dateLabel=[[UILabel alloc]init];
    [dateLabel setFrame:CGRectMake(35, screenSize.height*0.11, 320, 60)];
    dateLabel.backgroundColor=[UIColor clearColor];
    dateLabel.textAlignment=NSTextAlignmentLeft;
    dateLabel.font=[UIFont systemFontOfSize:16];
    dateLabel.text = @"Date";
    [self.view addSubview:dateLabel];
      
    UILabel *maxTempLabel=[[UILabel alloc]init];
    [maxTempLabel setFrame:CGRectMake(115, screenSize.height*0.11, 50, 60)];
    maxTempLabel.backgroundColor=[UIColor clearColor];
    maxTempLabel.textAlignment=NSTextAlignmentCenter;
    maxTempLabel.numberOfLines = 2;
    maxTempLabel.font=[UIFont systemFontOfSize:16];
    maxTempLabel.text = @"Max  Temp";
    [self.view addSubview:maxTempLabel];
    
    UILabel *minTempLabel=[[UILabel alloc]init];
    [minTempLabel setFrame:CGRectMake(190, screenSize.height*0.11, 50, 60)];
    minTempLabel.backgroundColor=[UIColor clearColor];
    minTempLabel.textAlignment=NSTextAlignmentCenter;
    minTempLabel.numberOfLines = 2;
    minTempLabel.font=[UIFont systemFontOfSize:16];
    minTempLabel.text = @"Min  Temp";
    [self.view addSubview:minTempLabel];
    
    UILabel *descriptionLbl=[[UILabel alloc]init];
    [descriptionLbl setFrame:CGRectMake(250, screenSize.height*0.11, 70, 60)];
    descriptionLbl.backgroundColor=[UIColor clearColor];
    descriptionLbl.textAlignment=NSTextAlignmentLeft;
    descriptionLbl.numberOfLines = 2;
    descriptionLbl.font=[UIFont systemFontOfSize:16];
    descriptionLbl.text = @"Weather";
    [self.view addSubview:descriptionLbl];
    
    weatherReprtTable=[[UITableView alloc]initWithFrame:CGRectMake(20, screenSize.height*0.25, screenSize.width-40,screenSize.height-160) style:UITableViewStylePlain];
    weatherReprtTable.allowsSelection=NO;
    [weatherReprtTable setSeparatorColor:[UIColor whiteColor]]; // blue
   
    
    [weatherReprtTable setBackgroundColor:[UIColor clearColor]];
    weatherReprtTable.dataSource=self;
    weatherReprtTable.delegate=self;
    weatherReprtTable.rowHeight=40;
    [self.view addSubview:weatherReprtTable];
    
    nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
     [nextBtn setFrame:CGRectMake(320-23, ((screenSize.height-20)/2)-100, 23, 313)];
     [nextBtn setBackgroundImage:[UIImage imageNamed:@"right bar.png"] forState:UIControlStateNormal];
     [nextBtn addTarget:self action:@selector(nextHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    prevBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn setFrame:CGRectMake(0, ((screenSize.height-20)/2)-100, 23, 313)];
    
    [prevBtn setBackgroundImage:[UIImage imageNamed:@"left bar.png"] forState:UIControlStateNormal];
    [prevBtn addTarget:self action:@selector(prevHistory:) forControlEvents:UIControlEventTouchUpInside];
    prevBtn.enabled = NO;
    [self.view addSubview:prevBtn];
    
    nextCityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextCityBtn setFrame:CGRectMake(screenSize.width/2+70, screenSize.height*0.03, 23, 23)];
    [nextCityBtn setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [nextCityBtn addTarget:self action:@selector(nextCityHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextCityBtn];
    
    prevCityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [prevCityBtn setFrame:CGRectMake(screenSize.width/2-80, screenSize.height*0.03, 23, 23)];
    
    [prevCityBtn setBackgroundImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    [prevCityBtn addTarget:self action:@selector(prevCityHistory:) forControlEvents:UIControlEventTouchUpInside];
    prevCityBtn.enabled = NO;
    [self.view addSubview:prevCityBtn];
    
    UIButton* homeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(10, 0, 35, 35)];
    
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn.png"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];

    
    
    [self hideActivityIndicator];
}

-(void)homeBtnClicked:(UIButton*)sender
{
    ViewController* home = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:home animated:YES];
}

-(void)nextHistory:(NSString*)sender{
    
    if (pageCount+1>[[[allcitiyHistory objectAtIndex:cityTag] objectForKey:@"cnt"] intValue]/24) {
        nextBtn.enabled = NO;
        return;
    }
    
    [MPFlipTransition transitionFromViewController:self toViewController:self duration:0.4 style:false completion:^(BOOL finished) {
        
        
        pageCount++;
        
        
        [self initilizeUI];
        [prevBtn setEnabled:YES];
        [weatherReprtTable reloadData];
        if (pageCount+1>[[[allcitiyHistory objectAtIndex:cityTag] objectForKey:@"cnt"] intValue]/24) {
            [nextBtn setEnabled:NO];
            return;
        }
        
        return;
    }];

}
-(void)prevHistory:(NSString*)sender{
   
    nextBtn.enabled = YES;
    if (pageCount<1) {
        prevBtn.enabled = NO;
        return;
    }
    
     pageCount--;
    [MPFlipTransition transitionFromViewController:self toViewController:self duration:0.4 style:true completion:^(BOOL finished) {
        
        
        
               [self initilizeUI];
        [weatherReprtTable reloadData];
        if (pageCount<1) {
            prevBtn.enabled = NO;
            return;
        }else
             prevBtn.enabled = YES;
        
        return;
    }];

}


-(void)nextCityHistory:(NSString*)sender{
    
    if (allcities.count-1 == cityTag)
    {
        nextCityBtn.enabled = NO;
        return;
    }
    
    [MPFlipTransition transitionFromViewController:self toViewController:self duration:0.4 style:false completion:^(BOOL finished) {
        
        pageCount=0;
        cityTag++;
        [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
        [NSThread detachNewThreadSelector:@selector(nextCity) toTarget:self withObject:nil];
                    
        return;
    }];
    
    
    
}
-(void)nextCity
{
    if (allcitiyHistory.count-1 < cityTag) {
        [allcitiyHistory addObject:[self jsonReqToServer:[allcities objectAtIndex:cityTag]]];
    }
    
    [self initilizeUI];
    if (allcities.count-1 == cityTag)
    {
        nextCityBtn.enabled = NO;
        
    }
    if (allcities.count!=1)
        prevCityBtn.enabled = YES;
    if (cityTag == 0)
        prevCityBtn.enabled = NO;

    [weatherReprtTable reloadData];
}
-(void)prevCityHistory:(NSString*)sender{
    
    
    
    if (cityTag == 0) {
        prevCityBtn.enabled = NO;
        return;
    }
    
        [MPFlipTransition transitionFromViewController:self toViewController:self duration:0.4 style:true completion:^(BOOL finished) {
            
            
            cityTag--;
            [self initilizeUI];
            [weatherReprtTable reloadData];
            
            if (allcities.count-1 == cityTag)
                nextCityBtn.enabled = NO;
            
            if (cityTag != 0) 
                prevCityBtn.enabled = YES;

            return;
        }];
   
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentCityHistory.count>24) {
        return 24;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (currentCityHistory.count ==0) {
        UILabel *noHistory=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, 35)];
        noHistory.backgroundColor = [UIColor clearColor];
        noHistory.textAlignment=NSTextAlignmentLeft;
        noHistory.font=[UIFont boldSystemFontOfSize:14];
        noHistory.text = @"No history found for given city!";
        [cell addSubview:noHistory];
    }
    if (currentCityHistory.count<indexPath.row+(pageCount*24)+1) {
        nextBtn.enabled = false;
        return cell;
    }
    NSDictionary *oneRecord;
    
    oneRecord=[currentCityHistory objectAtIndex:indexPath.row+(pageCount*24)];
    
    UILabel *date=[[UILabel alloc] initWithFrame:CGRectMake(2, 5, 80, 35)];
    date.backgroundColor = [UIColor clearColor];
    date.textAlignment=NSTextAlignmentLeft;
    date.numberOfLines = 2;
    date.font=[UIFont systemFontOfSize:13];
    NSLog(@"oneRecord %@",oneRecord);
    NSTimeInterval temp = [[oneRecord objectForKey:@"dt"] longLongValue];
    NSDate *currTime = [NSDate dateWithTimeIntervalSince1970:temp ];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy/MM/dd HH:mm a"];
    date.text = [NSString stringWithFormat:@"%@",[formatter1 stringFromDate:currTime]];
    [cell addSubview:date];
    
    UILabel *maxTemp = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 25)];
    maxTemp.backgroundColor = [UIColor clearColor];
    
    maxTemp.text =[NSString stringWithFormat:@"%.2f⁰c",[[[oneRecord objectForKey:@"main"] objectForKey:@"temp_max"] floatValue]-272.15];
    [cell addSubview:maxTemp];
    UILabel *minTemp = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 100, 25)];
    minTemp.backgroundColor = [UIColor clearColor];
    minTemp.text = [NSString stringWithFormat:@"%.2f⁰c",[[[oneRecord objectForKey:@"main"] objectForKey:@"temp_min"] floatValue]-272.15];
    [cell addSubview:minTemp];

    [cell addSubview:[self setImg:[[[oneRecord objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]]];
    
    return cell;
}
-(UIImageView*)setImg:(NSString*)type
{
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(250, 10, 25, 25)];
    if ([type isEqualToString:@"Clouds"])
    {
        image.image = [UIImage imageNamed:@"clouds.png"];
    }
    else if ([type isEqualToString:@"Rain"]) 
    {
        image.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([type isEqualToString:@"Fog"]) 
    {
        image.image = [UIImage imageNamed:@"fog.png"];
    }
    else if ([type isEqualToString:@"Drizzle"]) 
    {
        image.image = [UIImage imageNamed:@"drizzle.png"];
    }
    else{
            image.image = [UIImage imageNamed:@"clear.png"];
    }
    
        return image;
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
