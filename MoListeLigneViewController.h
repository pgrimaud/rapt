//
//  MoListeLigneViewController.h
//  rapt2
//
//  Created by Moufasa on 06/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoApiFetcher.h"
#import "Ligne.h"
#import "MoListStationViewController.h"

@interface MoListeLigneViewController : UITableViewController

@property (nonatomic,retain) NSArray * lignes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
