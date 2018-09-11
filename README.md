purescript-gun [![Build Status](https://travis-ci.org/timdeputter/purescript-gun.svg?branch=master)](https://travis-ci.org/timdeputter/purescript-gun) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
==========

Purescript bindings to the [gun.js](https://gun.eco) database.


## Installation
Install purescript-gun with bower:

```sh
$ bower install purescript-gun
```

## Getting started
Use `syncWithPeer` or `syncWithPeers` to connect to gun database.
```purescript
do
  gundb -> liftEffect syncWithPeer "http://myserver.com/gun"
  ...
```

After you've got a reference to a gundb instance, define a path with gun `get` and read data with `once`
```purescript
do
  gundb -> liftEffect syncWithPeer "http://myserver.com/gun"
  data -> gundb # get ["users", "friends"] # once
  ...
```

Have a look at the test directory for more examples.



## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-gun).

## License

Check [LICENSE](LICENSE) file for more information.
