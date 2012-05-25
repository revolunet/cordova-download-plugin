//
//  FileDownloaderPlugin.m
//  cordova2
//
//  Created by Julien Bouquillon on 25/05/12.
//  Copyright (c) 2012 revolunet. All rights reserved.
//

#import "FileDownloadPlugin.h"

@implementation FileDownloadPlugin
@synthesize callbackIds = _callbackIds;

- (NSMutableDictionary*)callbackIds {
	if(_callbackIds == nil) {
		_callbackIds = [[NSMutableDictionary alloc] init];
	}
	return _callbackIds;
}
- (void) dealloc {
	[_callbackIds dealloc];
	[super dealloc];
}
- (void) start:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
    NSUInteger argc = [arguments count];
    NSString* successCallback = [arguments objectAtIndex:0];
	NSString* failCallback = [arguments objectAtIndex:1];
    NSString* progressCallback = [arguments objectAtIndex:2];
    NSString* url = [arguments objectAtIndex:3];
    
    NSString* outPath = nil;
    
    if(argc > 4) {
		outPath = [arguments objectAtIndex:4];	
	}
    
    FileDownloadPluginDelegate* delegate = [[FileDownloadPluginDelegate alloc] init];
	delegate.plugin = self;
	delegate.successCallback = successCallback;
	delegate.failCallback = failCallback;
	delegate.progressCallback = progressCallback;
    
    [[FileDownload alloc]initWithDelegate:url delegate:delegate];
}

@end


@implementation FileDownloadPluginDelegate

@synthesize successCallback, failCallback, progressCallback, responseData, plugin;

-(void)updateProgress:(struct Progress)progress
{
    if (progress.status == finished) {
        [plugin writeJavascript: [NSString stringWithFormat:@"%@({status:%d, progress:%.2f});", successCallback, progress.status, progress.progress]];
    }
    else if (progress.status == error) {
        [plugin writeJavascript: [NSString stringWithFormat:@"%@({status:%d, progress:%.2f});", failCallback, progress.status, progress.progress]];
    }
    [plugin writeJavascript: [NSString stringWithFormat:@"%@({status:%d, progress:%.2f});", progressCallback, progress.status, progress.progress]];
}

- (id) init
{
    if (self = [super init]) {
		self.responseData = [NSMutableData data];
		uploadIdx = 0;
    }
    return self;
}

- (void) dealloc
{
    [successCallback release];
    [failCallback release];
	[responseData release];
	[plugin release];
    [super dealloc];
}
@end
