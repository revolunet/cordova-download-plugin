//
//  FileDownloader.h
//  cordova2
//
//  Created by Julien Bouquillon on 25/05/12.
//  Copyright (c) 2012 revolunet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SSZipArchive.h"

typedef enum {
    idle,
    download,
    unzip,
    finished,
    canceled,
    error
} Status;

struct Progress {
    Status status;              // download status (enum)
    float progress;             // operation progress (0.0-1.0)
} Progress;


@protocol FileDownloadDelegate
-(void) updateProgress: (struct Progress) progress; // if you want to keep track of progress, implement this
@end

@interface FileDownload  : NSObject <SSZipArchiveDelegate> 
{
    // private
  	NSURL *_url;                 // full url of the ressource
  	NSString *_outPath;          // download path
  	NSString *_filePath;         // local path of the resource
  	NSString *_fileName;         // filename only
    BOOL _isZip;                 // indicate if zip file, will be auto-unzipped
    ASIHTTPRequest *_request;    // request object
    struct Progress progress;    // operations progress

    // delegate
    id <FileDownloadDelegate> delegate;
}

// exposed init methods
-(id)init: (NSString *)inUrl;                                                                                                 // full automatic; default: /Documents
-(id)initWithPath: (NSString *)inUrl path:(NSString *)inPath;                                                                 // specify output path
-(id)initWithDelegate: (NSString *)inUrl delegate:(id<FileDownloadDelegate>)inDelegate;                                     // specify delegate
-(id)initWithPathAndDelegate: (NSString *)inUrl path:(NSString *)inPath delegate:(id<FileDownloadDelegate>)inDelegate;      // specify ouput path and delegate

@end


