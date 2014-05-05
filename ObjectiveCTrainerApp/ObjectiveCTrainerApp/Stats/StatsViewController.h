//
//  StatsViewController.h
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *easyQuestionsStats;
@property (weak, nonatomic) IBOutlet UILabel *mediumQuestionsStats;
@property (weak, nonatomic) IBOutlet UILabel *hardQuestionsStats;

@end
