// ipc communication with browser process in index.js
var ipc = require("ipc");

window.onload = function(){

// ipc bindings to send messages to index.js
document.getElementById('build').onclick = function(){
  ipc.send('build');
}

document.getElementById('halt_containers').onclick = function(){
  ipc.send('halt_containers');
}

document.getElementById('destroy_containers').onclick = function(){
  ipc.send('destroy_containers');
}

document.getElementById('reload_db').onclick = function(){
  ipc.send('reload_db');
}

// receive ipc messages from index.js
ipc.on('rcv_stdout', function(message) {
  var output = document.getElementById("stdout");
  var content = document.createTextNode(message);
  output.appendChild(content);
  // scroll to bottom of stdout so most up to date is on the page
  var objDiv = document.getElementById("stdout");
  objDiv.scrollTop = objDiv.scrollHeight;
});

// in page js stuff
document.getElementById('clear_output').onclick = function(){
  document.getElementById("stdout").innerHTML = 'Output cleared.&#10;&#13;';
  event.preventDefault();
}
/*
var throb = Throbber({
    size: 32,
    fade: 1000, // fade duration, will also be applied to the fallback gif
    fallback: 'ajax-loader.gif',
    rotationspeed: 0,
    lines: 14,
    strokewidth: 1.8,
    alpha: 0.4 // this will also be applied to the gif
}).appendTo( document.getElementById( 'destroy_containers' ) ).start();
*/
}
