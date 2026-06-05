//
//  PlacesViewController.h
//  FamilyTime
//
//  Created by Sora Code on 11/25/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPlacesViewController.h"
#import "DataModel.h"
#import "PlaceCell.h"
#import "BaseViewController.h"

@class SwiftAddPlacesViewController;

@interface PlacesViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *imgView;
    UILabel *contentLbl;
    UILabel *oopsLbl;

    UIBarButtonItem * add;
    BOOL isCountBased;
    NSInteger countLimit;
}

@property (nonatomic,strong) SwiftAddPlacesViewController *addPlacesCont;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
- (IBAction)addPlace:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *lblText;


@end
