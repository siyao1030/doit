//
//  FactorRankingViewController.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/20/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import "FactorRankingViewController.h"

@interface FactorRankingViewController ()

@end

@implementation FactorRankingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDecision:(Decision *)decision
{
    
    NSLog(@"this decision is at stage: %d", decision.stage);
    self.decision = decision;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"finalScore"
                                                                   ascending:NO];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    
    self.A = [((Choice *)self.decision.choices[0]).factors mutableCopy];
    self.B = [((Choice *)self.decision.choices[1]).factors mutableCopy];
    self.factors = [self.A mutableCopy];
    [self.factors addObjectsFromArray:self.B];
    
    [self.A sortUsingDescriptors:sortDescriptors];
    [self.B sortUsingDescriptors:sortDescriptors];
    [self.factors sortUsingDescriptors:sortDescriptors];
    

    return self;
}

-(UITableView *)makeTableView
{
    CGFloat x = 0;
    CGFloat width = 320;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    NSLog(@"nav bar %f", navBarHeight);
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat y = 0;
    CGFloat height = self.view.frame.size.height-statusBarHeight-tabBarHeight-navBarHeight-44;
    
    CGRect tableFrame = CGRectMake(x, y, width, height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 60;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = bgColor;
    tableView.allowsSelection = NO;
    
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    return tableView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return ([self.factors count]);
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    FactorRankingCellView * view = [[FactorRankingCellView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    Factor * factor = [self.factors objectAtIndex:indexPath.row];
    if ([self.A containsObject:factor])
        [view setUpWithFactor:[self.factors objectAtIndex:indexPath.row] andTopFactor:[self.factors objectAtIndex:0] andIsA:YES];
    else
        [view setUpWithFactor:[self.factors objectAtIndex:indexPath.row] andTopFactor:[self.factors objectAtIndex:0] andIsA:NO];


    [view setBackgroundColor:bgColor];
    [cell.contentView addSubview:view];
    
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return YES;
 }
 
 */
/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 if (self.choiceATableView==tableView)
 [self.choiceAfactors removeObjectAtIndex:indexPath.row];
 if (self.choiceBTableView==tableView)
 [self.choiceBfactors removeObjectAtIndex:indexPath.row];
 
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 
 }
 
 */
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [self makeTableView];
    
    
    // register the type of view to create for a table cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
