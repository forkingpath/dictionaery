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
	[self templateStart];
	[self templateUpdate];
	[self dictionaeryUpdate];
	
	self.navigationBarTitle.title = @"Traumae Dict";

}


- (void) dictionaeryStart
{
	filter = @"";
	
	node = [NSMutableArray arrayWithObjects:@"",nil];
	
	int myCount = 0;
	while ( myCount < 90 )
	{
		myCount++;
		node[myCount] = [NSArray arrayWithObjects: @"0", @"0", @"0", @"0", @"silence", nil];
	}
	
	node[0]		= [NSArray arrayWithObjects: @"Welcome", @"Notes", @"Beta", @"Something else", @"3rd", nil];
	
	
	
	
	[self dictionaeryFilter];
	
	myCount = 0;
	cellIds = [NSMutableArray arrayWithObjects:@"",nil];
	while ( myCount < 30 )
	{
		myCount++;
		cellIds[myCount] = @"unnamed";
	}	
		
}





- (void) dictionaeryUpdate
{	
	[self apiPull];
}

- (void) dictionaerySequence :(NSDictionary*)sequence
{
	
	NSLog(@"%@",sequence);
	
	int i = 0;
	for (NSString *test in sequence) {
		i += 1;
		NSArray *value = [sequence objectForKey:test];
		NSLog(@"%@",value[0]);
		node[i] = [NSArray arrayWithObjects: value[0], value[1], value[2], value[3], value[4], nil];
	}
	
	[self dictLoad];
	
}





// =========================
// @Application API
// =========================

- (void)apiPull
{
	NSURL *myURL = [NSURL URLWithString: @"http://api.xxiivv.com/?key=traumae&cmd=read" ];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *response = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
	NSError *error;
	NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
	
	[self dictionaerySequence:JSON];
}




- (void) templateStart
{
	
}

- (void) templateUpdate
{
	if( [filter isEqual: @""] ){
		self.navigationBarTitle.title = @"Dictionaery";
	}
	else{
		self.navigationBarTitle.title = filter;
	}
	
	if( ![filter isEqual:@""] ){
		self.filterReset.enabled = YES;
	}
	else{
		self.filterReset.enabled = NO;
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
	
	if( indexPath.row == 0 ){
		
	}
	// Change cell color
	
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
	cell.textLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0];

	cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
	cell.detailTextLabel.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0];
	cell.backgroundView.backgroundColor = [UIColor redColor];
	
	UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
	bgView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
	cell.backgroundView = bgView;
	
	UIView *bgColorView = [[UIView alloc] init];
	[bgColorView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
	[cell setSelectedBackgroundView:bgColorView];
	
	
	cell.textLabel.text = [dictlist[indexPath.row] uppercaseString];
	cell.detailTextLabel.text = [dict[dictlist[indexPath.row]] capitalizedString];
	cell = [self templateCell:cell:indexPath];
	
	
	if( [dictlist[indexPath.row] isEqual:filter] ){
		bgView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
		cell.textLabel.textColor = [UIColor whiteColor];
	}
	
	
	cellIds[indexPath.row] = dictlist[indexPath.row];
	
	return cell;
	
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	
	// Set Filter
	filter = cellIds[indexPath.row];

	target = tableView;
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(dictLoad) userInfo:nil repeats:NO];
	
}

- (void) dictLoad
{
	NSLog(@"Filter: %@",filter);
	[self templateUpdate];
	[self dictionaeryFilter];
	[target reloadData];
}

- (void) dictionaeryFilter
{
	dict = [[NSMutableDictionary alloc] init];
	dictlist = [[NSMutableArray alloc] init];
	
	int i = 0;
	for ( NSArray *test in node ){
		NSString *first = test[0];
		NSString *second = filter;
		
		// If is not child
		if( ![filter isEqual: @""] && [first rangeOfString:second].location == NSNotFound ) {
			continue;
		}
		// If is not root
		if( [filter isEqual:@""] && [test[0] length] > 2 ){
			continue;
		}
		
		[dict setObject:test[1] forKey: test[0] ];
		dictlist[i] = test[0];
		i += 1;
	}
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

- (IBAction)filterReset:(id)sender {
	NSLog(@"reset");
	filter = @"";
	[self dictLoad];
	[target reloadData];
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