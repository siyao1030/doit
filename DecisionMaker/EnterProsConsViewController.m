//
//  EnterProsConsViewController.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/23/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import "EnterProsConsViewController.h"

@interface EnterProsConsViewController ()

@end

@implementation EnterProsConsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didPressDecide
{
    if (self.decision != nil)
    {
        int diff = abs(self.choiceAfactors.count - self.choiceBfactors.count);
        if (diff >= 3 || diff > MIN(self.choiceBfactors.count, self.choiceAfactors.count)) {
            UIAlertView * tipAlert = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                                message:@"Making the number of Pros and Cons of each Choice comparable improves decision quality."
                                                               delegate:self
                                                      cancelButtonTitle:@"Continue"
                                                      otherButtonTitles:@"Modify", nil];
            [tipAlert setTag:3];
            [tipAlert show];
        }
        

        
        
        self.decision.stage = ComparisonStage;
        //decicison havent been saved
        if (self.decision.rowid == -1)
        {
            int rowid = [Database saveItemWithData:self.decision];
            self.decision.rowid = rowid;
            self.compareView = [[ComparisonViewController alloc] initWithDecision:self.decision];
            [self.navigationController pushViewController:self.compareView animated:YES];
            [[self.navigationController.viewControllers objectAtIndex:0] reload];
            
        }
        // pros and cons had been updated, need to restart
        else if (self.changeFlag == YES)
        {
            NSLog(@"updated!");
            self.decision.numOfCompsDone = 0;
            [(Choice *)self.decision.choices[0] resetStats];
            [(Choice *)self.decision.choices[1] resetStats];
            self.decision.comparisons =[[[ComparisonMaker alloc]initWithDecision:self.decision] inputOrderCompsGenerator];
            [Database replaceItemWithData:self.decision atRow:self.decision.rowid];
            self.compareView = [[ComparisonViewController alloc] initWithDecision:self.decision];
            [self.navigationController pushViewController:self.compareView animated:YES];
            [[self.navigationController.viewControllers objectAtIndex:0] reload];
            [self checkfirstTime];
            self.changeFlag = NO;
        }
        // nothing has been changed
        else
        {
            // comparison in progress already
            int maxComps = MIN(3*MAX(self.choiceAfactors.count, self.choiceBfactors.count), self.choiceAfactors.count*self.choiceBfactors.count);
            if (self.decision.numOfCompsDone > 0 && self.decision.numOfCompsDone <= maxComps)
            {
                UIAlertView * startOverAlert = [[UIAlertView alloc]initWithTitle:@"Decision In Progress" message:@"Do you want to start over?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Start Over", @"Resume", nil];
                [startOverAlert setTag:1];
                [startOverAlert show];
            }
            else
            {
                self.decision.numOfCompsDone = 0;
                [(Choice *)self.decision.choices[0] resetStats];
                [(Choice *)self.decision.choices[1] resetStats];
                self.compareView = [[ComparisonViewController alloc] initWithDecision:self.decision];
                [self.navigationController pushViewController:self.compareView animated:YES];
                [[self.navigationController.viewControllers objectAtIndex:0] reload];
                [self checkfirstTime];

                
            }
        }
        
        
        
        // Decision table view reload
        //[[self.navigationController.viewControllers objectAtIndex:0] reload];
    }
    
    
    
    
   // self.compareView = [[ComparisonViewController alloc] initWithDecision:self.decision];
   // [self.navigationController pushViewController:self.compareView animated:YES];
}

-(void)checkfirstTime
{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"] isEqualToString:@"Tips2"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"TipsDone"] forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView * firstTimeAlert = [[UIAlertView alloc]initWithTitle:@"Tips"
                                                                 message:@"Weigh the pairs of Pros and Cons! Ask yourself which factor matters more to you."
                                                                delegate:self
                                                       cancelButtonTitle:@"Got it!"
                                                       otherButtonTitles:nil];
        [firstTimeAlert setTag:2];
        [firstTimeAlert show];
        
    }
}
-(void)setUpWithDecision:(Decision *)decision
{
    self.decision = decision;
    
    self.choiceAfactors = [[decision.choices objectAtIndex:0] factors];
    self.choiceBfactors = [[decision.choices objectAtIndex:1] factors];
  
    int maxFactor = 50;
    self.AtxtFields = [[NSMutableArray alloc]init];
    self.BtxtFields = [[NSMutableArray alloc]init];
    for (int i = 0; i < maxFactor; i++)
    {
        UITextField * txtField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 160, 45)];
        [txtField1 setLeftViewMode:UITextFieldViewModeAlways];
        [txtField1 setBackgroundColor:bgColor];
        [txtField1 setBorderStyle:UITextBorderStyleNone];
        txtField1.keyboardType = UIKeyboardTypeDefault;
        txtField1.returnKeyType = UIReturnKeyDone;
        txtField1.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtField1.delegate = self;

        
        UITextField * txtField2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 160, 45)];
        [txtField2 setLeftViewMode:UITextFieldViewModeAlways];
        [txtField2 setBackgroundColor:bgColor];
        [txtField2 setBorderStyle:UITextBorderStyleNone];
        txtField2.keyboardType = UIKeyboardTypeDefault;
        txtField2.returnKeyType = UIReturnKeyDone;
        txtField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtField2.delegate = self;
        
        [self.AtxtFields addObject:txtField1];
        [self.BtxtFields addObject:txtField2];
    }
    
    
    
    self.alert = [[UIAlertView alloc]initWithTitle:@"Is this a Pro or a Con?" message:@"Please Select One" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Pro", @"Con", nil];
    [self.alert setTag:0];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"closeicon.png"] forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(295, 72, 16, 16)];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    self.changeFlag = NO;
}

-(UITableView *)makeLeftTableView
{
    //CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat x = 0;
    CGFloat y = self.choiceAButton.frame.size.height;
    CGFloat width = self.view.frame.size.width/2;
    CGFloat height = self.view.frame.size.height - y - statusBarHeight;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = bgColor;
    
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    return tableView;
}

-(UITableView *)makeRightTableView
{
    //CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat x = self.view.frame.size.width/2;
    CGFloat y = self.choiceBButton.frame.size.height;
    CGFloat width = self.view.frame.size.width/2;
    CGFloat height = self.view.frame.size.height - y - statusBarHeight;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    NSLog(@"%f",height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];

    
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = bgColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    return tableView;
}


-(void)cancelButtonPressed
{
    if ([self.inputField isFirstResponder]) {
        [self.inputField resignFirstResponder];
    }
    
    [self.inputField removeFromSuperview];
    [self.isPro removeFromSuperview];
    [self.isCon removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.dimBG removeFromSuperview];
    
    [self.inputField setText:@""];
    
    
}


-(void)proButtonPressed
{
    if (self.isCon.selected) {
        self.isCon.selected = NO;
    }
    self.isPro.selected = YES;
    
}

-(void)conButtonPressed
{
    if (self.isPro.selected) {
        self.isPro.selected = NO;
    }
    self.isCon.selected = YES;

}


-(void)choiceAButtonPressed
{

    [self.AtxtFields[self.choiceAfactors.count] becomeFirstResponder];
}

-(void)choiceBButtonPressed
{
    [self.BtxtFields[self.choiceBfactors.count] becomeFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
        {
            if (buttonIndex == 0)
                self.isPro.selected = YES;
            else if (buttonIndex == 1)
                self.isCon.selected = YES;
            
            [self textFieldDidEndEditing:self.currentTxtField];
            break;
        }
        case 1:
        {
            //start over
            if (buttonIndex == 0)
            {
                NSLog(@"starting over");
                self.decision.numOfCompsDone = 0;
                [self.decision resetStats];
                self.compareView = [[ComparisonViewController alloc] initWithDecision:self.decision];
                [self.navigationController pushViewController:self.compareView animated:YES];
                [[self.navigationController.viewControllers objectAtIndex:0] reload];
                [self checkfirstTime];
            }
            //resume
            else if (buttonIndex == 1)
            {
                int maxComps = MIN(3*MAX(self.choiceAfactors.count, self.choiceBfactors.count), self.choiceAfactors.count*self.choiceBfactors.count);
                
                if (self.decision.numOfCompsDone == maxComps)
                {
                    NSLog(@"resume go directly to result");
                    //Decision * temp = [self.decision copy];
                    //[temp resetStats];
                    ComparisonViewController * compareView = [[ComparisonViewController alloc]initWithDecision:self.decision];
                    [self.navigationController pushViewController:compareView animated:NO];
                    
                    ResultViewController * resultView = [[ResultViewController alloc]initWithDecision:self.decision];
                    [self.navigationController pushViewController:resultView animated:YES];
                    [[self.navigationController.viewControllers objectAtIndex:0] reload];
                }
                else
                {
                    NSLog(@"resume go to comparison");
                    self.compareView = [[ComparisonViewController alloc] initWithDecision:self.decision];
                    [self.navigationController pushViewController:self.compareView animated:YES];
                    [[self.navigationController.viewControllers objectAtIndex:0] reload];
                    [self checkfirstTime];
                }
            }
            break;

        }
        case 3:
        {
            if (buttonIndex == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    
}

- (int)findIndexinTextFields:(NSMutableArray *)txtFields forTextField:(UITextField*)txtField
{
    for (int i = 0; i < txtFields.count; i++)
    {
        if (txtFields[i] == txtField)
            return i;
    }
    return -1;
}



- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (self.isPro == nil)
    {
        self.isPro = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * pro = [UIImage imageNamed:@"proGray.png"];
        [self.isPro setFrame:CGRectMake(100, self.view.frame.size.height-216-58, pro.size.width, pro.size.height)];
        [self.isPro setImage:pro forState:UIControlStateNormal];
        [self.isPro setImage:[UIImage imageNamed:@"pro.png"] forState:UIControlStateSelected];
        [self.isPro addTarget:self action:@selector(proButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (self.isCon == nil)
    {
        self.isCon = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * con = [UIImage imageNamed:@"conGray.png"];
        [self.isCon setFrame:CGRectMake(175, self.view.frame.size.height-216-55, con.size.width, con.size.height)];
        [self.isCon setImage:[UIImage imageNamed:@"conGray.png"] forState:UIControlStateNormal];
        [self.isCon setImage:[UIImage imageNamed:@"con.png"] forState:UIControlStateSelected];
        [self.isCon addTarget:self action:@selector(conButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    // prepopulate pro con setting with the current factor
    int foundIndex = [self findIndexinTextFields:self.AtxtFields forTextField:textField];
    
    if (foundIndex != -1 && foundIndex < self.choiceAfactors.count)
    {
        self.isPro.selected = ((Factor *)self.choiceAfactors[foundIndex]).isPro;
        self.isCon.selected = !((Factor *)self.choiceAfactors[foundIndex]).isPro;
        [self.view addSubview:self.isPro];
        [self.view addSubview:self.isCon];
    }
    else
    {
        foundIndex = [self findIndexinTextFields:self.BtxtFields forTextField:textField];
        if (foundIndex != -1 && foundIndex < self.choiceBfactors.count)
        {
            self.isPro.selected = ((Factor *)self.choiceBfactors[foundIndex]).isPro;
            self.isCon.selected = !((Factor *)self.choiceBfactors[foundIndex]).isPro;
            [self.view addSubview:self.isPro];
            [self.view addSubview:self.isCon];
        }
    }
    
    
    //[self.view addSubview:self.isPro];
    //[self.view addSubview:self.isCon];
    
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder])
        [textField resignFirstResponder];
    
    
    [self.choiceATableView reloadData];
    [self.choiceBTableView reloadData];
    
    
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString: @""]) {
        self.changeFlag = YES;
        
        Factor * factor;
        if (self.isPro.selected == NO && self.isCon.selected == NO)
        {
            self.currentTxtField = textField;
            [self.alert show];
        }
        else
        {
            
            if (self.isPro.selected)
            {
                factor = [[Factor alloc]initWithTitle:textField.text andIsPro:YES];
            }
            else if (self.isCon.selected)
            {
                factor = [[Factor alloc]initWithTitle:textField.text andIsPro:NO];
            }

            if ([self.AtxtFields containsObject:textField]) {
                
                for (int i = 0; i < self.AtxtFields.count; i++)
                {
                    if (self.AtxtFields[i] == textField)
                    {
                        if (i < self.choiceAfactors.count) {
                            [self.choiceAfactors removeObjectAtIndex:i];
                            [self.choiceAfactors insertObject:factor atIndex:i];
                        }
                        else
                        {
                            [self.choiceAfactors addObject:factor];
                        }
                        break;
                    }
                    
                }
            }
            else
            {
                for (int i = 0; i < self.BtxtFields.count; i++)
                {
                    if (self.BtxtFields[i] == textField)
                    {
                        if (i < self.choiceBfactors.count) {
                            [self.choiceBfactors removeObjectAtIndex:i];
                            [self.choiceBfactors insertObject:factor atIndex:i];
                        }
                        else
                        {
                            [self.choiceBfactors addObject:factor];
                        }
                    }
                    
                }
            }
        }
        [self.choiceATableView reloadData];
        [self.choiceBTableView reloadData];
    }
    
    self.isPro.selected = NO;
    self.isCon.selected = NO;
    
    
    [self.isPro removeFromSuperview];
    [self.isCon removeFromSuperview];
    
    if (self.choiceAfactors.count < 1 || self.choiceBfactors.count < 1)
        self.decideButton.enabled = NO;
    else if (self.choiceAfactors.count > 0 && self.choiceBfactors.count > 0)
        self.decideButton.enabled = YES;
    
    
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
    
    if (self.choiceATableView==tableView)
    {
        return self.choiceAfactors.count+1;
    }
    else
    {
        return self.choiceBfactors.count+1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    if (self.choiceATableView==tableView)
    {
        cell = [self.choiceATableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        cell = [self.choiceBTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...

    
    Factor *temp;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];

    if (self.choiceATableView==tableView)
    {
        UITextField * txtField = [self.AtxtFields objectAtIndex:indexPath.row];
        if (indexPath.row < self.choiceAfactors.count)
        {
            temp = [self.choiceAfactors objectAtIndex:indexPath.row];
            txtField.text = temp.title;
            
            if (temp.isPro)
                [txtField setBackgroundColor:lightGreen];
            else
                [txtField setBackgroundColor:darkGreen];
            
            txtField.textColor = [UIColor whiteColor];
            [txtField setFont:[UIFont fontWithName: @"HelveticaNeue-Bold"  size: 18]];
            //[txtField setTextAlignment:NSTextAlignmentRight];
        }
        [txtField setLeftView:spacerView];
        [cell.contentView addSubview:txtField];

    }
    else if (self.choiceBTableView==tableView)
    {
        UITextField * txtField = [self.BtxtFields objectAtIndex:indexPath.row];
        if (indexPath.row < self.choiceBfactors.count)
        {
            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
            temp = [self.choiceBfactors objectAtIndex:indexPath.row];
            txtField.text = temp.title;
            //[[cell textLabel] setText:temp.title];
            if (temp.isPro)
                [txtField setBackgroundColor:lightOrange];
            else
                [txtField setBackgroundColor:darkOrange];
            
            txtField.textColor = [UIColor whiteColor];
            [txtField setFont:[UIFont fontWithName: @"HelveticaNeue-Bold"  size: 18]];
        }
        [txtField setLeftView:spacerView];
        [cell.contentView addSubview:txtField];
        
    }
    
    
    if (cell == nil)
        NSLog(@"Cell is nil");
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        UITextField * txtField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 160, 45)];
        [txtField1 setLeftViewMode:UITextFieldViewModeAlways];
        [txtField1 setBackgroundColor:bgColor];
        [txtField1 setBorderStyle:UITextBorderStyleNone];
        txtField1.keyboardType = UIKeyboardTypeDefault;
        txtField1.returnKeyType = UIReturnKeyDone;
        txtField1.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtField1.delegate = self;
        
        if (self.choiceATableView==tableView)
        {
            if (self.choiceAfactors.count > 0)
            {
                [self.choiceAfactors removeObjectAtIndex:indexPath.row];
                [self.AtxtFields removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.changeFlag = YES;
            }
            //[self.AtxtFields addObject:txtField1];
        }
        if (self.choiceBTableView==tableView)
        {
            if (self.choiceBfactors.count > 0)
            {
                [self.choiceBfactors removeObjectAtIndex:indexPath.row];
                [self.BtxtFields removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.changeFlag = YES;
            }
            //[self.BtxtFields addObject:txtField1];
        }
        
        
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        self.changeFlag = YES;
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    
    
    if (self.choiceAfactors.count < 1 || self.choiceBfactors.count < 1)
        self.decideButton.enabled = NO;
    else if (self.choiceAfactors.count > 0 && self.choiceBfactors.count > 0)
        self.decideButton.enabled = YES;
    
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = titleColor;
    self.navigationItem.titleView = label;
    
    [label setText: @"Pros & Cons"];
    [label sizeToFit];
    
    self.view.backgroundColor = bgColor;
    
    self.decideButton = [[UIBarButtonItem alloc]initWithTitle:@"Decide!" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDecide)];
    self.decideButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:self.decideButton animated:YES];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    
    // Constructing buttons
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    
    self.choiceAButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.choiceAButton setFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 45)];
    [self.choiceAButton setTitle:[[self.decision.choices objectAtIndex:0] title] forState:UIControlStateNormal];
    [self.choiceAButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Bold"  size: 18]];
    self.choiceAButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.choiceAButton setTitleColor:darkGreen forState:UIControlStateNormal];
    [self.choiceAButton addTarget:self action:@selector(choiceAButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.choiceAButton];
    
    
    self.choiceBButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.choiceBButton setFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 45)];
    [self.choiceBButton setTitle:[[self.decision.choices objectAtIndex:1] title] forState:UIControlStateNormal];
    self.choiceBButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.choiceBButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Bold"  size: 18]];
    [self.choiceBButton setTitleColor:darkOrange forState:UIControlStateNormal];
    [self.choiceBButton addTarget:self action:@selector(choiceBButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.choiceBButton];

    
    // Constructing tables
    self.choiceATableView = [self makeLeftTableView];
    self.choiceBTableView = [self makeRightTableView];
    
    [self.choiceATableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.choiceBTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.choiceATableView];
    [self.view addSubview:self.choiceBTableView];

    /*
    
    if ([self.choiceATableView respondsToSelector:@selector(setSeparatorStyle:)]) {
        [self.choiceATableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.choiceBTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    */
    self.choiceATableView.allowsSelection = NO;
    self.choiceBTableView.allowsSelection = NO;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.view addGestureRecognizer:tgr];
    
    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    self.keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    self.choiceATableView.contentSize = CGSizeMake(320, 45*self.choiceAfactors.count+1);
    self.choiceBTableView.contentSize = CGSizeMake(320, 45*self.choiceBfactors.count+1);
    // Do any additional setup after loading the view from its nib.
    
    

    
    // not enough factors
    if (self.choiceAfactors.count < 1 || self.choiceBfactors.count < 1)
        self.decideButton.enabled = NO;
    else if (self.choiceAfactors.count > 0 || self.choiceBfactors.count > 0)
        self.decideButton.enabled = YES;
    
    
}



- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrameA = self.choiceATableView.frame;
    CGRect viewFrameB = self.choiceBTableView.frame;

    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrameA.size.height += keyboardSize.height+55;
    viewFrameB.size.height += keyboardSize.height+55;

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.choiceATableView setFrame:viewFrameA];
    [self.choiceBTableView setFrame:viewFrameB];
    [UIView commitAnimations];
    
    self.keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (self.keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrameA = self.choiceATableView.frame;
    CGRect viewFrameB = self.choiceBTableView.frame;

    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrameA.size.height -= keyboardSize.height+55;
    viewFrameB.size.height -= keyboardSize.height+55;

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.choiceATableView setFrame:viewFrameA];
    [self.choiceBTableView setFrame:viewFrameB];
    [UIView commitAnimations];
    self.keyboardIsShown = YES;
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    //UITextField * currentTextField = [(UIResponder *)self.view currentFirstResponder];
    
    // remove keyboard
    for (UITextField * txt in self.AtxtFields)
    {
        if ([txt isFirstResponder])
            [txt resignFirstResponder];
    }
    for (UITextField * txt in self.BtxtFields)
    {
        if ([txt isFirstResponder])
            [txt resignFirstResponder];
    }
    
    //self.changeFlag = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
