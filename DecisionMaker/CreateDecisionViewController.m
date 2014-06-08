//
//  CreateDecisionViewController.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "CreateDecisionViewController.h"

@interface CreateDecisionViewController ()

@end

@implementation CreateDecisionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

        
    }
    return self;
}



-(void)setup
{
    self.decision.stage = CreateStage;
    UILabel * decideBetween = [[UILabel alloc]initWithFrame:CGRectMake(20, 148, 280, 30)];
    [decideBetween setFont:[UIFont fontWithName: @"HelveticaNeue-Thin"  size: 20]];
    [decideBetween setText:@"I am deciding between"];
    [decideBetween setTextColor:[UIColor blackColor]];
    [decideBetween setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:decideBetween];

    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 184, 10, 40)];
    self.choiceA = [[UITextField alloc]initWithFrame:CGRectMake(20, 184, 280, 40)];
    [self.choiceA setFont:[UIFont fontWithName: @"HelveticaNeue-Bold"  size: 18]];
    [self.choiceA setTextColor:darkGreen];
    [self.choiceA setBackgroundColor:lightGreen];
    [self.choiceA setBorderStyle:UITextBorderStyleNone];
    [self.choiceA setLeftView:spacerView2];
    [self.choiceA setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:self.choiceA];

    
    UILabel * and = [[UILabel alloc]initWithFrame:CGRectMake(20, 228, 195, 30)];
    [and setFont:[UIFont fontWithName: @"HelveticaNeue-Thin"  size: 20]];
    [and setText:@"and"];
    [and setTextAlignment:NSTextAlignmentLeft];
    [and setTextColor:[UIColor blackColor]];
    [self.view addSubview:and];

    UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(20, 261, 10, 40)];

    self.choiceB = [[UITextField alloc]initWithFrame:CGRectMake(20, 261, 280, 40)];
    [self.choiceB setTextColor:darkOrange];
    [self.choiceB setBackgroundColor:lightOrange];
    [self.choiceB setFont:[UIFont fontWithName: @"HelveticaNeue-Bold"  size: 18]];
    [self.choiceB setBorderStyle:UITextBorderStyleNone];
    [self.choiceB setLeftView:spacerView3];
    [self.choiceB setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:self.choiceB];
    
    
    self.decisionTitle = [[UITextField alloc]initWithFrame:CGRectMake(20, 93, 280, 60)];
    [self.decisionTitle setPlaceholder:@"Decision Title"];
    [self.decisionTitle setBackgroundColor:[UIColor clearColor]];
    [self.decisionTitle setFont:[UIFont fontWithName: @"HelveticaNeue-CondensedBold"  size: 30]];
    [self.decisionTitle setTextColor:[UIColor blackColor]];
    [self.decisionTitle setBorderStyle:UITextBorderStyleNone];
    [self.view addSubview:self.decisionTitle];
    


}

-(void)resetFields
{
    [self.decisionTitle setText:@""];
    [self.choiceA setText:@""];
    [self.choiceB setText:@""];
}

-(void)setUpWithDecision:(Decision *)decision
{
    self.decision = decision;
    [self.decisionTitle setText:decision.title];
    [self.choiceA setText:[[decision.choices objectAtIndex:0] title]];
    [self.choiceB setText:[[decision.choices objectAtIndex:1] title]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.decisionTitle.isFirstResponder) {
        [self.decisionTitle resignFirstResponder];
    }
    if (self.choiceA.isFirstResponder) {
        [self.choiceA resignFirstResponder];
    }
    if (self.choiceB.isFirstResponder) {
        [self.choiceB resignFirstResponder];
    }
    
    
    return YES;
}

-(IBAction)backgroundTouched:(id)sender
{
    if (self.decisionTitle.isFirstResponder) {
        [self.decisionTitle resignFirstResponder];
    }
    if (self.choiceA.isFirstResponder) {
        [self.choiceA resignFirstResponder];
    }
    if (self.choiceB.isFirstResponder) {
        [self.choiceB resignFirstResponder];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    if (self.decisionTitle.isFirstResponder) {
        [self.decisionTitle resignFirstResponder];
    }
    if (self.choiceA.isFirstResponder) {
        [self.choiceA resignFirstResponder];
    }
    if (self.choiceB.isFirstResponder) {
        [self.choiceB resignFirstResponder];
    }
}

- (void)didPressDone
{
    if ([self.decisionTitle.text  isEqual: @""]) {
        [self.decisionTitle setText:[NSString stringWithFormat:@"%@%@%@", self.choiceA.text, @" vs. ", self.choiceB.text]];
    }
    
    if (self.decision == NULL)
    {
        NSLog(@"new decision");
        Choice * choiceA = [[Choice alloc]initWithTitle:self.choiceA.text];
        Choice * choiceB = [[Choice alloc]initWithTitle:self.choiceB.text];
        self.decision = [[Decision alloc]initWithChoiceA:choiceA andChoiceB:choiceB andTitle:self.decisionTitle.text];
        
        self.decision.stage = ProsConsStage;
        NSLog(@"%d",self.decision.rowid);
        // what is the rowid here???
        //adding decision here
        //[self.target performSelector:self.action withObject:self.decision];
        int rowid = [Database saveItemWithData:self.decision];
        self.decision.rowid = rowid;
    }
    else
    {
        [self.decision changeTitle:self.decisionTitle.text];
        [(Choice *)self.decision.choices[0] changeTitle:self.choiceA.text];
        [(Choice *)self.decision.choices[1] changeTitle:self.choiceB.text];
        
        [Database replaceItemWithData:self.decision atRow:self.decision.rowid];
    }
    
    [self.target reload];
    
    EnterProsConsViewController *prosConsView = [[EnterProsConsViewController alloc]init];
    prosConsView.target = self.target;
    prosConsView.action = self.action;
    
    [self.navigationController pushViewController:prosConsView animated:YES];
    [prosConsView setUpWithDecision:self.decision];
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"] isEqualToString:@"Tips1"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"Tips2"] forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView * firstTimeAlert = [[UIAlertView alloc]initWithTitle:@"Tips"
                                                        message:@"To make a good decision, try to be as fair and as thorough as possible when entering Pros and Cons."
                                                       delegate:self
                                              cancelButtonTitle:@"Got it!"
                                              otherButtonTitles:nil];
        [firstTimeAlert setTag:2];
        [firstTimeAlert show];
    }
    

    
}


// save current decision when leaving create page to table view
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
//        
//        NSLog(@"rowid: %d",self.decision.rowid);
//        if (self.decision != nil)
//        {
//            //decicison havent been saved
//            if (self.decision.rowid == -1)
//            {
//                NSLog(@"saving decision");
//                int rowid = [Database saveItemWithData:self.decision];
//                self.decision.rowid = rowid;
//            }
//            else
//            {
//                NSLog(@"replacing decision");
//                [Database replaceItemWithData:self.decision atRow:self.decision.rowid];
//            }
//            
//            // Decision table view reload
//            [[self.navigationController.viewControllers objectAtIndex:0] reload];
//        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = titleColor; // change this color
    self.navigationItem.titleView = label;
    
    [label setText: @"Create Decision"];
    [label sizeToFit];
    
    self.view.backgroundColor = bgColor;

    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDone)];
    doneButton.tintColor = titleColor;
    
    //self.navigationItem.backBarButtonItem.tintColor = titleColor;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObject: doneButton] animated:NO];
    

    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
