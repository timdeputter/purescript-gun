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

exports.get = function (gundb, name) {
  return function () {
    return gundb.get(name);
  };
};

exports.back = = function (gundb, count) {
  return function () {
    if( count instanceof exports.NumberOfHops){
      return gundb.back(count.value0);
    }
    return gundb.back(-1);
  };
};

