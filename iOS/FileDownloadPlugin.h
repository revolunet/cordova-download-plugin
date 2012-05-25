//
//  FileDownloaderPlugin.h
//  cordova2
//
//  Created by Julien Bouquillon on 25/05/12.
//  Copyright (c) 2012 revolunet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "FileDownload.h"

@interface FileDownloadPlugin : CDVPlugin {
	NSMutableDictionary* callbackIds;
}
@property (nonatomic, retain) NSMutableDictionary* callbackIds;
@end

@interface FileDownloadPluginDelegate : NSObject <FileDownloadDelegate> {
	NSString* successCallback;
	NSString* failCallback;
	NSString* progressCallback;
	FileDownloadPlugin* plugin;
	int uploadIdx;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;
@property (nonatomic, copy) NSString* progressCallback;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) FileDownloadPlugin* plugin;
@end;