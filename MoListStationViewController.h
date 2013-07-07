//
//  MoListStationViewController.h
//  rapt2
//
//  Created by Moufasa on 06/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ligne.h"
#import "Station.h"
#import "MoApiFetcher.h"
#import "MoListHoraireViewController.h"

@interface MoListStationViewController : UITableViewController

@property (nonatomic, retain) Ligne * ligne;
@property (nonatomic, retain) NSMutableArray * stations;
@end
