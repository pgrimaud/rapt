//
//  MapViewController.m
//  SidebarDemo
//
//  Created by Piotr on 30/6/13.
//  Copyright (c) 2013 Piotr. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import <Social/Social.h>

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize MapRapt;

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
            Location *annotation = [[Location alloc] initWithName:crimeDescription address:address coordinate:coordinate];
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


//Locate Me

- (IBAction)LocateMe:(id)sender {
    [MapRapt setUserTrackingMode:true];
    MapRapt.zoomEnabled = true;

}

//Facebook post

- (IBAction)postToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"#RATP, controlleurs près de [RENSEIGNER ICI]"];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

//Twitter post

- (IBAction)postToTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#RATP, controlleurs près de [RENSEIGNER ICI]"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

@end