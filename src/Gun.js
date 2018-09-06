"use strict";

// module Gun

var Gun = require('gun');

var Maybe = require('Data.Maybe');

exports.syncWithPeer = function (url) {
  return function () {
    return Gun(url);
  };
};

exports._on = function (handler) {
  return function (ctx) {
    return function() {
      ctx.on(function(data,key){
        return handler({data: data, key: key})();
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

exports._once = function (handler) {
  return function (ctx) {
    return function() {
      ctx.on(function(data,key){
        if(data === undefined){
          return handler(Maybe.Nothing.value0)();
        } else{
          return handler(Maybe.Just.create({data: data, key: key}))();
        }
      });
    };
  };
};

