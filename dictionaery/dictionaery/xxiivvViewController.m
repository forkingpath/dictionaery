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
    [self registerForKeyboardNotifications];
	[self dictionaeryStart];
	[self templateStart];
	[self templateUpdate];
	[self dictionaeryUpdate];
    [self loadDictionaery:nil];
    [self filterReset:nil];
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
	
	
	node[[node count]]	= [NSArray arrayWithObjects: @"support1", @"Application Support", @"ressource", @"", @"", nil];
	node[[node count]]	= [NSArray arrayWithObjects: @"support2", @"Traumae Documentation", @"ressource", @"", @"", nil];
	node[[node count]]	= [NSArray arrayWithObjects: @"support3", @"Traumae Lessons", @"ressource", @"", @"", nil];
    node[[node count]]	= [NSArray arrayWithObjects: @"support4", @"Update Dictionaery", @"ressource", @"", @"", nil];
	
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
	[self loadDictionaery:response];
}




- (void) templateStart
{
	screen = [[UIScreen mainScreen] bounds];
	[[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]];
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
    if(![filter isEqual: @""])
        return dictlist.count;
	return [dict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Draw cells
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
	if(cell == nil){ cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MainCell"]; }
	
	// Change cell color
	
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
	cell.textLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0];

	cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
	cell.detailTextLabel.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0];
	cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
	
	cell.backgroundView.backgroundColor = [UIColor redColor];
	
	UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
	bgView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
	cell.backgroundView = bgView;
	
	UIView *bgColorView = [[UIView alloc] init];
	[bgColorView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.2]];
	[cell setSelectedBackgroundView:bgColorView];
	cell.textLabel.highlightedTextColor = [UIColor blackColor];
	
	cell.textLabel.text = [dictlist[indexPath.row] uppercaseString];
	cell.detailTextLabel.text = [dict[dictlist[indexPath.row]] capitalizedString];
	cell = [self templateCell:cell:indexPath];
	
	
	if( [dictlist[indexPath.row] isEqual:filter] && ![dictlist[indexPath.row] isEqual:@"support"] ){
		bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
		cell.frame = CGRectMake(0, 0, screen.size.width, 300);
        if([self isTraumae:dictlist[indexPath.row]]) { //Display text as traumae if it is traumae
            cell.textLabel.font = [UIFont fontWithName:@"Septambres Fune" size:40];
            cell.textLabel.text = [self toQwerty:[dictlist[indexPath.row] lowercaseString]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@",[dictlist[indexPath.row] lowercaseString],[dict[dictlist[indexPath.row]] capitalizedString]];
        }
        else { //Display text as roman if it is not traumae
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
            cell.textLabel.text = [dictlist[indexPath.row] lowercaseString];
            cell.detailTextLabel.text=@"";
        }
		
		
	}
	if( [dicttype[indexPath.row] isEqual:@"core"] ){
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	}
	if( [dicttype[indexPath.row] isEqual:@"end"] ){
		cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
		cell.detailTextLabel.alpha = 0;
	}
	if( [dicttype[indexPath.row] isEqual:@"ressource"] ){
		cell.textLabel.text = dict[dictlist[indexPath.row]];
		cell.detailTextLabel.text = @"";
	}
	
	if( [dictlist[indexPath.row] isEqual:@"support"] ){
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
		cell.frame = CGRectMake(0, 0, screen.size.width, 300);
		cell.textLabel.text = @"Support";
		cell.detailTextLabel.text = @"Visit the application support";		
	}
	
	
	NSLog(@"TYPE %@",dicttype[indexPath.row]);
	
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
        return nil;
    }
    return indexPath;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    
	if( [dictlist[indexPath.row] isEqual:@"support1"] ){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wiki.xxiivv.com/Dictionaery+support"]];
		return;
	}
	if( [dictlist[indexPath.row] isEqual:@"support2"] ){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wiki.xxiivv.com/Traumae"]];
		return;
	}
	if( [dictlist[indexPath.row] isEqual:@"support3"] ){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wiki.xxiivv.com/Traumae+lessons"]];
		return;
	}
    if( [dictlist[indexPath.row] isEqual:@"support4"] ){
        [self filterReset:nil];
		[self dictionaeryUpdate];
		return;
	}
	
	
	
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
	[self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void) dictionaeryFilter
{
	dict = [[NSMutableDictionary alloc] init];
	dictlist = [[NSMutableArray alloc] init];
	dicttype = [[NSMutableArray alloc] init];
	
	int i = 0;
	
	// Search Query
	
	if( ![filter isEqual: @""] && ![filter isEqual: @"support"]){
        //[dict setObject:@"" forKey: @"filter" ];
		dictlist[0] = filter;
		dicttype[0] = @"Search Query";
		i += 1;
	}
	
	// Direct Children
	
	for ( NSArray *test in node ){
		NSString *traumaeWord = test[0];
        traumaeWord = [[traumaeWord lowercaseString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSString *second = [[filter lowercaseString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		
		// If is not child
		if( ![filter isEqual: @""] && [traumaeWord rangeOfString:second].location == NSNotFound ) {
			continue;
		}
		// If is not root
		else if( [filter isEqual:@""] && [test[0] length] > 2 ){
			continue;
		}
		// If is not direct child
		else if( ![filter isEqual:@""] && [test[0] length] > ( [filter length]+ 2) ){
			continue;
		}
		// If doesn't start with filter
		else if( ![filter isEqual: @""] && ![[traumaeWord substringWithRange:NSMakeRange(0, [filter length])] isEqual:filter] ){
			NSLog(@"%@", [traumaeWord substringWithRange:NSMakeRange(0, [filter length])] );
			continue;
		}
		// If is not filter
		else if( [filter isEqual:traumaeWord] ){
			[dict setObject:test[1] forKey: test[0] ];
			continue;
		}
		
		[dict setObject:test[1] forKey: test[0] ];
		dictlist[i] = test[0];
		dicttype[i] = test[2];
		i += 1;
	}
	if(filter.length>2) {
        for ( NSArray *test in node ){
            NSString *englishWord = test[1];
            englishWord = [[englishWord lowercaseString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *second = [[filter lowercaseString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            // If is not child
            
            if([dict objectForKey:test[0]] !=NULL)
                continue;
            
            if( ![filter isEqual: @""] && [englishWord rangeOfString:second].location == NSNotFound ) {
                continue;
            }
            // If is not filter
            /*else if( [filter isEqual:englishWord] ){
                [dict setObject:test[1] forKey: test[0] ];
                continue;
            }*/
            
            [dict setObject:test[1] forKey: test[0] ];
            dictlist[i] = test[0];
            dicttype[i] = test[2];
            i += 1;
        }
    }
    
	// First
	if( ![filter isEqual: @""] && ![filter isEqual: @"support"] ){
		dictlist[0] = filter;
		dicttype[0] = @"Search Query";
		i += 1;
	}
	
	// Last
	if( ![filter isEqual: @""] && i == 1 ){
		[dict setObject:@"Start a new search query" forKey: @"End" ];
		dictlist[i] = @"End of tree";
		dicttype[i] = @"end";
	}
	
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 1)
    {
		[self filterReset:nil];
        
    }
	if(item.tag == 2)
    {
		filter = @"support";
		[self dictLoad];
    }
}


- (UITableViewCell *) templateCell :(UITableViewCell*) cell :(NSIndexPath*)indexPath
{
	CGRect labelFrame = CGRectMake( screen.size.width-110, -1, 100, 30 );
	UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
	if( ![[NSString stringWithFormat:@"%@",dicttype[indexPath.row]] isEqual:@"ressource"] ){
		[label setText: [NSString stringWithFormat:@"%@",dicttype[indexPath.row]] ];
	}
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
    self.searchBar.text = @"";
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]]; //sets the tab bar to the first item
}
- (IBAction)dictUpdate:(id)sender {
	self.dictUpdate.enabled = NO;
	[self dictionaeryUpdate];
	
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateEnable) userInfo:nil repeats:NO];
}


- (NSString*) toQwerty :(NSString*)traumae
{
	NSString *fixed = traumae;
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xi" withString:@"W"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"di" withString:@"w"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"bi" withString:@"t"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xa" withString:@"S"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"da" withString:@"s"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ba" withString:@"g"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xo" withString:@"X"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"do" withString:@"x"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"bo" withString:@"b"];
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ki" withString:@"E"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ti" withString:@"e"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"pi" withString:@"y"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ka" withString:@"D"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ta" withString:@"d"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"pa" withString:@"h"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ko" withString:@"C"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"to" withString:@"c"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"po" withString:@"n"];
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"si" withString:@"Q"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"li" withString:@"q"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"vi" withString:@"r"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"sa" withString:@"A"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"la" withString:@"a"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"va" withString:@"f"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"so" withString:@"Z"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"lo" withString:@"z"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"vo" withString:@"v"];

	return fixed;
	
}
//Returns true if the text is pure traumae, false if not
- (BOOL) isTraumae :(NSString*)traumae
{
	NSString *fixed = [[traumae lowercaseString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(fixed.length<2)
        return true;
    if(fixed.length%2==1)
    {
        fixed = [fixed substringToIndex:fixed.length-1];
    }
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xi" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"di" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"bi" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xa" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"da" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ba" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xo" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"do" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"bo" withString:@""];
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ki" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ti" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"pi" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ka" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ta" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"pa" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ko" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"to" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"po" withString:@""];
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"si" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"li" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"vi" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"sa" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"la" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"va" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"so" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"lo" withString:@""];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"vo" withString:@""];
    
	if(fixed.length>0)
        return false;
    return true;
	
}







- (void) updateEnable
{
	self.dictUpdate.enabled = YES;
}


- (void)fadeIn:(UIView*)viewToFadeIn d:(NSTimeInterval)delay t:(NSTimeInterval)duration
{
	[UIView beginAnimations: @"Fade In" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelay:delay];
	viewToFadeIn.alpha = 1;
	[UIView commitAnimations];
}

- (void)fadeOut:(UIView*)viewToFadeIn d:(NSTimeInterval)delay t:(NSTimeInterval)duration
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelay:delay];
	viewToFadeIn.alpha = 0;
	[UIView commitAnimations];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-44, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}
//Hide keyboard if they hit the search button
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}
//Hide keyboard if they cancel search
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self filterReset:nil];
}

-(void)loadDictionaery:(NSString*)newData {
    if(newData) {
        NSError *error;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [newData dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
        if(!error) {
            [newData writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"newDict.json"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            [self dictionaerySequence:JSON];
            return;
        }
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"newDict.json"] ]) {
        NSError *error;
        NSString *loadedData = [NSString stringWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"newDict.json"] encoding:NSUTF8StringEncoding error:&error];
        if(!error) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [loadedData dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
            if(!error) {
                [self dictionaerySequence:JSON];
                return;
            }
        }
    }
    NSError *error;
    NSString *loadedData = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dict" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    if(!error) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [loadedData dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
        if(!error) {
            [self dictionaerySequence:JSON];
            return;
        }
    }
    
    NSLog(@"can't load!");
}

@end


