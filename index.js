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
  mainWindow = new BrowserWindow({width: 1280, height: 800});
  mainWindow.loadUrl('file://'+__dirname+'/index.html');
  mainWindow.openDevTools();
  mainWindow.on('closed',function(){
    mainWindow = null;
  })

  //var win=mainWindow;
  //var dialog = require('dialog');
  //var sql_file = dialog.showOpenDialog({ properties: [ 'openFile']});
//console.log(sql_file)

})

// communication channel with renderer process
var ipc = require("ipc");
var sys = require('sys');
var spawn = require('child_process').spawn;

ipc.on('build',function(){

  var build = spawn('./build_env.sh');

    // add a 'data' event listener for the spawn instance
    build.stdout.on('data', function(data) {
      rcv_stdout(data)
      });

    // when the spawn child process exits, check if there were any errors
    build.on('exit', function(code) {
      if (code != 0) {
          rcv_stdout('Failed' + code + '.\n\r')
      }else{
        rcv_stdout('Job completed Successfully.\n\r')
      }
    });
  });

ipc.on('halt_containers',function(){
// load form populated with json data about vagrant
var halt = spawn('./Thalt.sh');

  // add a 'data' event listener for the spawn instance
  halt.stdout.on('data', function(data) {
    rcv_stdout(data)
    });

  // when the spawn child process exits, check if there were any errors
  halt.on('exit', function(code) {
    if (code != 0) {
        rcv_stdout('Failed' + code + '.\n\r')
    }else{
      rcv_stdout('Job completed Successfully.\n\r')
    }
  })
})

ipc.on('destroy_containers',function(){

  // load form populated with json data about vagrant
  var destroy = spawn('./Tdestroy.sh')

    // add a 'data' event listener for the spawn instance
    destroy.stdout.on('data', function(data) {
      rcv_stdout(data)
      });

    // when the spawn child process exits, check if there were any errors
    destroy.on('exit', function(code) {
        if (code != 0) {
            rcv_stdout('Failed' + code + '.\n\r')
        }else{
          rcv_stdout('Job completed Successfully.\n\r')
        }
    });
});

/** sends data to the conatainer on the renderer process page */
function rcv_stdout(data){
  mainWindow.webContents.send('rcv_stdout', data.toString('utf8'))
  console.log(data.toString('utf8'))
}
