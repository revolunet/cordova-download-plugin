Cordova Download Plugin
====

Simple plugin allows native downloads from javascript and get notified via a progress callback.

 - iOS only at the moment
 - Proudly made by the [revolunet team][2]

Features :
--

 - multiple concurrent downloads
 - progress callback for download and unzip
 - auto detect ZIP files, unzip them and delete original zip


Example :
--

    window.plugins.Download.start(
        // File to download
        'https://github.com/revolunet/incubator-cordova-js/zipball/master', 
        // success callback
        function() { document.getElementById('progress').innerHTML = "SUCCESS"; },
        // failure callback
        function() { document.getElementById('progress').innerHTML = "FAILURE"; },
        // progress callback
        function(infos) { 
            document.getElementById('progress').innerHTML = FileDownloader.status[infos.status] + ' ' + infos.progress;
        }
    );


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

 - Use `content-type` HTTP header instead of extension to detect ZIPs

 [0]: https://github.com/pokeb/asi-http-request/tree
 [1]: https://github.com/samsoffes/ssziparchive
 [2]: http://revolunet.com
 [3]: http://lea.verou.me/polyfills/progress/