exports.syncWithPeer = function (url) {
  return function () {
    return Gun(url);
  };
};
