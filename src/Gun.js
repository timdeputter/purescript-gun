"use strict";

// module Gun

var Gun = require('gun');

var Maybe = require('Data.Maybe');

exports.syncWithPeer = function (url) {
  return function () {
    return Gun(url);
  };
};

exports._on = function (ctx) { 
  return function (onError, onSuccess) { 
    var canceled = false;
    ctx.on(function(data, key){
      if(!canceled) {
        handler({data: data, key: key})();
      }
    });
    return function (cancelError, cancelerError, cancelerSuccess) {
      canceled = true;
      cancelerSuccess();
    };
  };
};

exports.syncWithPeers = function (urls) {
  return function () {
    return Gun(urls);
  };
};

exports.offline = function () {
  return Gun();
};

exports._get = function (pathElements) {
  return function (ctx){
    var arrayLength = pathElements.length;
    for (var i = 0; i < arrayLength; i++) {
      ctx = ctx.get(pathElements[i]);
    }
    return ctx;
  };
};

exports.map = function (ctx) {
  return ctx.map();
};

exports.mapAndFilter = function (filter) {
  return function (ctx){
    return ctx.map(filter);
  };
};

exports.put = function (data) { 
  return function (ctx){
    return function () {
      return ctx.put(data);
    };
  };
};

exports.set = function (ref) { 
  return function (ctx){
    return function () {
      return ctx.set(ref);
    };
  };
};

exports._once = function (ctx) { 
  return function (onError, onSuccess) { 
    var canceled = false;
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
