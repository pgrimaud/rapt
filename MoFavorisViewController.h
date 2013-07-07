//
//  MoFavorisViewController.h
//  rapt2
//
//  Created by Moufasa on 06/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ligne.h"
@interface MoFavorisViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) NSMutableArray * lignes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
