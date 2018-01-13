/*
 Copyright (c) 2016, Oracle and/or its affiliates.
 All rights reserved.
 */
var express = require('express');
var serveStatic = require('serve-static');
var morgan = require('morgan');
var bodyParser = require('body-parser');
var config = require(__dirname + '/config.js');
var routes = require(__dirname + '/routes/routes.js');
var app;
var oracledb = require('oracledb');

oracledb.createPool(
  config.database,
  function (err, pool) {
    if (err) {
      console.error(err.message);
    }
  }
);

app = express();

app.use(bodyParser.json());

app.use('/', serveStatic(__dirname + '/../commonClient/' + config.clientAppCodeDir + '/'));
app.use('/api/v1/', routes.router);

app.use(morgan('combined')); //logger

app.listen(config.port, function() {
    console.log('Web server listening on localhost:' + config.port);
});

