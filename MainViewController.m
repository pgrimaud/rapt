//
//  ViewController.m
//  SidebarDemo
//
//  Created by Jeremy on 28/6/13.
//  Copyright (c) 2013 Jeremy. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import <Social/Social.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Accueil";

    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookShare:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"J'utilise une super application pour les horaires #RATP : RAPT"];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)twitterShare:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"J'utilise une super application pour les horaires #RATP : RAPT"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}
@end
