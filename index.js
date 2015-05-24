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
var exec = require('child_process').exec;

function puts(error, stdout, stderr) {
  sys.puts(stdout)
  mainWindow.webContents.send('ping', stdout);
}
exec("./build_env.sh", puts);
  });

ipc.on('edit-vagrant-vars',function(){
// load form populated with json data about vagrant
});

ipc.on('edit-drupal-vars',function(){
  // load form populated with json data about drupal
  // try to use angular form
  mainWindow.loadUrl('file://'+__dirname+'/drupal_vars.html');

});
