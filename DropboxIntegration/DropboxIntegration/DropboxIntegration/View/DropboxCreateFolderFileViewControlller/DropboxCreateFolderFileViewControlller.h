//
//  DropboxCreateFolderFileViewControlller.h
//  DropboxIntegration
//
//  Created by TheAppGuruz-iOS-101 on 26/04/14.
//  Copyright (c) 2014 TheAppGuruz-iOS-101. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxCreateFolderFileViewControlller : UIViewController<DBRestClientDelegate, UIAlertViewDelegate>
{
    NSMutableArray *marrCreateFolderData;
    DBRestClient *restClient;
}

@property (nonatomic, strong) IBOutlet UITableView *tbCreateFolder;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, strong) NSString *loadData;

@end
