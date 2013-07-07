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
    
    //[MapRapt setUserTrackingMode:true];
    //MapRapt.zoomEnabled = true;
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