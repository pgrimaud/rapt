//
//  MapViewController.m
//  SidebarDemo
//
//  Created by Simon on 30/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "Location.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize MapRapt;

- (IBAction)LocateMe:(id)sender {
    [MapRapt setUserTrackingMode:true];
    MapRapt.zoomEnabled = true;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Map with pins :)
    
    [MapRapt setUserTrackingMode:true];
    MapRapt.zoomEnabled = true;
    
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"ratp" ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:csvFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* allLinedStrings = [dataStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *line in allLinedStrings)
    {
        NSLog(@"%@", line);
        
        NSArray* infos = [line componentsSeparatedByString: @"#"];
        if ([infos count] > 1)
        {
            NSString * latitude = [infos objectAtIndex:2];
            NSString * longitude = [infos objectAtIndex:1];
            NSString * crimeDescription =[infos objectAtIndex:3];
            NSString * address = [infos objectAtIndex:4];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latitude.doubleValue;
            coordinate.longitude = longitude.doubleValue;
            Location *annotation = [[Location alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
            [MapRapt addAnnotation:annotation];
            
        }
    }
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end