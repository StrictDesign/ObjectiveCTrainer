//
//  QuestionViewController.h
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "QuestionModel.h"
#import "ResultView.h"

@interface QuestionViewController : UIViewController<ResultViewProtocol>

@property (strong, nonatomic) QuestionModel *model;
@property (strong, nonatomic) NSArray *questions;

@property (nonatomic) QuizQuestionDifficulty questionDifficulty;

@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;

// Properties for MC Questions
@property (weak, nonatomic) IBOutlet UILabel *questionText;
@property (weak, nonatomic) IBOutlet UIButton *questionMCAnswer1;
@property (weak, nonatomic) IBOutlet UIButton *questionMCAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *questionMCAnswer3;

// Properties for Fill in the blank Questions
@property (weak, nonatomic) IBOutlet UIButton *submitAnswerForBlankButton;
@property (weak, nonatomic) IBOutlet UITextField *blankTextField;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabelForBlank;

// Properties for Image Questions
@property (weak, nonatomic) IBOutlet UIImageView *imageQuestionImageView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end
