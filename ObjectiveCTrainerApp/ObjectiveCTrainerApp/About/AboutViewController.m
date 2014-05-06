//
//  AboutViewController.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"


@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackButtonClicked:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Objective C Trainer Feedback"];
    [mailComposer setToRecipients:@[@"jimmy@mjallby.net"]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (IBAction)rateButtonClicked:(id)sender
{
    // TODO: Implement rate app
}

- (IBAction)moreTutorialsButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mjallby.net"]];
}

#pragma mark Mail Compose Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // Dismiss the compose controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
