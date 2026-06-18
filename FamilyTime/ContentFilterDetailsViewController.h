//
//  ContentFilterDetailsViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 01/06/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ContentFilterDetailsType {
    ContentFilterDetailsTypeMovies = 0,
    ContentFilterDetailsTypeTVShows,
    ContentFilterDetailsTypeApps
} ContentFilterDetailsType;


@interface ContentFilterDetailsViewController : UITableViewController
@property (nonatomic, assign) ContentFilterDetailsType detailsType;
@end
