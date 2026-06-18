//
//  FTD.h
//  FamilyTime - Dashboard
//
//  Created by Sora Code on 18/05/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTD : NSObject

+(FTD *)sharedInstance;

@property (nonatomic, strong) NSArray * FTDalerts;
@property (nonatomic, strong) NSArray * FTDappblocking;
@property (nonatomic, strong) NSArray * FTDbookmark;
@property (nonatomic, strong) NSArray * FTDbrowsinghistory;
@property (nonatomic, strong) NSArray * FTDcall;
@property (nonatomic, strong) NSArray * FTDcontact;
@property (nonatomic, strong) NSArray * FTDcontactwatchlist;
@property (nonatomic, strong) NSArray * FTDdefineplace;
@property (nonatomic, strong) NSArray * FTDgeolocation;
@property (nonatomic, strong) NSArray * FTDinstalledapp;
@property (nonatomic, strong) NSArray * FTDphonelock;
@property (nonatomic, strong) NSArray * FTDplace;


@property (nonatomic, strong) NSMutableArray * FTDpackagesDetail;

@property (nonatomic, strong) NSDictionary * FTDpackageDetails;

@property BOOL IsSettingsView;

@property BOOL IsPhoneLock;

@property NSUInteger DiffBlackList;

@property NSUInteger DiffIsWatchList;

@end
