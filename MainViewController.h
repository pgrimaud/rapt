//
//  ViewController.h
//  SidebarDemo
//
//  Created by Jeremy on 28/6/13.
//  Copyright (c) 2013 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)facebookShare:(id)sender;
- (IBAction)twitterShare:(id)sender;

@end
