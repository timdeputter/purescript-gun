-- | The `Gun` module provides a basic wrapper for gun.js database.
-- | see https://gun.eco for details about the gun database.
module Gun
( GunDb
, GunChainCtx
, User
, syncWithPeer
, syncWithPeers
, offline
, class Getable
, get
, put
, once
, on
, set
, map
, filter
, each
) where


import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat
import Data.Maybe (Maybe)
import Control.Semigroupoid ((<<<))
import Foreign (Foreign)

-- | Represents a reference to a gundb instance.
foreign import data GunDb :: Type

-- | Basic datastructure to chain gun operations like 'put', 'set' or 'once'
foreign import data GunChainCtx :: Type

-- | An authenticated user for a gundb instance
foreign import data User :: Type


-- | Creates a new gun database instance, and syncs the data with the given peer.
foreign import syncWithPeer :: String -> Effect GunDb

-- | Creates a new gun database instance, and syncs the data with the given peers.
foreign import syncWithPeers :: Array String -> Effect GunDb

-- | Creates a new local gun database instance, without syncing with any peers.
foreign import offline :: Effect GunDb


-- | A Typeclass which allows getting data from different sources.
-- |
-- | The `get` function takes a path either as a String or as an Array of Strings
-- | and returns a `GunChainCtx`.
-- | `get` can be called on a `GunDb` instance or a `User`
class Getable a b where
  get :: a -> b -> GunChainCtx

instance getStringFromGunDb :: Getable String GunDb where
  get path db = _getOnGunDb [path] db

instance getStringArrayFromGunDb :: Getable (Array String) GunDb where
  get = _getOnGunDb

instance getStringFromUser :: Getable String User where
  get path db = _getOnUser [path] db

instance getStringArrayFromUser :: Getable (Array String) User where
  get = _getOnUser

foreign import _getOnGunDb :: Array String -> GunDb -> GunChainCtx

foreign import _getOnUser :: Array String -> User -> GunChainCtx


-- | Save data into gun, syncing it with your connected peers.
foreign import put :: forall a. a -> GunChainCtx -> Effect GunChainCtx


-- | Get the current data without subscribing to updates. Or `Nothing` if it cannot be found.
once :: GunChainCtx -> Aff (Maybe { data :: Foreign, key :: Foreign })
once = fromEffectFnAff <<< _once

foreign import _once :: GunChainCtx -> EffectFnAff (Maybe { data :: Foreign, key :: Foreign })


-- | Loads a complete graph at once
load :: Int -> GunChainCtx -> Aff (Maybe Foreign)
load = fromEffectFnAff <<< _load

foreign import _load :: Int -> GunChainCtx -> EffectFnAff (Maybe Foreign)


-- | Add a unique item to an unordered list.
foreign import set :: GunChainCtx -> GunChainCtx -> Effect GunChainCtx


-- | Map iterates over each property and item on a node, passing it down the chain,
-- | transforming the data with the given function. It also subscribes to every item as well
-- | and listens for newly inserted items.
foreign import map :: (Foreign -> Foreign) -> GunChainCtx -> GunChainCtx


-- | Filter iterates over each property and item on a node, passing it down the chain,
-- | filtering the data with the given function. It also subscribes to every item as well
-- | and listens for newly inserted items.
foreign import filter :: (Foreign -> Boolean) -> GunChainCtx -> GunChainCtx


-- | Each iterates over each property and item on a node, passing it down the chain.
-- | It also subscribes to every item as well
-- | and listens for newly inserted items.
foreign import each ::GunChainCtx -> GunChainCtx


-- | Subscribe to updates and changes on a node or property in realtime.
on :: GunChainCtx -> Aff { data :: Foreign, key :: Foreign }
on = fromEffectFnAff <<< _on

foreign import _on ::  GunChainCtx -> EffectFnAff { data :: Foreign, key :: Foreign }
