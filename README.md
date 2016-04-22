Cordova Download Plugin
====

:warning: DEPRECATED, use https://github.com/apache/cordova-plugin-file-transfer instead

Simple plugin allows native downloads from javascript and get notified via a progress callback.

The plugin is known to work from cordova 1.7 to 2.0


 - multiple concurrent downloads
 - progress callbacks for downloads and unzip operations
 - auto detect ZIP files, unzip then delete original zip
 - files are extracted in the `NSDocumentDirectory`of the application but you can override
 - iOS only at the moment
 
Proudly made by the [revolunet team][2]


Example :
--

    window.plugins.Download.start(
        // File to download
        'https://github.com/revolunet/incubator-cordova-js/zipball/master', 
        // success callback
        function() { $(#'progress').html("SUCCESS"); },
        // failure callback
        function() { $(#'progress').html("FAILURE"); },
        // progress callback
        function(infos) { 
            var statusText = window.plugins.Download.status[infos.status];
            $(#'progress').html =  statusText + ' ' + infos.progress;
        }
        // here you can specify an absolute output directory where to place the file
        // eg: '/Documents/mydownloads'
    );

There is a full working example at `index.html`.

Installation :
--

 - meet dependencies
 - add FileDownload and FileDownloadPlugin to your iOS project
 - add a reference to the plugin in your `Cordova.plist`, as `name=FileDownloadPlugin, value=FileDownloadPlugin`


Dependencies :
--

 - [ASI http request][0]
 - [SSZipArchive][1]
 - The HTML demo page use [Lea Verou Progress polyfill][3] because YES, &lt;progress&gt; is not yet implemented in Safari


Todo :
--

 - ~~Use `content-type` HTTP header instead of extension to detect ZIPs~~

 [0]: https://github.com/pokeb/asi-http-request/tree
 [1]: https://github.com/samsoffes/ssziparchive
 [2]: http://revolunet.com
 [3]: http://lea.verou.me/polyfills/progress/
