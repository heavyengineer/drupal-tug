var ipc = require("ipc");

window.onload = function(){
document.getElementById('build').onclick = function(){
  ipc.send('build');
}

document.getElementById('edit-vagrant-vars').onclick = function(){
  ipc.send('edit-vagrant-vars');
}

document.getElementById('edit-drupal-vars').onclick = function(){
  ipc.send('edit-drupal-vars');
}

}

/* try using node commands here
var jf = require('jsonfile')
    var util = require('util')

    var file = './config/env_variables.json'

    jf.readFile(file, function(err, obj) {
      console.log(util.inspect(obj))
    })
    */
