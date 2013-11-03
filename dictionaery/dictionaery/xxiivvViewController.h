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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterReset;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *dictUpdate;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)goBack:(id)sender;
- (IBAction)dictUpdate:(id)sender;
- (IBAction)filterReset:(id)sender;

@end

NSMutableDictionary *dict;
NSMutableArray *dicttype;
NSMutableArray *dictlist;
NSArray *dictPerm;
NSMutableArray *cellIds;
NSDictionary *nodeRaw;
NSDictionary *nodeDict;
NSDictionary *nodeDictFiltered;

NSMutableArray *filterHistory;

NSString *filter;

UITableView *target;

CGRect screen;

NSMutableData *receivedData;
NSMutableData *responseData;