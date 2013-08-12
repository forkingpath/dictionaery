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
- (IBAction)dictUpdate:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *dictUpdate;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)goBack:(id)sender;

@end

NSMutableDictionary *dict;
NSMutableArray *dicttype;
NSMutableArray *dictlist;
NSArray *dictPerm;
NSMutableArray *cellIds;
NSMutableArray *node;
NSMutableArray *dictFiltered;

NSMutableArray *filterHistory;

NSString *filter;

UITableView *target;

CGRect screen;

NSMutableData *receivedData;
NSMutableData *responseData;