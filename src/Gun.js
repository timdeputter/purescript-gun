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
