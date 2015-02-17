//
//  DropboxIntegrationViewController.m
//  DropboxIntegration
//
//  Created by TheAppGuruz-iOS-101 on 26/04/14.
//  Copyright (c) 2014 TheAppGuruz-iOS-101. All rights reserved.
//

#import "DropboxIntegrationViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxIntegrationViewController ()

@end

@implementation DropboxIntegrationViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxLoginDone) name:@"OPEN_DROPBOX_VIEW" object:nil];
}

-(void)dropboxLoginDone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"User logged in successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:viewName sender:self];
    }
}

#pragma mark - Action Methods
-(IBAction)btnUploadFilePress:(id)sender
{
    if (![[DBSession sharedSession] isLinked]) {
        viewName = @"OpenUploadFileView";
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self performSegueWithIdentifier:@"OpenUploadFileView" sender:self];
    }
}

-(IBAction)btnDownloadFilePress:(id)sender
{
    if (![[DBSession sharedSession] isLinked]) {
        viewName = @"OpenDownloadFileView";
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self performSegueWithIdentifier:@"OpenDownloadFileView" sender:self];
    }
}

-(IBAction)btnCreateFolderPress:(id)sender
{
    if (![[DBSession sharedSession] isLinked]) {
        viewName = @"OpenCreateFolderView";
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self performSegueWithIdentifier:@"OpenCreateFolderView" sender:self];
    }
}

@end