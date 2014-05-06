//
//  ResultView.h
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 06/05/14.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol ResultViewProtocol <NSObject>

- (void)resultViewDismissed;

@end

@interface ResultView : UIView

@property (weak, nonatomic) id<ResultViewProtocol> delegate;

// Label to display correct or incorrect
@property (strong, nonatomic) UILabel *resultLabel;

// Label to display user answer
@property (strong, nonatomic) UILabel *userAnswerLabel;

// Label to display correct answer for text based questions
@property (strong, nonatomic) UILabel *correctAnswerLabel;

// Label to display the correct answer image for image based questions
@property (strong, nonatomic) UIImageView *correctAnswerImageView;

// Button to continue
@property (strong, nonatomic) UIButton *continueButton;

- (void)showResultForTextQuestion:(BOOL)wasCorrect forUserAnswer:(NSString*)userAnswer forQuestion:(Question*)question;

- (void)showResultForImageQuestion:(BOOL)wasCorrect forQuestion:(Question*)question;

@end
