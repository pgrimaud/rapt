//
//  MapViewController.h
//  SidebarDemo
//
//  Created by Piotr on 30/6/13.
//  Copyright (c) 2013 Piotr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet MKMapView *MapRapt;
@property (weak, nonatomic) IBOutlet UIButton *locateMe;
- (IBAction)postToFacebook:(id)sender;
- (IBAction)postToTwitter:(id)sender;


@end