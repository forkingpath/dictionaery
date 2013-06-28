//
//  xxiivvViewController.h
//  dictionaery
//
//  Created by Devine Lu Linvega on 2013-06-28.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xxiivvViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
- (IBAction)filterReset:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterReset;


@end

NSMutableDictionary *dict;

NSMutableArray *dictlist;
NSArray *dictPerm;
NSMutableArray *cellIds;
NSMutableArray *node;
NSMutableArray *dictFiltered;

NSString *filter;

UITableView *target;

CGRect screen;

NSMutableData *receivedData;
NSMutableData *responseData;