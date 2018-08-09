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

exports.getOnGunDb = function (ctx, name) {
  return function () {
    return ctx.get(name);
  };
};

exports.getOnChain = function (ctx, name) {
  return function () {
    return ctx.get(name);
  };
};

exports.map = function (ctx) {
  return function () {
    return ctx.map();
  };
};

exports.mapAndFilter = function (ctx, filter) {
  return function () {
    return ctx.map(filter);
  };
};

exports.back = function (gundb, count) {
  return function () {
    if(count instanceof exports.NumberOfHops){
      return gundb.back(count.value0);
    }
    return gundb.back(-1);
  };
};

exports.path = function (ctx, path) {
  return function () {
    return ctx.path(path);
  };
};

exports.paths = function (ctx, path) {
  return function () {
    return ctx.path(path);
  };
};

exports.put = function (ctx, data) { 
  return function () {
    return ctx.put(data);
  };
};

exports.set = function (ctx, ref) { 
  return function () {
    return ctx.set(ref);
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
