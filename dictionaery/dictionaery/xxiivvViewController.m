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
}


- (void) dictionaeryStart
{
	filter = @"";
	
	node = [NSMutableArray arrayWithObjects:@"",nil];
	
	int myCount = 0;
	while ( myCount < 90 )
	{
		myCount++;
		node[myCount] = [NSArray arrayWithObjects: @"0", @"Connecting..", @"The dictionary needs to be downloaded", @"0", @"silence", nil];
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
	self.navigationBarTitle.title = @"Downloading..";
	[self apiPull];
}

- (void) dictionaerySequence :(NSDictionary*)sequence
{	
	int i = 0;
	for (NSString *test in sequence) {
		i += 1;
		NSArray *value = [sequence objectForKey:test];
		node[i] = [NSArray arrayWithObjects: value[0], value[1], value[2], value[3], value[4], nil];
	}
	
	filter = @"";
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(dictLoad) userInfo:nil repeats:NO];
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
	screen = [[UIScreen mainScreen] bounds];
}

- (void) templateUpdate
{
	if( [filter isEqual: @""] ){
		self.navigationBarTitle.title = @"Dictionaery";
	}
	else{
		self.navigationBarTitle.title = [filter capitalizedString];
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
	target = tableView;
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
	[bgColorView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
	[cell setSelectedBackgroundView:bgColorView];
	cell.textLabel.highlightedTextColor = [UIColor blackColor];
	
	
	
	cell.textLabel.text = [dictlist[indexPath.row] uppercaseString];
	cell.detailTextLabel.text = [dict[dictlist[indexPath.row]] capitalizedString];
	cell = [self templateCell:cell:indexPath];
	
	
	if( [dictlist[indexPath.row] isEqual:filter] ){
		bgView.backgroundColor = [UIColor colorWithRed:0.44 green:0.98 blue:0.76 alpha:1];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
		cell.frame = CGRectMake(0, 0, screen.size.width, 300);
	}
	
	
	cellIds[indexPath.row] = dictlist[indexPath.row];
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( [dictlist[indexPath.row] isEqual:filter] ){
		return 100;
	}
    return 48;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	
	
	[self.searchBar resignFirstResponder];
	
	// Set Filter
	filter = cellIds[indexPath.row];
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(dictLoad) userInfo:nil repeats:NO];
	
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	filter = searchText;
	[self dictLoad];
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
		
		// If is not direct child
		if( ![filter isEqual:@""] && [test[0] length] > ( [filter length]+ 2) ){
			continue;
		}
		
		[dict setObject:test[1] forKey: test[0] ];
		dictlist[i] = test[0];
		i += 1;
	}
}




- (UITableViewCell *) templateCell :(UITableViewCell*) cell :(NSIndexPath*)indexPath
{
	CGRect labelFrame = CGRectMake( screen.size.width-110, -1, 100, 30 );
	UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
	[label setText: [NSString stringWithFormat:@"%ld",(long)indexPath.row+1] ];
	[label setTextColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	[label setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0]];
	[label setTextAlignment:NSTextAlignmentRight];
	[label setFont:	[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[cell.contentView addSubview:label];
	
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)filterReset:(id)sender {
	[self.searchBar resignFirstResponder];
	NSLog(@"reset");
	filter = @"";
	[self dictLoad];
	[target reloadData];
}
- (IBAction)dictUpdate:(id)sender {
	self.dictUpdate.enabled = NO;
	[self dictionaeryUpdate];
	
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateEnable) userInfo:nil repeats:NO];
}


- (void) updateEnable
{
	self.dictUpdate.enabled = YES;
}

@end


