"use strict";

// module Gun

var Gun = require('gun/gun');

var Maybe = require('Data.Maybe');

exports.syncWithPeer = function (url) {
  return function () {
    return Gun(url);
  };
};

exports.on = function (handler) {
  return function (ctx) {
    return function() {
      ctx.on(function(data,key){
        return handler(data)(key)();
      });
    };
  };
};

exports.syncWithPeers = function (urls) {
  return function () {
    return Gun(urls);
  };
};

exports.offline = function () {
  console.log('offline');
  return Gun();
};

exports._get = function (pathElements) {
  return function (ctx){
    var arrayLength = pathElements.length;
    for (var i = 0; i < arrayLength; i++) {
      console.log('get');
      ctx = ctx.get(pathElements[i]);
    }
    return ctx;
  };
};

exports.map = function (ctx) {
  console.log('map');
  return ctx.map();
};

exports.mapAndFilter = function (filter) {
  return function (ctx){
    console.log('mapAndFilter');
    return ctx.map(filter);
  };
};

exports.put = function (data) { 
  return function (ctx){
    return function () {
      console.log('put');
      return ctx.put(data);
    };
  };
};

exports.set = function (ref) { 
  return function (ctx){
    return function () {
      console.log('set');
      return ctx.set(ref);
    };
  };
};

exports._once = function (ctx) { 
  return function (onError, onSuccess) { 
    var canceled = false;
    console.log('once');
    ctx.once(function(data, key){
      if(!canceled) {
        if(data === undefined){
          onSuccess(Maybe.Nothing.value0);
        } else{
          onSuccess(Maybe.Just.create({data: data, key: key}));
        }
      }
    });
    return function (cancelError, cancelerError, cancelerSuccess) {
      canceled = true;
      cancelerSuccess();
    };
  };
};
