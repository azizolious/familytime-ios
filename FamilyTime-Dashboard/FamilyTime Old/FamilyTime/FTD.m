//
//  FTD.m
//  FamilyTime - Dashboard
//
//  Created by Sora Code on 18/05/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "FTD.h"

@implementation FTD

+(FTD *)sharedInstance
{
    static dispatch_once_t pred;
    __strong static FTD * instance = nil;
    dispatch_once( &pred, ^{
        instance = [[self alloc] init]; });
    return instance;
}

@end
