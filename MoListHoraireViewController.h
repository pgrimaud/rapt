//
//  MoListHoraireViewController.h
//  rapt2
//
//  Created by Moufasa on 07/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ligne.h"
#import "MoHoraire.h"
#import "Station.h"
#import "MoApiFetcher.h"

@interface MoListHoraireViewController : UITableViewController

@property(nonatomic,retain) Ligne * ligne;
@property(nonatomic,retain) Station * station;
@property(nonatomic,retain) NSMutableArray * horaires;

@end
