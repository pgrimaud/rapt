//
//  MoApiFetcher.h
//  RapT
//
//  Created by Moufasa on 28/06/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Ligne.h"
#import "Station.h"
#import "MoHoraire.h"
@interface MoApiFetcher : NSObject

+(NSArray *) allLignes;
+(Ligne *) getOneLigne: (NSURL *) url;
+(Ligne *) getStationForLigne : (Ligne *) ligne;
+(NSMutableArray *) getHoraireForStation : (Station *) station andLigne :  (Ligne *) ligne;

@end