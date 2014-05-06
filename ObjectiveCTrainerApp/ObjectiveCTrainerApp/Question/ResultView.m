//
//  ResultView.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 06/05/14.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization properies to new ui element object
        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 200, 50)];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.resultLabel];
        
        self.userAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 200, 100)];
        self.userAnswerLabel.numberOfLines = 0;
        self.userAnswerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.userAnswerLabel];
        
        self.correctAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 240, 200, 100)];
        self.correctAnswerLabel.numberOfLines = 0;
        self.correctAnswerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.correctAnswerLabel];
        
        self.correctAnswerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 300, 200)];
        [self addSubview:self.correctAnswerImageView];
        
        self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.continueButton.frame = CGRectMake(85, 350, 150, 50);
        [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        [self.continueButton addTarget:self action:@selector(continueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.continueButton];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)hideAllElements
{
    self.resultLabel.hidden = YES;
    self.userAnswerLabel.hidden = YES;
    self.correctAnswerLabel.hidden = YES;
    self.correctAnswerImageView.hidden = YES;
    self.continueButton.hidden = YES;
}

- (void)showResultForTextQuestion:(BOOL)wasCorrect forUserAnswer:(NSString*)userAnswer forQuestion:(Question*)question
{
    // Hide all teh elements
    [self hideAllElements];
    
    // Set and show label if user was correct or not
    self.resultLabel.text = wasCorrect ? @"Correct!" : @"Incorrect!";
    self.resultLabel.hidden = NO;
    
    // Set and show user answer
    self.userAnswerLabel.text = [NSString stringWithFormat:@"Your answer was: \n%@", userAnswer];
    self.userAnswerLabel.hidden = NO;
    
    // Set and show the correct answer
    NSString *correctAnswerString = @"";
    
    switch (question.correctMCQuestionIndex) {
        case 1:
            correctAnswerString = question.questionAnswer1;
            break;
            
        case 2:
            correctAnswerString = question.questionAnswer2;
            break;
            
        case 3:
            correctAnswerString = question.questionAnswer3;
            break;
            
        default:
            break;
    }
    
    self.correctAnswerLabel.text = [NSString stringWithFormat:@"The correct answer was: \n%@", correctAnswerString];
    // Show the correct answer label
    self.correctAnswerLabel.hidden = NO;
    
    // Show the continue button
    self.continueButton.hidden = NO;
}

- (void)showResultForImageQuestion:(BOOL)wasCorrect forQuestion:(Question*)question
{
    // Hide all teh elements
    [self hideAllElements];
    // Set and show label if user was correct or not
    self.resultLabel.text = wasCorrect ? @"Correct!" : @"Incorrect!";
    self.resultLabel.hidden = NO;
    
    // Set and show correct answer image
    UIImage *tempImage = [UIImage imageNamed:question.answerImageName];
    self.correctAnswerImageView.image = tempImage;
    
    // Get aspect ratio of image
    double aspect = tempImage.size.height/tempImage.size.width;
    
    
    // Resize imageview
    CGRect imageViewFrame = self.correctAnswerImageView.frame;
    imageViewFrame.size.width = tempImage.size.width - 20;
    imageViewFrame.size.height = imageViewFrame.size.width * aspect;
    self.correctAnswerImageView.frame = imageViewFrame;
    
    self.correctAnswerImageView.hidden = NO;
    
    // Position
    CGRect buttonFrame = self.continueButton.frame;
    buttonFrame.origin.y = self.correctAnswerImageView.frame.origin.y + self.correctAnswerImageView.frame.size.height + 30;
    self.continueButton.frame = buttonFrame;
    
    // Show the button
    self.continueButton.hidden = NO;
}

- (void)continueButtonClicked
{
    // Notify delegate that result view can be dismissed
    [self.delegate resultViewDismissed];
}

@end
