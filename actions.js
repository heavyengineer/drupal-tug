var ipc = require("ipc");

document.getElementById('build').onclick = function(){
  ipc.send('build');
}

document.getElementById('edit-vagrant-vars').onclick = function(){
  ipc.send('edit-vagrant-vars');
}

document.getElementById('edit-drupal-vars').onclick = function(){
  ipc.send('edit-drupal-vars');
}
