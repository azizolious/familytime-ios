//
//  GMTTimezone.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 17/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMTTimezone : NSObject
@property (nonatomic, assign) NSInteger gmtDiff;
@property (nonatomic, strong) NSString *strRep;
@property (nonatomic, strong) NSString *name;
@end
