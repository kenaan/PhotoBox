//
//  LoginViewController.m
//  PhotoBox
//
//  Created by Nico Prananta on 9/5/13.
//  Copyright (c) 2013 Touches. All rights reserved.
//

#import "LoginViewController.h"

#import "ConnectionManager.h"
#import "NSString+Additionals.h"
#import "UIView+Additionals.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	
    [self.backgroundImageView addTransparentGradientWithStartColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnImage:(id)sender {
    [self.view endEditing:YES];
}

- (void)tryTapped:(id)sender {
    [[ConnectionManager sharedManager] connectAsTester];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!textField.text || textField.text.length == 0) {
        [textField setText:@".trovebox.com"];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@".trovebox.com"]) {
        UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:0];
        UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
        [textField setSelectedTextRange:newSelectedRange];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isValidURL]) {
        [textField setEnabled:NO];
        [self.activityView startAnimating];
        [self.view endEditing:YES];
        [[ConnectionManager sharedManager] startOAuthAuthorizationWithServerURL:[textField.text stringWithHttpSchemeAddedIfNeeded]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Server", nil) message:NSLocalizedString(@"Please provide a valid host URL", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
    }
    return YES;
}

@end
