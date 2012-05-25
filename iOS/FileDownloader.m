//
//  FileDownload.m
//  cordova2
//
//  Created by Julien Bouquillon on 25/05/12.
//  Copyright (c) 2012 revolunet. All rights reserved.
//

#import "FileDownload.h"

// some contants
// NSString * const DEFAULT_OUTPUT_PATH = @"/Documents";

@implementation FileDownload

// Initializers
-(id)initWithPathAndDelegate:(NSString *)inUrl path:(NSString *)inPath delegate:(id<FileDownloadDelegate>)inDelegate
{
    if (self = [super init])
    {
        progress.status = idle;
        progress.progress = 0;
        _url = [NSURL URLWithString:inUrl];
        delegate = inDelegate; 
        _outPath = [inPath retain];
        if (_outPath == nil) {
            _outPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        }
        [_outPath retain];
        [self updateFileName];
        [self startDownload];
    }
    return self;
}
-(id)initWithDelegate: (NSString *)inUrl delegate:(id<FileDownloadDelegate>)inDelegate
{
    return [self initWithPathAndDelegate:inUrl path:nil delegate:inDelegate];
}
-(id)initWithPath: (NSString *)inUrl path:(NSString *)inPath 
{
    return [self initWithPathAndDelegate:inUrl path:inPath delegate:nil];
}
-(id)init: (NSString *)inUrl
{
    return [self initWithPathAndDelegate:inUrl path:nil delegate:nil];
}


// Methods

-(void) updateFileName
{
    _fileName = [[_url path] lastPathComponent];
    _filePath = [_outPath stringByAppendingPathComponent:_fileName];
    _isZip = ([[_fileName lowercaseString] hasSuffix:@".zip"]);
    [_fileName retain];
    [_filePath retain];
}   
-(void) startDownload
{
    NSLog(@"downloading %@", _fileName);

    _request = [ASIHTTPRequest requestWithURL:_url];
    [_request setAllowResumeForFileDownloads:YES];
    [_request setDownloadDestinationPath:_filePath];
    [_request setTemporaryFileDownloadPath:[_filePath stringByAppendingString:@".download"]];
    [_request setDelegate:self];
    [_request setDownloadProgressDelegate:self];
    [_request startAsynchronous];    
    [self updateProgress];
}   
-(void) cancel
{
    progress.status = canceled;
    if ([_request isExecuting]==YES) {
        [_request clearDelegatesAndCancel];
    }
    [self updateProgress];
}
- (void) unZip
{
    progress.status = unzip;
    progress.progress = 0.0;
    [self updateProgress];
    
    NSString *unZipPath = [_outPath stringByAppendingPathComponent:[[_fileName lastPathComponent] stringByDeletingPathExtension]];
    [SSZipArchive unzipFileAtPath:_filePath toDestination:unZipPath delegate:self];
}


// can be delegated
-(void) updateProgress
{
    if (delegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate updateProgress:progress];
        });
	}
    else {
        NSLog(@"STATUS: %i, Progress: %.2f", progress.status, progress.progress);
    }
}


// SSZipArchive delegates
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo {
    if (totalFiles > 0) {
        progress.progress = (float)fileIndex/(float)totalFiles;
        [self updateProgress];
    }
}
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath 
{
    progress.status = finished;
    progress.progress = 1.0;
    [self updateProgress];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
}


// ASI http request delegates
-(void) setProgress:(float)newProgress
{
    progress.progress = newProgress;
    [self updateProgress];
}
-(void) requestFinished:(ASIHTTPRequest *)request;
{
    if ([request responseStatusCode] == 200) {
        if (!_isZip) {
            // try to detect zip files
            NSString *contentType = [[request responseHeaders] objectForKey:@"Content-Type"];
            NSString *contentDisposition = [[request responseHeaders] objectForKey:@"Content-Disposition"];
            if ([contentType isEqualToString:@"application/zip"] || [[contentDisposition lowercaseString] hasSuffix:@".zip"] ) {
                _isZip = TRUE;
            }
        }
        if (_isZip ) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ 
                [self unZip];
            });
        }
        else {
            progress.progress = 1.0;
            progress.status = finished;
            [self updateProgress];
        }
    }
    else {
        progress.progress = 0.0;
        progress.status = error;
        [self updateProgress];
    }

}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    progress.status = error;
    [self updateProgress];
}
-(void) requestStarted:(ASIHTTPRequest *)request;
{
    progress.status = download;
    [self updateProgress];
}

// standard methods
-(void) dealloc 
{
    [_url release];
    [_fileName release];
    [_filePath release];
    [_outPath release];
    [_request release];    
    [super dealloc];    
}

@end
