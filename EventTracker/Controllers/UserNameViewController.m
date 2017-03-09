//
//  UserNameViewController.m
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 PuneetKumar. All rights reserved.
//

#import "UserNameViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface UserNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.layer.borderColor = APP_THEME_COLOR.CGColor;
    self.nameTextField.layer.borderWidth = 0.5;
    self.nameTextField.layer.cornerRadius = 5.0;
    
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, self.nameTextField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    self.nameTextField.leftView = leftView;
    
    self.doneButton.layer.cornerRadius = 5.0;
    [self.doneButton setBackgroundColor:APP_THEME_COLOR];
    
    self.errorMessage.textColor = APP_THEME_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.view endEditing:true];
    if ([self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<6) {
        self.errorMessage.hidden = false;
    }else{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeNC"];
        HomeViewController *viewController = (HomeViewController *)[((UINavigationController*) navigationController).viewControllers objectAtIndex:0];
        viewController.userName = self.nameTextField.text;
        [self presentViewController:navigationController animated:true completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doneButtonPressed:self.doneButton];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.errorMessage.hidden = true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:true];
}

@end
