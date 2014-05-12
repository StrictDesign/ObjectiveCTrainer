//
//  QuestionViewController.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "QuestionViewController.h"
#import "SWRevealViewController.h"

@interface QuestionViewController ()
{
    Question *_currentQuestion;
    
    UIView *_tappablePortionOfImageQuestion;
    UITapGestureRecognizer *_tapRecognizer;
    UITapGestureRecognizer *_scrollViewTapGestureRecognizer;
    
    ResultView *_resultView;
    UIView *_dimmedBackground;
}

@end

@implementation QuestionViewController

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
    
    // Add tap gesture to scrollview
    _scrollViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    [self.questionScrollView addGestureRecognizer:_scrollViewTapGestureRecognizer];
    
    // Add pan gesture recognizer for menu reveal
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Hide everything
    [self hideAllQuestionElements];
    
    // Create the Quiz Model
    self.model = [[QuestionModel alloc] init];
    
    // Check difficulty level and retrive questions for desired level
    self.questions = [self.model getQuestions:self.questionDifficulty];
    
    // Display a random question
    [self randomizeQuestionForDisplay];
    
    // Add background behind status bar
    UIView *statusBarBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarBg.backgroundColor = [UIColor colorWithRed:11/255.0 green:187/255.0 blue:115/255.0 alpha:1.0];
    [self.view addSubview:statusBarBg];
    
    // Set button styles
    UIColor *buttonBorderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    
    [self.questionMCAnswer1.layer setBorderWidth:1.0];
    [self.questionMCAnswer2.layer setBorderWidth:1.0];
    [self.questionMCAnswer3.layer setBorderWidth:1.0];
    [self.questionMCAnswer1.layer setBorderColor:buttonBorderColor.CGColor];
    [self.questionMCAnswer2.layer setBorderColor:buttonBorderColor.CGColor];
    [self.questionMCAnswer3.layer setBorderColor:buttonBorderColor.CGColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Call super implementation
    [super viewDidAppear:animated];
    
    // Create a result view
    _resultView = [[ResultView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20)];
    _resultView.delegate = self;
    
    // Create dimmed BG
    _dimmedBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _dimmedBackground.backgroundColor = [UIColor blackColor];
    _dimmedBackground.alpha = 0.3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllQuestionElements
{
    // Hide the header labels
    self.questionHeaderLabel.alpha = 0.0;
    self.answerHeaderLabel.alpha = 0.0;
    
    // Hide question label and position of the grid
    self.questionText.hidden = YES;
    CGRect questionTextFrame = self.questionText.frame;
    questionTextFrame.origin.y = 2000;
    self.questionText.frame = questionTextFrame;
    
    // Hide answer buttons and position of the grid
    self.questionMCAnswer1.hidden = YES;
    CGRect answerButtonFrame = self.questionMCAnswer1.frame;
    answerButtonFrame.origin.y = 2000;
    self.questionMCAnswer1.frame = answerButtonFrame;
    
    self.questionMCAnswer2.hidden = YES;
    answerButtonFrame = self.questionMCAnswer2.frame;
    answerButtonFrame.origin.y = 2000;
    self.questionMCAnswer2.frame = answerButtonFrame;
    
    self.questionMCAnswer3.hidden = YES;
    answerButtonFrame = self.questionMCAnswer3.frame;
    answerButtonFrame.origin.y = 2000;
    self.questionMCAnswer3.frame = answerButtonFrame;
    
    self.submitAnswerForBlankButton.hidden = YES;
    self.blankTextField.hidden = YES;
    self.imageQuestionImageView.hidden = YES;
    
    // Remove the tappable uiview for image questions
    if (_tappablePortionOfImageQuestion.superview != nil)
    {
        [_tappablePortionOfImageQuestion removeFromSuperview];
    }
}
- (IBAction)menuButtonTapped:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

#pragma mark Questions Methods

- (void)displayCurrentQuestion
{
    switch (_currentQuestion.questionType) {
        case QuestionTypeMC:
            [self displayMCQuestion];
            break;
            
        case QuestionTypeBlank:
            [self displayBlankQuestion];
            break;
            
        case QuestionTypeImage:
            [self displayImageQuestion];
            break;
            
        default:
            break;
    }
}

- (void)displayMCQuestion
{
    // Hide all the elements
    [self hideAllQuestionElements];
    
    // Set question elements
    self.questionText.text = _currentQuestion.questionText;
    [self.questionMCAnswer1 setTitle:_currentQuestion.questionAnswer1 forState:UIControlStateNormal];
    [self.questionMCAnswer2 setTitle:_currentQuestion.questionAnswer2 forState:UIControlStateNormal];
    [self.questionMCAnswer3 setTitle:_currentQuestion.questionAnswer3 forState:UIControlStateNormal];
    
    // Adjust scrollView
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.questionText.hidden = NO;
    self.questionMCAnswer1.hidden = NO;
    self.questionMCAnswer2.hidden = NO;
    self.questionMCAnswer3.hidden = NO;
    
    // Animate the labels and buttons back to their positions
    [UIView animateWithDuration:1.0 animations:^(void){
        
        // Positon the text
        CGRect questionTextFrame = self.questionText.frame;
        questionTextFrame.origin.y = 40;
        self.questionText.frame = questionTextFrame;
    }];
    
    [UIView animateWithDuration:1.0
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         // Position the button 1
                         CGRect answerButton1Frame = self.questionMCAnswer1.frame;
                         answerButton1Frame.origin.y = 243;
                         self.questionMCAnswer1.frame = answerButton1Frame;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1.0
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         // Position the button 2
                         CGRect answerButton2Frame = self.questionMCAnswer2.frame;
                         answerButton2Frame.origin.y = 311;
                         self.questionMCAnswer2.frame = answerButton2Frame;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1.0
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         // Position the button 3
                         CGRect answerButton3Frame = self.questionMCAnswer3.frame;
                         answerButton3Frame.origin.y = 379;
                         self.questionMCAnswer3.frame = answerButton3Frame;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.5
                          delay:1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         // Reveal the header labels
                         self.questionHeaderLabel.alpha = 1.0;
                         self.answerHeaderLabel.alpha  = 1.0;
                         
                     }
                     completion:nil];
}

- (void)displayImageQuestion
{
    // Hide all the elements
    [self hideAllQuestionElements];
    
    // Set question elements
    
    // Set Image
    UIImage *tempImage = [UIImage imageNamed:_currentQuestion.questionImageName];
    self.imageQuestionImageView.image = tempImage;
    
    CGRect imageViewFrame = self.imageQuestionImageView.frame;
    imageViewFrame.size.height = tempImage.size.height;
    imageViewFrame.size.width = tempImage.size.width;
    
    self.imageQuestionImageView.frame = imageViewFrame;
    
    // Create tappable part
    int tappable_x = self.imageQuestionImageView.frame.origin.x + _currentQuestion.offset_x - 10;
    int tappable_y = self.imageQuestionImageView.frame.origin.y + _currentQuestion.offset_y - 10;
    
    _tappablePortionOfImageQuestion = [[UIView alloc] initWithFrame:CGRectMake(tappable_x, tappable_y, 20, 20)];
    _tappablePortionOfImageQuestion.backgroundColor = [UIColor redColor];
    
    // Create and attach gesture recognizer
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageQuestionAnswered)];
    [_tappablePortionOfImageQuestion addGestureRecognizer:_tapRecognizer];
    
    // Add tappable part
    [self.questionScrollView addSubview:_tappablePortionOfImageQuestion];
    
    self.imageQuestionImageView.hidden = NO;
}

- (void)displayBlankQuestion
{
    // Hide all the elements
    [self hideAllQuestionElements];
    
    // Set question image for fill in the blank questions
    // Set Image
    UIImage *tempImage = [UIImage imageNamed:_currentQuestion.questionImageName];
    self.imageQuestionImageView.image = tempImage;
    
    CGRect imageViewFrame = self.imageQuestionImageView.frame;
    imageViewFrame.size.height = tempImage.size.height;
    imageViewFrame.size.width = tempImage.size.width;
    self.imageQuestionImageView.frame = imageViewFrame;
    
    
    
    
    self.questionText.text = _currentQuestion.questionText;
    
    // Adjust scrollView
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.imageQuestionImageView.hidden = NO;
    self.submitAnswerForBlankButton.hidden = NO;
    self.blankTextField.hidden = NO;
}

- (void)randomizeQuestionForDisplay
{
    // Randomize a question
    int randomQuestionIndex = arc4random() % self.questions.count;
    _currentQuestion = self.questions[randomQuestionIndex];
    
    // Display the question
    [self displayCurrentQuestion];
}

#pragma mark Question Answer Handlers

- (IBAction)skipButtonClicked:(id)sender
{
    // Randomize and display another question
    [self randomizeQuestionForDisplay];
}

- (IBAction)questionMCAnswer:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    BOOL isCorrect = NO;
    
    NSString *userAnswer;
    
    switch (selectedButton.tag) {
        case 1:
            userAnswer = _currentQuestion.questionAnswer1;
            break;
            
        case 2:
            userAnswer = _currentQuestion.questionAnswer2;
            break;
            
        case 3:
            userAnswer = _currentQuestion.questionAnswer3;
            break;
            
        default:
            break;
    }
    
    if (selectedButton.tag == _currentQuestion.correctMCQuestionIndex)
    {
        // User got it right
        isCorrect = YES;
    }
    else
    {
        // User got it wrong
    }
    
    // Display message for answer
    [_resultView showResultForTextQuestion:isCorrect forUserAnswer:userAnswer forQuestion:_currentQuestion];
    [self.view addSubview:_dimmedBackground];
    [self.view addSubview:_resultView];
    
    // Record questions data
    [self savedQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display the next question
    [self randomizeQuestionForDisplay];
}

-(void)imageQuestionAnswered
{
    // User got it right
    
    // Display message for right answer
    [_resultView showResultForImageQuestion:YES forQuestion:_currentQuestion];
    [self.view addSubview:_dimmedBackground];
    [self.view addSubview:_resultView];
    
    [self savedQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:YES];
    
    // Display the next question
    [self randomizeQuestionForDisplay];
}

-(IBAction)blankSubmitted:(id)sender
{
    // Retract keyboard
    [self.blankTextField resignFirstResponder];
    
    // Get answer
    NSString *answer = self.blankTextField.text;
    BOOL isCorrect = NO;
    
    // Check if answer is right
    if ([answer isEqualToString:_currentQuestion.correctAnswerForBlank])
    {
        // User got it right
        isCorrect = YES;
        
        // TODO: display message for correct answer
    }
    else
    {
        // User got it wrong
    }
    
    // Clear the text field
    self.blankTextField.text = @"";
    
    // Display message for right answer
    [_resultView showResultForImageQuestion:YES forQuestion:_currentQuestion];
    [self.view addSubview:_dimmedBackground];
    [self.view addSubview:_resultView];
    
    // Record question data
    [self savedQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display the next question
    [self randomizeQuestionForDisplay];
}

- (void)savedQuestionData:(QuizQuestionType)type withDifficulty:(QuizQuestionDifficulty)difficulty isCorrect:(BOOL)correct
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Save data based on type
    NSString *keyToSaveForType = @"";
    
    if (type == QuestionTypeBlank)
    {
        // Record that they answered an Blank question
        keyToSaveForType = @"Blank";
    }
    else if (type == QuestionTypeMC)
    {
        // Record that they answered an MC question
        keyToSaveForType = @"MC";
        
    }
    else if (type == QuestionTypeImage)
    {
        keyToSaveForType = @"Image";
    }
    
    // Record that they answered a question by type
    int questionsAnsweredByType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionAnswered", keyToSaveForType]];
    questionsAnsweredByType++;
    [userDefaults setInteger:questionsAnsweredByType forKey:[NSString stringWithFormat:@"%@QuestionAnswered", keyToSaveForType]];
    
    // Record that they answered a question correctly by type
    int questionsAnsweredCorrectlyByType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionAnsweredCorrectly", keyToSaveForType]];
    questionsAnsweredCorrectlyByType++;
    [userDefaults setInteger:questionsAnsweredCorrectlyByType forKey:[NSString stringWithFormat:@"%@QuestionAnsweredCorrectly", keyToSaveForType]];
    
    
    
    
    // Save data based on difficulty
    NSString *keyToSave = @"";
    
    if (difficulty == QuestionDifficultyEasy)
    {
        keyToSave = @"Easy";
    }
    else if (difficulty == QuestionDifficultyMedium)
    {
        keyToSave = @"Meduim";
    }
    else if (difficulty == QuestionDifficultyHard)
    {
        keyToSave = @"Hard";
    }
    
    int questionAnsweredWithDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSave]];
    questionAnsweredWithDifficulty++;
    [userDefaults setInteger:questionAnsweredWithDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSave]];
    if (correct)
    {
        int questionAnsweredCorrectlyWithDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSave]];
        questionAnsweredCorrectlyWithDifficulty++;
        [userDefaults setInteger:questionAnsweredCorrectlyWithDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSave]];
    }
    
    [userDefaults synchronize];

}

- (void)scrollViewTapped
{
    // Retract keyboard
    [self.blankTextField resignFirstResponder];
}

#pragma mark Result View Delegate Methods

- (void)resultViewDismissed
{
    [_dimmedBackground removeFromSuperview];
    [_resultView removeFromSuperview];
}

@end
