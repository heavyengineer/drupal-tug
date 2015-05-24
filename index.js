var app = require('app');
var shelljs = require('shelljs');
var BrowserWindow = require('browser-window');

require('crash-reporter').start();

var mainWindow = null;

app.on('window-all-closed',function(){
  if(process.platform != 'darwin')
  app.quit();
});

app.on('ready',function(){
  mainWindow = new BrowserWindow({width: 800, height: 600});
  mainWindow.loadUrl('file://'+__dirname+'/index.html');
//  mainWindow.openDevTools();

  mainWindow.on('closed',function(){
    mainWindow = null;
  })
})

// communication channel with renderer process
var ipc = require("ipc");

ipc.on('build',function(){

var sys = require('sys');

/*
var exec = require('child_process').exec;

function puts(error, stdout, stderr) {
  sys.puts(stdout)
  mainWindow.webContents.send('ping', stdout);
}
exec("./build_env.sh", puts);*/
// execute curl using child_process' spawn function
  //var yoink = require('child_process').spawn;
  var spawn = require('child_process').spawn;
  var build = spawn('./build_env.sh');

    // add a 'data' event listener for the spawn instance
    build.stdout.on('data', function(data) {
      mainWindow.webContents.send('build', data.toString('utf8'))
      console.log(data.toString('utf8'))
      });
    // add an 'end' event listener to close the writeable stream
    build.stdout.on('end', function(data) {
        //file.end();
        console.log('ended');
    });
    // when the spawn child process exits, check if there were any errors and close the writeable stream
    build.on('exit', function(code) {
        if (code != 0) {
            console.log('Failed: ' + code);
        }
    });



  });

ipc.on('edit-vagrant-vars',function(){
// load form populated with json data about vagrant
});

ipc.on('edit-drupal-vars',function(){
  // load form populated with json data about drupal
  mainWindow.loadUrl('file://'+__dirname+'/drupal_vars.html');
});
