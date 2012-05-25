// revolunet 2012
// Cordova Javascript plugin implementation
var FileDownload = function() {};
FileDownload.prototype.start = function(url, success, fail, progress, outPath) {
    var key = 'f' + this.callbackIdx++;
    window.plugins.Download.callbackMap[key] = {
        success: function(result) {
            success(result);
            delete window.plugins.Download.callbackMap[key];
        },
        fail: function(result) {
            fail(result);
            delete window.plugins.Download.callbackMap[key];
        },
        progress: progress
    };
    var callback = 'window.plugins.Download.callbackMap.' + key;
    return Cordova.exec("FileDownloadPlugin.start", callback + '.success',  callback + '.fail',  callback + '.progress',  url, outPath );
};
FileDownload.prototype.callbackMap = {};
FileDownload.prototype.callbackIdx = 0;
FileDownload.prototype.status = ['idle', 'download', 'unzip', 'finished', 'canceled', 'error'];
cordova.addConstructor(function()  {
   if(!window.plugins) window.plugins = {};
   window.plugins.Download = new FileDownload();
});
// end plugin implementation