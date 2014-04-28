//
//  DropboxDownloadFileViewControlller.h
//  DropboxIntegration
//
//  Created by TheAppGuruz-iOS-101 on 26/04/14.
//  Copyright (c) 2014 TheAppGuruz-iOS-101. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxDownloadFileViewControlller : UIViewController<DBRestClientDelegate>
{
    NSMutableArray *marrDownloadData;
    DBRestClient *restClient;
}

@property (nonatomic, strong) IBOutlet UITableView *tbDownload;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, strong) NSString *loadData;

@end
