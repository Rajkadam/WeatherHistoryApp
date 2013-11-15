//
//  ShowWheatherViewController.h
//  WeatherApp
//
//  Created by Raj Kadam on 13/11/13.
//  Copyright (c) 2013 Raj kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipTransition.h"

@interface ShowWheatherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGSize screenSize;
    int cityTag;
    //UIView* mainView;
    UITableView *weatherReprtTable;
    int count;
    NSMutableArray* currentCityHistory;
    UIButton *nextBtn,*nextCityBtn;
    UIButton *prevBtn,*prevCityBtn;
    int pageCount;
}
@property int cityTag;
@property(nonatomic, retain)NSMutableArray* allcities;
@property(nonatomic, retain)NSMutableArray* allcitiyHistory;
@property (assign, nonatomic) MPFlipStyle flipStyle;

-(NSDictionary*)jsonReqToServer:(NSString*)city;
@end
