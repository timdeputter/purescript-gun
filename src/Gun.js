"use strict";

// module Gun

var Gun = require('gun/gun');

exports.syncWithPeer = function (url) {
  return function () {
    return Gun(url);
  };
};

exports.syncWithPeers = function (urls) {
  return function () {
    return Gun(urls);
  };
};

exports.offline = function (urls) {
  return function () {
    return Gun(urls);
  };
};

exports.getOnGunDb = function (name) {
  return function (ctx){
    return function () {
      return ctx.get(name);
    };
  };
};

exports.getOnChain = function (name) {
  return function (ctx){
    return function () {
      return ctx.get(name);
    };
  };
};

exports.map = function (ctx) {
  return function () {
    return ctx.map();
  };
};

exports.mapAndFilter = function (filter) {
  return function (ctx){
    return function () {
      return ctx.map(filter);
    };
  };
};

exports.back = function (count) {
  return function (gundb){
    return function () {
      if(count instanceof exports.NumberOfHops){
        return gundb.back(count.value0);
      }
      return gundb.back(-1);
    };
  };
};

exports.path = function (path) {
  return function (ctx){
    return function () {
      return ctx.path(path);
    };
  };
};

exports.paths = function (path) {
  return function (ctx){
    return function () {
      return ctx.path(path);
    };
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
    ctx.once(function(data){
      if(!canceled) {
        if(data === undefined){
          onSuccess(exports.Nothing.value0);
        } else{
          onSuccess(exports.Just.create(data));
        }
      }
    });
    return function (cancelError, cancelerError, cancelerSuccess) {
      canceled = true;
      cancelerSuccess();
    };
  };
};
