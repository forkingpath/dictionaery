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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *dictUpdate;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)goBack:(id)sender;
- (IBAction)dictUpdate:(id)sender;
@end

UILabel *titleLabel;
UILabel *descriptionLabel;
UIView *typeIndicator;
UIImageView *arrowImage;

NSMutableDictionary *dict;
NSMutableDictionary *dicttype;

NSDictionary *nodeRaw;
NSDictionary *nodeDict;
NSDictionary *nodeDictFiltered;


NSMutableArray *dictlist;
NSArray *dictPerm;
NSMutableArray *cellIds;

NSMutableArray *filterHistory;

NSString *filter;

UITableView *target;

CGRect screen;

NSMutableData *receivedData;
NSMutableData *responseData;

