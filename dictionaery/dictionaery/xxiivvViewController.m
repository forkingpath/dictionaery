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
	NSLog(@"+ Start   | Init");
    [self registerForKeyboardNotifications];
	
	[self templateStart];
	[self templateUpdate];
	
	[self dictionaeryStart];
	[self dictionaeryUpdate];
    [self dictionaeryLoad:nil];
	
    [self filterSet:nil];
	NSLog(@"+ Start   | Started");
}

// ------------------------
#  pragma mark Template
// ------------------------

- (void) templateStart
{
}

- (void) templateUpdate
{
	if( [filter isEqual: @""] ){
		self.navigationBarTitle.title = @"Dictionaery";
	}
	else{
		self.navigationBarTitle.title =  [[self cleanString:filter] capitalizedString];
	}
}

// ------------------------
#  pragma mark Dictionaery
// ------------------------

- (void) dictionaeryStart
{
	NSLog(@"+ Dict    | Start");
		
}

- (void) dictionaeryUpdate
{
	NSLog(@"+ Dict    | Update");
	self.navigationBarTitle.title = @"Downloading..";
	[self apiPull];
}

- (void) dictionaerySequence :(NSDictionary*)sequence
{
	NSLog(@"+ Dict    | Sequence");
	nodeRaw = sequence;
	[self dictionaeryTypesColoursCreate:sequence];
	[self dictionaerySequenceFilter];
	[self filterSet:nil];
}

-(void)dictionaeryTypesColoursCreate :(NSDictionary*)sequence
{
	
	NSArray *dictColours = [NSArray arrayWithObjects: @"value1", @"key1", @"value2", @"key2",@"value1", @"key1", @"value2", @"key2", @"key1", @"value2", @"key2",@"value1", @"key1", @"value2", @"key2", nil];
	
	NSMutableDictionary *dictTypesTemp = [[NSMutableDictionary alloc]init];
	
	for (NSString *key in sequence) {
		id value = [sequence objectForKey:key];
		dictTypesTemp[value[@"type"]] = value[@"type"];
	}
	
	NSArray *dictTypesStore = [dictTypesTemp allKeys];
	dicttype = [[NSMutableDictionary alloc]initWithCapacity:30];
	
	int count = 0;
	for (NSString *key in dictTypesStore) {
		dicttype[key] = dictColours[count];
		count += 1;
		if(count>[dictColours count]-1){
			break;
		}
	}

}

- (void) dictionaerySequenceFilter
{
	NSLog(@"+ Dict    | Filtering: %@",filter);
	nodeDict = [self dictionaerySequenceFilterLoop];
}

- (NSMutableDictionary*) dictionaerySequenceFilterLoop
{
	NSMutableDictionary *nodeTemp = [[NSMutableDictionary alloc]initWithCapacity:900];
	for (NSString* key in nodeRaw) {
		id value = [nodeRaw objectForKey:key];
		if( [NSString stringWithFormat:@"%@",value[@"traumae"]].length > filter.length-1 ){
			if( [filter isEqualToString:[value[@"traumae"] substringToIndex:filter.length]] ){
				[nodeTemp setObject:value forKey:value[@"traumae"]];
			}
		}
		if(!filter && [value[@"traumae"] length] == 2){
			[nodeTemp setObject:value forKey:value[@"traumae"]];
		}
		
	}
	return nodeTemp;
}


-(void)dictionaeryLoad:(NSString*)newData {
	NSLog(@"+ Dict    | Loading");
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
	NSLog(@"+ Dict    | Could not load");
}


// ------------------------
#  pragma mark API
// ------------------------

- (void)apiPull
{
	NSLog(@"+ API     | Pulling entire dict");
	NSURL *myURL = [NSURL URLWithString: @"http://api.xxiivv.com/?key=traumae" ];
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
	NSLog(@"+ API     | Found dictionaery");
	NSString *response = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
	[self dictionaeryLoad:response];
}



// ------------------------
#  pragma mark Table
// ------------------------


- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	target = tableView;
	NSLog(@"+ Table   | Item Count: %d",[nodeDict count]);
	return [nodeDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *traumaeWord = nodeDict[[[nodeDict allKeys] objectAtIndex:indexPath.row]];
	
	// Draw cells
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
	if(cell == nil){ cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MainCell"]; }
	
	// Change cell color
	
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
	
	cell.textLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:24];
	cell.textLabel.highlightedTextColor = [UIColor blackColor];

	cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
	cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",traumaeWord[@"english"]];
	
	cell.textLabel.text = traumaeWord[@"traumae"];
	
	// Details
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 24)];
	titleLabel.font = [UIFont fontWithName:@"Didot-Italic" size:24];
	titleLabel.textAlignment = UITextAlignmentRight;
	titleLabel.text = traumaeWord[@"adultspeak"];
	titleLabel.alpha = 0.5;
	if ([traumaeWord[@"adultspeak"] isEqualToString:traumaeWord[@"traumae"]]) {
		titleLabel.hidden = YES;
	}
	[cell addSubview:titleLabel];
	
	// Alternative meanings
	
	descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 34, 300, 20)];
	descriptionLabel.font = [UIFont systemFontOfSize:12.0];
	descriptionLabel.textAlignment = UITextAlignmentLeft;
	descriptionLabel.text = traumaeWord[@"type"];
	[cell addSubview:descriptionLabel];
	
	
	NSString *traumaeWordAlternatives = @"";
	
	for (NSString *alt in traumaeWord[@"alternatives"]) {
		if (![alt isEqualToString:cell.detailTextLabel.text]) {
			traumaeWordAlternatives = [NSString stringWithFormat:@"%@, %@",alt, traumaeWordAlternatives];
		}
	}
	if (traumaeWordAlternatives.length > 4) {
		traumaeWordAlternatives = [traumaeWordAlternatives substringToIndex:traumaeWordAlternatives.length-2];
	}
	
	
	descriptionLabel.text = traumaeWordAlternatives;
	
	typeIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 60)];
	if( [traumaeWord[@"type"] isEqual:@"expression"] ){
		typeIndicator.backgroundColor = [UIColor redColor];
		NSLog(@"TYPE COLOUR: %@",dicttype[traumaeWord[@"type"]]);
	}
	
	NSLog(@"%@",dicttype);
	
	[cell addSubview:typeIndicator];
	
	cell = [self templateCell:cell:traumaeWord];

	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( [dictlist[indexPath.row] isEqual:filter] ){
		return 100;
	}
    return 60;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
        return nil;
    }
    return indexPath;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	
	[self filterSet:nodeDict[[[nodeDict allKeys] objectAtIndex:indexPath.row]][@"traumae"]];
	
}

// ------------------------
#  pragma mark Filter
// ------------------------

-(void)filterSet:(NSString*)newFilter {
	
	filter = newFilter;
	
	if ([filter isEqualToString:@""]) {
		filter = nil;
	}
	
	NSLog(@"+ Filter  | Set: %@",filter);
	[self setupBackButton];
	[self setupNavigationBar];
	[self dictionaerySequenceFilter];
	[target reloadData];
	[self.tableView setContentOffset:CGPointZero animated:FALSE];
	
}

// ------------------------
#  pragma mark Search
// ------------------------

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	NSLog(@"!!!!! %@", searchText);
	filter = searchText;
	[self dictionaerySequenceFilter];
	[self filterSet:filter];
}




- (void) dictLoad
{
	NSLog(@"Filter: %@",filter);
	[self templateUpdate];
	[target reloadData];
	[self.tableView setContentOffset:CGPointZero animated:FALSE];
    [self setupBackButton];
}

- (UITableViewCell *) templateCell :(UITableViewCell*)cell :(NSDictionary*)cellData
{
	if([cellData[@"traumae"] isEqualToString:filter]){
		cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
	}
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dictUpdate:(id)sender {
	self.dictUpdate.enabled = NO;
	[self dictionaeryUpdate];
	
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateEnable) userInfo:nil repeats:NO];
}


- (NSString*) toQwerty :(NSString*)traumae
{
	NSString *fixed = traumae;
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xi" withString:@"w"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"di" withString:@"t"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"bi" withString:@"i"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xa" withString:@"s"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"da" withString:@"g"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ba" withString:@"k"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"xo" withString:@"x"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"do" withString:@"b"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"bo" withString:@","];
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ki" withString:@"q"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ti" withString:@"r"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"pi" withString:@"u"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ka" withString:@"a"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ta" withString:@"f"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"pa" withString:@"j"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"ko" withString:@"z"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"to" withString:@"v"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"po" withString:@"m"];
	
	fixed = [fixed stringByReplacingOccurrencesOfString:@"si" withString:@"e"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"li" withString:@"y"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"vi" withString:@"o"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"sa" withString:@"d"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"la" withString:@"h"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"va" withString:@"l"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"so" withString:@"c"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"lo" withString:@"n"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"vo" withString:@"."];

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

// ------------------------
#  pragma mark Animations
// ------------------------

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


// ------------------------
#  pragma mark Interactions
// ------------------------

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
    [self filterSet:filter];
    
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
	[self filterSet:nil];
    [self dictLoad];
	[self setupNavigationBar];
    [self.searchBar resignFirstResponder];
}



- (IBAction)goBack:(id)sender {
    [self.searchBar resignFirstResponder];
    
	if( filter.length > 1){
		filter = [filter substringToIndex:filter.length-2];
	}
	else{
		filter = nil;
	}
	[self filterSet:filter];
	
	
    [self dictLoad];
	[self setupNavigationBar];
}

-(void)setupBackButton {
    
//    NSString *lastFilter = nil;
//    if(filterHistory.count>0) {
//        lastFilter = [filterHistory objectAtIndex:filterHistory.count-1];
//        if([lastFilter isEqual:filter]) {
//            lastFilter=nil;
//            if(filterHistory.count>1)
//                lastFilter = [filterHistory objectAtIndex:filterHistory.count-2];
//        }
//    }
//    if(lastFilter && ![filter isEqual:@"support"]) {
//        [self.navigationBarTitle setLeftBarButtonItem:self.backButton animated:NO];
//        if([lastFilter isEqual:@""])
//            lastFilter=@"Back";
//        self.backButton.title=[[self cleanString:lastFilter] capitalizedString];
//        
//        [self.backButton setEnabled:true];
//    }
//    else {
//        [self.navigationBarTitle setLeftBarButtonItem:nil animated:NO];
//        [self.backButton setEnabled:false];
//    }
}

-(void)setupNavigationBar
{
	if(filter){
		self.navigationBarTitle.title = filter;
		self.backButton.enabled = YES;
	}
	else{
		self.navigationBarTitle.title = @"Dictionaery";
		self.backButton.enabled = NO;
	}
}

-(NSString*)cleanString:(NSString*)input {
    return [[[input lowercaseString] stringByReplacingOccurrencesOfString:@"|" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return input;
}

@end


