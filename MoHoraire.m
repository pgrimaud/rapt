//
//  MoHoraire.m
//  RapT
//
//  Created by Moufasa on 24/06/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import "MoHoraire.h"

@implementation MoHoraire

- (NSString *)description {
    return [NSString stringWithFormat: @"Photo: terminus=%@ horaire=%@", [self terminus], [self horaire]];
}

@end
