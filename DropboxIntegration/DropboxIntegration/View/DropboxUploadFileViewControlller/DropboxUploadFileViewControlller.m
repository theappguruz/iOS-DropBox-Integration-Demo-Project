//
//  DropboxUploadFileViewControlller.m
//  DropboxIntegration
//
//  Created by TheAppGuruz-iOS-101 on 26/04/14.
//  Copyright (c) 2014 TheAppGuruz-iOS-101. All rights reserved.
//

#import "DropboxUploadFileViewControlller.h"
#import "DropboxCell.h"
#import "MBProgressHUD.h"

@interface DropboxUploadFileViewControlller ()

@end

@implementation DropboxUploadFileViewControlller

@synthesize tbUpload;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!loadData) {
        loadData = @"";
    }
    
    marrUploadData = [[NSMutableArray alloc] init];
    
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

-(void)uploadFileToDropBox:(NSString *)filePath
{
    [self.restClient uploadFile:@"FileName.png" toPath:filePath withParentRev:@"" fromPath:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"jpg"]];
}

#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            [marrUploadData addObject:data];
        }
    }
    [tbUpload reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tbUpload reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - DBRestClientDelegate Methods for Upload Data
-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"File uploaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
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
    return [marrUploadData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    
    DBMetadata *metadata = [marrUploadData objectAtIndex:indexPath.row];
    
    [cell.btnIcon setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.btnIcon addTarget:self action:@selector(btnUploadPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblTitle.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [marrUploadData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DropboxUploadFileViewControlller *dropboxUploadFileViewControlller = [storyboard instantiateViewControllerWithIdentifier:@"DropboxUploadFileViewControlller"];
    dropboxUploadFileViewControlller.loadData = metadata.path;
    [self.navigationController pushViewController:dropboxUploadFileViewControlller animated:YES];
}

#pragma mark - Action Methods
-(void)btnUploadPress:(id)sender
{
    UIButton *btnUpload = (UIButton *)sender;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(uploadFileToDropBox:) withObject:[btnUpload titleForState:UIControlStateDisabled] afterDelay:.1];
}

@end