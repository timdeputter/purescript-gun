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
  return Gun();
};

exports.getOnGunDb = function (name) {
  return function (ctx){
    return ctx.get(name);
  };
};

exports.getOnChain = function (name) {
  return function (ctx){
    return ctx.get(name);
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

exports.back = function (count) {
  return function (gundb){
    if(count instanceof exports.NumberOfHops){
      return gundb.back(count.value0);
    }
    return gundb.back(-1);
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
