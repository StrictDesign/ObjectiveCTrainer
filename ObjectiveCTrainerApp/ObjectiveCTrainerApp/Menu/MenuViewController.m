//
//  MenuViewController.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    // Set the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Fetch the menu items
    self.menuItems = [[[MenuModel alloc] init] getMenuItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Delegate Methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrive Cell
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get menu item that it's asking for
    MenuItem *item = self.menuItems[indexPath.row];
    
    // Get image view
    UIImageView *iconImageView = (UIImageView *)[menuCell viewWithTag:2];
    UILabel *menuItemTitle = (UILabel *)[menuCell viewWithTag:1];
    
    // Set menu item text and icon
    menuItemTitle.text = item.menuTitle;
    iconImageView.image = [UIImage imageNamed:item.menuIcon];
    
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check wich tab was selected
    MenuItem *item = self.menuItems[indexPath.row];
    
    switch (item.screenType) {
        case ScreenTypeQuestion:
            // Go to Questions
            [self performSegueWithIdentifier:@"GoToQuestionsSegue" sender:self];
            break;
        case ScreenTypeStats:
            // Go to Stats
            [self performSegueWithIdentifier:@"GoToStatsSegue" sender:self];
            break;
        case ScreenTypeAbout:
            // Go to About
            [self performSegueWithIdentifier:@"GoToAboutSegue" sender:self];
            break;
        case ScreenTypeRemoveAds:
            // Go to Remove Ads
            [self performSegueWithIdentifier:@"GoToRemoveAdsSegue" sender:self];
            break;
        default:
            break;
    }
}

#pragma mark Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Set the front view controller to the destination one
    [self.revealViewController setFrontViewController:segue.destinationViewController];
    
    // Slide the front view controller back into place
    [self.revealViewController revealToggleAnimated:YES];
}


@end
