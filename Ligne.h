//
//  Ligne.h
//  rapt2
//
//  Created by Moufasa on 05/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ligne : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * arrive;
@property (assign, readwrite) BOOL inBase;

@property (nonatomic, retain) NSSet *stations;
@end

@interface Ligne (CoreDataGeneratedAccessors)

- (void)addStationsObject:(NSManagedObject *)value;
- (void)removeStationsObject:(NSManagedObject *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;

@end
