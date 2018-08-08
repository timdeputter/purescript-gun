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

exports.back = function (gundb, count) {
  return function () {
    if(count instanceof exports.NumberOfHops){
      return gundb.back(count.value0);
    }
    return gundb.back(-1);
  };
};

exports.put = function (ctx, data) { 
  return function () {
    return ctx.put(data);
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
