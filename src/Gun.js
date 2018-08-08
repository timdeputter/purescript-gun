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
