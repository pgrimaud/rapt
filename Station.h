//
//  Station.h
//  rapt2
//
//  Created by Moufasa on 05/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ligne;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (assign, readwrite) BOOL inBase;

@property (nonatomic, retain) Ligne *ligne;

@end
