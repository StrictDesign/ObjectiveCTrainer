//
//  StatsViewController.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "StatsViewController.h"
#import "SWRevealViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add pan gestures recognizer for revealing the menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Load and display stats
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Easy stats
    int easyQuestionsAnswered = [userDefaults integerForKey:@"EasyQuestionsAnswered"];
    int easyQuestionsAnsweredCorrect = [userDefaults integerForKey:@"EasyQuestionsAnsweredCorrectly"];
    self.easyQuestionsStats.text = [NSString stringWithFormat:@"Easy Questions: %i / %i",easyQuestionsAnsweredCorrect, easyQuestionsAnswered];
    
    // Easy stats
    int mediumQuestionsAnswered = [userDefaults integerForKey:@"MediumQuestionsAnswered"];
    int mediumQuestionsAnsweredCorrect = [userDefaults integerForKey:@"MediumQuestionsAnsweredCorrectly"];
    self.mediumQuestionsStats.text = [NSString stringWithFormat:@"Medium Questions: %i / %i",mediumQuestionsAnsweredCorrect, mediumQuestionsAnswered];
    
    // Easy stats
    int hardQuestionsAnswered = [userDefaults integerForKey:@"HardQuestionsAnswered"];
    int hardQuestionsAnsweredCorrect = [userDefaults integerForKey:@"HardQuestionsAnsweredCorrectly"];
    self.hardQuestionsStats.text = [NSString stringWithFormat:@"Hard Questions: %i / %i",hardQuestionsAnsweredCorrect, hardQuestionsAnswered];
    
    // Total
    self.totalQuestionsLabel.text = [NSString stringWithFormat:@"Total Questions Answered: %i", easyQuestionsAnswered + mediumQuestionsAnswered + hardQuestionsAnswered];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
