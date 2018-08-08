"use strict";

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

var get = function (ctx, name) {
  return function () {
    return ctx.get(name);
  };
};

exports.getOnGunDb = get;
exports.getOnChain = get;

exports.back = = function (gundb, count) {
  return function () {
    if( count instanceof exports.NumberOfHops){
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
