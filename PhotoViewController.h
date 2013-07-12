//
//  PhotoViewController.h
//  SidebarDemo
//
//  Created by Jeremy on 30/6/13.
//  Copyright (c) 2013 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) NSString *photoFilename;
@end
