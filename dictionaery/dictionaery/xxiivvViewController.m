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
	
	
	node[0]		= [NSArray arrayWithObjects: @"xi", @"Notes", @"psychology", @"Something else", @"3rd", nil];
	node[1]		= [NSArray arrayWithObjects: @"di", @"Notes", @"physionomy", @"Something else", @"3rd", nil];
	node[2]		= [NSArray arrayWithObjects: @"xidi", @"Notes", @"something else", @"Something else", @"3rd", nil];
	
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

	NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"http://api.xxiivv.com/?key=traumae&cmd=read"]];
	NSError *error;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	NSArray *response = [json objectForKey:@"resultMessage"];
	NSLog(@"response %@",response);

	
	[self apiPull];
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
	NSLog(@"%@",JSON);	
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
	
	if( filter ){
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
		cell.textLabel.font = [UIFont systemFontOfSize:14.0];
		cell.textLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0];
		cell.textLabel.text = [cell.textLabel.text uppercaseString];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
		cell.detailTextLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0];
		cell.backgroundView.backgroundColor = [UIColor redColor];
		UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
		bgView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
		cell.backgroundView = bgView;
	}
	
	
	cell.textLabel.text = dictlist[indexPath.row];
	cell.detailTextLabel.text = dict[dictlist[indexPath.row]];
	cell = [self templateCell:cell:indexPath];
	
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
		
		if ( ![filter isEqual: @""] && [first rangeOfString:second].location == NSNotFound ) {
			continue;
		}
		
		[dict setObject:test[2] forKey: test[0] ];
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