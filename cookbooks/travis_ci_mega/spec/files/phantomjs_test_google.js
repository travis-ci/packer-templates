var page = require('webpage').create();
page.open('http://www.google.com', function(status) {
  console.log("Status: " + status);
  phantom.exit();
});

