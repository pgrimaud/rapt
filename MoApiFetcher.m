//
//  MoApiFetcher.m
//  RapT
//
//  Created by Moufasa on 28/06/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import "MoApiFetcher.h"

#define BASEAPI @"http://api-ratp.pierre-grimaud.fr"

#define URI_LIGNE_A @"/data/destinations/rer/a"
#define URI_LIGNE_B @"/data/destinations/rer/b"

#define URI_STATION @"/data/stations/rer/"
//#define URI_STATION_B @"/data/stations/rer/b"

@implementation MoApiFetcher

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(NSArray *) allLignes{
    //Téléchargement du JSon
    
    NSURL * url = [NSURL URLWithString:[BASEAPI  stringByAppendingString:URI_LIGNE_A]];
    
    NSMutableArray * ligneCollection = [[NSMutableArray alloc]init];
    [ligneCollection addObject:[self getOneLigne:url]];
    
    url = [NSURL URLWithString:[BASEAPI  stringByAppendingString:URI_LIGNE_B]];
    [ligneCollection addObject:[self getOneLigne:url]];
    
    return ligneCollection;
}

+(Ligne *) getOneLigne:(NSURL *)url {
    
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    if (!data)
    {
        return nil;
    }
    
    //Transformer le JSON en objet natif ObjC
    id JSonAnswer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    Ligne * ligne = [[Ligne alloc]init];
    NSManagedObjectContext * context = [self managedObjectContext];
    
    //SELECT
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Ligne" inManagedObjectContext:context];
    
    // Ajout d'une clause WHERE
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", [JSonAnswer objectForKey:@"ligne"]];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    //recuperer withFetchAll
    NSError * error = nil; //hack error
    NSArray * resu = [context executeFetchRequest:request error:&error];
    NSLog(@"count de resu : %d",[resu count]);
    if([resu count] < 1 ){
        Ligne * ligne = [NSEntityDescription insertNewObjectForEntityForName:@"Ligne" inManagedObjectContext:context];
        
        ligne.name = [JSonAnswer objectForKey:@"ligne"];
        //ligne.depart = [[[JSonAnswer objectForKey:@"destinations"] objectAtIndex:0] objectForKey:@"destination"];
        ligne.arrive = [[[JSonAnswer objectForKey:@"destinations"] objectAtIndex:1] objectForKey:@"destination"];
        //ligne = [self getStationForLigne:ligne];
        return ligne;
    }
    else{
        return [resu objectAtIndex:0];
    }
}


+(Ligne *) getForcedStationForLigne : (Ligne *) ligne{
    
    NSString * strUrl = [NSString stringWithFormat:@"%@%@%@",BASEAPI ,URI_STATION,ligne.name];
    
    NSURL * url = [NSURL URLWithString:strUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    if (!data)
    {
        return nil;
    }
    
    //Transformer le JSON en objet natif ObjC
    id JSonAnswer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray * stations = [JSonAnswer objectForKey:@"stations"];
    
    NSError * error = nil; //hack error
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inBase == 1"];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSMutableArray * lorem = (NSMutableArray *)[context executeFetchRequest:request error:&error];
    Station * savedStation;
    //BOOL isEmpty = false;
    [ligne removeStations:ligne.stations];
    if([lorem count] > 0){
        
        savedStation = [lorem objectAtIndex:0];
        NSLog(@"On a bien une station sauvegardé : ligne %@ station : %@",savedStation.ligne.name,savedStation.name);
//        if([ligne.name isEqualToString:savedStation.ligne.name]){
//            [ligne addStationsObject:savedStation];
//        }
    }
    else{
        NSLog(@"Aucune station save.");
        //isEmpty = true;
    }
    
    [ligne removeStations:ligne.stations];
    for( NSDictionary * currentStation in stations){
        
        NSManagedObjectContext * context = [self managedObjectContext];
       // if (isEmpty == true || ![savedStation.name isEqualToString:[currentStation objectForKey:@"station"]]) {
            Station * station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
            station.name = [currentStation objectForKey:@"station"];
            station.inBase = NO;
            if ([lorem count] > 0 && [savedStation.name isEqualToString:[currentStation objectForKey:@"station"]]) {
                station.inBase = YES;
                NSLog(@"FOUUUND");
            }
        
            [ligne addStationsObject:station];
        //}
    }
    return ligne;
}

+(Ligne *) getStationForLigne : (Ligne *) ligne{
    
    NSString * strUrl = [NSString stringWithFormat:@"%@%@%@",BASEAPI ,URI_STATION,ligne.name];
    NSLog(@"%@",strUrl);
    NSURL * url = [NSURL URLWithString:strUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    if (!data)
    {
        return nil;
    }
    
    //Transformer le JSON en objet natif ObjC
    id JSonAnswer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //NSLog(@"%d",(int)[ [JSonAnswer objectForKey:@"stations"] count]);
    NSArray * stations = [JSonAnswer objectForKey:@"stations"];
    for( NSDictionary * currentStation in stations){
        
        //Station * station = [[Station alloc] init];
        NSManagedObjectContext * context = [self managedObjectContext];
        
        //SELECT
        NSFetchRequest * request = [[NSFetchRequest alloc]init];
        NSEntityDescription * entity = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];
        
        // Ajout d'une clause WHERE
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", [currentStation objectForKey:@"station"]];
        [request setPredicate:predicate];
        [request setEntity:entity];
        
        //recuperer withFetchAll
        NSError * error = nil; //hack error
        NSArray * data = [context executeFetchRequest:request error:&error];
        if([data count] <= 1 ){
            Station * station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
            station.name = [currentStation objectForKey:@"station"];
            [ligne addStationsObject:station];
        }
        //NSLog(@"%@",station.name);
        //station = [self getHoraireForStation:station andLigne:ligne];
        //NSLog(@"%d",(int)[station.horaires count]);
        //NSLog(@"%@",station.name);
        
    }
    return ligne;
}


+(NSMutableArray *) getHoraireForStation : (Station *) station andLigne :  (Ligne *) ligne{
    NSString * strUrl = [NSString stringWithFormat:@"%@/rer/%@/%@/%@",BASEAPI ,ligne.name ,station.name,ligne.arrive];
    NSURL * url = [NSURL URLWithString:strUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    if (!data)
    {
        return nil;
    }
    
    NSMutableArray * horaires = [[NSMutableArray alloc]init];
    
    //Transformer le JSON en objet natif ObjC
    id JSonAnswer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for(NSDictionary * data in [JSonAnswer objectForKey:@"horaires"] ){
        MoHoraire * horaire = [[MoHoraire alloc]init];
        horaire.terminus = [data objectForKey:@"terminus"];
        
        //partie horaire
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        horaire.horaire = [df dateFromString: [data objectForKey:@"horaire"]];
        // NSLog(@"%@",[data objectForKey:@"horaire"]);
        // NSLog(@"%@",station.name);
        [horaires addObject:horaire];
    }
    
    return horaires;
}

@end
