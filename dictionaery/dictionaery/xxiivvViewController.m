//
//  xxiivvViewController.m
//  dictionaery
//
//  Created by Devine Lu Linvega on 2013-06-28.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "xxiivvViewController.h"

@interface xxiivvViewController ()

@end

@implementation xxiivvViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self start];
}

- (void) start
{
	[self dictionaeryStart];

	self.navigationBarTitle.title = @"Traumae Dict";

}


- (void) dictionaeryStart
{
	// Node is API return, array of all translations
	
	node = [NSMutableArray arrayWithObjects:@"",nil];
	
	int myCount = 0;
	while ( myCount < 90 )
	{
		myCount++;
		node[myCount] = [NSArray arrayWithObjects: @"0", @"0", @"0", @"0", @"silence", nil];
	}
	
	node[0]		= [NSArray arrayWithObjects: @"xi", @"Notes", @"psychology", @"Something else", @"3rd", nil];
	node[1]		= [NSArray arrayWithObjects: @"di", @"Notes", @"physionomy", @"Something else", @"3rd", nil];
	node[2]		= [NSArray arrayWithObjects: @"xidi", @"Notes", @"something else", @"Something else", @"3rd", nil];
	
	// Populate dictionary with all translations
	
	[self dictionaeryFilter];
	
	NSLog(@"%@",dict);
//
//	[dict setObject:@"Psychology" forKey:@"xi"];
//	
//	NSLog(@"%@",dict);
	
	// Get
	// NSString *valueStr = [dict objectForKey:@"Key2"];
	
	// Add
	// NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Value1", @"Key1", @"Value2", @"Key2", nil];
	
	// Create the storage for the cell names
	
	
	
	myCount = 0;
	cellIds = [NSMutableArray arrayWithObjects:@"",nil];
	while ( myCount < 30 )
	{
		myCount++;
		cellIds[myCount] = @"unnamed";
	}	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [dict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	// Draw cells
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
	if(cell == nil){ cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MainCell"]; }
	
	cell.textLabel.text = dictlist[indexPath.row];
	cell.detailTextLabel.text = dict[dictlist[indexPath.row]];
	cell = [self templateCell:cell:indexPath];
	
	// Store cell id
	
//	cellIds = [NSMutableArray arrayWithObjects:@"",nil];
//	
//	int someTest = indexPath.row;
	cellIds[indexPath.row] = dictlist[indexPath.row];
	
	
	return cell;
	
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	
	filter = cellIds[indexPath.row];
	target = tableView;
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(dictLoad) userInfo:nil repeats:NO];
	
}

- (void) dictLoad
{
	NSLog(@"Filter: %@",filter);
	[self dictionaeryFilter];
	self.navigationBarTitle.title = filter;
	[target reloadData];
}

- (void) dictionaeryFilter
{
	dict = [[NSMutableDictionary alloc] init];
	dictlist = [[NSMutableArray alloc] init];
	
	int i = 0;
	for ( NSArray *test in node ){
		if( filter && test[0] != filter ){ continue; }
		[dict setObject:test[2] forKey: test[0] ];
		dictlist[i] = test[0];
		i += 1;
	}
	
	NSLog(@"List %@",dict);
	
}




- (UITableViewCell *) templateCell :(UITableViewCell*) cell :(NSIndexPath*)indexPath
{
	UIButton*btnclkd= [UIButton buttonWithType:UIButtonTypeCustom];
	btnclkd.frame=CGRectMake(200, 5, 70, 25);
	btnclkd.frame= cell.frame;
	btnclkd.backgroundColor = [UIColor redColor];
	[btnclkd setTag:indexPath.row];
	[btnclkd setTitle:[NSString stringWithFormat:@"row: %@",dictlist[indexPath.row]] forState:UIControlStateNormal] ;
	[btnclkd addTarget:self action:@selector(btnok:)forControlEvents:UIControlEventTouchUpInside];
	// [cell.contentView addSubview:btnclkd];
	
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















//
//	dictlist = [NSArray arrayWithObjects:
//				@"xi", @"di", @"bi",
//				@"ki", @"ti", @"pi",
//				@"si", @"li", @"vi",
//
//				@"xa", @"da", @"ba",
//				@"ka", @"ta", @"pa",
//				@"sa", @"la", @"va",
//
//				@"xo", @"do", @"bo",
//				@"ko", @"to", @"po",
//				@"so", @"lo", @"vo",
//				nil];
//

//