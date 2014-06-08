//
//  DecisionTableViewController.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "DecisionTableViewController.h"

@interface DecisionTableViewController ()

@end

@implementation DecisionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = bgColor;
        self.decisions = [Database fetchAllItems];
        
        // register the type of view to create for a table cell
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        self.tableView.rowHeight = 100;
        

    }
    return self;
}

- (void)reload
{
    self.decisions = [Database fetchAllItems];
    [self.tableView reloadData];
}

-(void)addDecision:(Decision *)decision
{
    
    if (decision != nil)
    {
        // haven't been saved before
        if (decision.rowid == -1)
        {
            int rowid = [Database saveItemWithData:decision];
            decision.rowid = rowid;
        }
        else
        {
            [Database replaceItemWithData:decision atRow:decision.rowid];
        }
        
        // Decision table view reload
        [self reload];
    }
}

-(void)addButtonPressed
{
    
    CreateDecisionViewController * createView = [[CreateDecisionViewController alloc]initWithNibName:@"CreateDecisionViewController" bundle:nil];
    [createView setup];
    createView.target = self;
    createView.action = @selector(reload);
    [self.navigationController pushViewController:createView animated:YES];
    
    //[self.createDecisionView resetFields];
    //[self.navigationController pushViewController:self.createDecisionView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = titleColor; // change this color
    self.navigationItem.titleView = label;
    
    [label setText: @"Decisions"];
    [label sizeToFit];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    addButton.tintColor = titleColor;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObject:addButton]];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.decisions count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //is this needed?
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Decision *temp = [self.decisions objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:temp.title];
    [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
    [[cell textLabel] setFont:[UIFont fontWithName: @"HelveticaNeue-CondensedBold"  size: 25]];
    //[cell setFrame:CGRectMake(0, 0, self.view.frame.size.width,100)];
    [cell setBackgroundColor:bgColor];
    
    UIImage * cellImage = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d.png",temp.stage]];
    [[cell imageView] setImage:cellImage];
    //[[cell imageView] setFrame:CGRectMake(0, 0, cellImage.size.width, cellImage.size.height)];
    return cell;
    }

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // kind of hacky -> actual rowid in db is # of items - indexpath.row because they table is in the opposite order of db
        //[Database deleteItem:self.decisions.count-indexPath.row-1];
        [Database deleteItem:[[self.decisions objectAtIndex:indexPath.row] rowid]];
        self.decisions = [Database fetchAllItems];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Decision *temp = [self.decisions objectAtIndex:indexPath.row];
    CreateDecisionViewController * createView = [[CreateDecisionViewController alloc]initWithNibName:@"CreateDecisionViewController" bundle:nil];
    [createView setup];
    [createView setUpWithDecision:temp];
    createView.target = self;
    createView.action = @selector(reload);
    
    EnterProsConsViewController * prosConsView;
    ComparisonViewController * compareView;
    ResultViewController * resultView;
    
    
    if (temp.stage == CreateStage)
    {
        [self.navigationController pushViewController:createView animated:YES];
    }
    else if (temp.stage == ProsConsStage)
    {
        
        [self.navigationController pushViewController:createView animated:NO];
        
        prosConsView = [[EnterProsConsViewController alloc]init];
        [prosConsView setUpWithDecision:temp];
        
        [self.navigationController pushViewController:prosConsView animated:YES];
    }
    else if (temp.stage == ComparisonStage)
    {
        
        [self.navigationController pushViewController:createView animated:NO];
        
        prosConsView = [[EnterProsConsViewController alloc]init];
        [prosConsView setUpWithDecision:temp];
        
        [self.navigationController pushViewController:prosConsView animated:NO];
        
        compareView = [[ComparisonViewController alloc]initWithDecision:temp];
        [self.navigationController pushViewController:compareView animated:YES];
    }
    else if (temp.stage == ResultStage)
    {
    
        [self.navigationController pushViewController:createView animated:NO];
        
        prosConsView = [[EnterProsConsViewController alloc]init];
        [prosConsView setUpWithDecision:temp];
        
        [self.navigationController pushViewController:prosConsView animated:NO];
        
        compareView = [[ComparisonViewController alloc]initWithDecision:temp];
        [self.navigationController pushViewController:compareView animated:NO];

        resultView = [[ResultViewController alloc]initWithDecision:temp];
        [self.navigationController pushViewController:resultView animated:YES];
        
    }
    
}

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

@end
