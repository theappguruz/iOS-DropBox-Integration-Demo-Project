//
//  DropboxCreateFolderFileViewControlller.m
//  DropboxIntegration
//
//  Created by TheAppGuruz-iOS-101 on 26/04/14.
//  Copyright (c) 2014 TheAppGuruz-iOS-101. All rights reserved.
//

#import "DropboxCreateFolderFileViewControlller.h"
#import "MBProgressHUD.h"
#import "DropboxCell.h"

@interface DropboxCreateFolderFileViewControlller ()

@end

@implementation DropboxCreateFolderFileViewControlller

@synthesize tbCreateFolder;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!loadData) {
        loadData = @"";
    }
    
    marrCreateFolderData = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
}

#pragma mark - Dropbox Methods
- (DBRestClient *)restClient
{
	if (restClient == nil) {
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
	return restClient;
}

-(void)fetchAllDropboxData
{
    [self.restClient loadMetadata:loadData];
}

-(void)createFolderInDropBox:(NSString *)filePath
{
    [self.restClient createFolder:filePath];
}

#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            [marrCreateFolderData addObject:data];
        }
    }
    [tbCreateFolder reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tbCreateFolder reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - DBRestClientDelegate Methods for Create Folder
- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"Folder created successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrCreateFolderData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    
    DBMetadata *metadata = [marrCreateFolderData objectAtIndex:indexPath.row];
    
    [cell.btnIcon setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.btnIcon addTarget:self action:@selector(btnCreateFolderPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblTitle.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [marrCreateFolderData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DropboxCreateFolderFileViewControlller *dropboxCreateFolderFileViewControlller = [storyboard instantiateViewControllerWithIdentifier:@"DropboxCreateFolderFileViewControlller"];
    dropboxCreateFolderFileViewControlller.loadData = metadata.path;
    [self.navigationController pushViewController:dropboxCreateFolderFileViewControlller animated:YES];
}

#pragma mark - Action Methods
-(void)btnCreateFolderPress:(id)sender
{
    UIButton *btnCreateFolder = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter Folder Name : " delegate:self cancelButtonTitle:@"Create" otherButtonTitles:@"Cancel", nil];
    alert.accessibilityLabel = [btnCreateFolder titleForState:UIControlStateDisabled];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show]; alert = nil;
}

#pragma mark - AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(createFolderInDropBox:) withObject:[alertView.accessibilityLabel stringByAppendingPathComponent:[alertView textFieldAtIndex:0].text] afterDelay:.1];
    }
}

@end