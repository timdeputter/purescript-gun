module Gun where

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat
import Data.Maybe (Maybe)
import Control.Semigroupoid ((<<<))
import Data.Unit (Unit)



foreign import data GunDb :: Type

foreign import data GunChainCtx :: Type


--Gun(options)
-- Used to create a new gun database instance.

foreign import syncWithPeer :: String -> Effect GunDb

foreign import syncWithPeers :: Array String -> Effect GunDb

foreign import offline :: Effect GunDb


-- gun.get(key)
-- Where to read data from.
class Getable a where
  get :: String -> a -> GunChainCtx

instance getGunDb :: Getable GunDb where
  get = getOnGunDb

instance getGunChainCtx :: Getable GunChainCtx where
  get = getOnChain 

foreign import getOnGunDb :: String -> GunDb -> GunChainCtx

foreign import getOnChain :: String -> GunChainCtx -> GunChainCtx


-- gun.back(amount)
-- Move up to the parent context on the chain.
data GoBack = Root | NumberOfHops Int

foreign import back :: GoBack -> GunChainCtx -> GunChainCtx


-- gun.put(data, callback) 
-- Save data into gun, syncing it with your connected peers.
foreign import put :: forall a. a -> GunChainCtx -> Effect GunChainCtx


-- gun.once(callback, option)
-- Get the current data without subscribing to updates. Or undefined if it cannot be found.
foreign import _once :: forall a b. GunChainCtx -> EffectFnAff (Maybe { data :: a, key :: b })

once :: forall a b. GunChainCtx -> Aff (Maybe { data :: a, key :: b })
once = fromEffectFnAff <<< _once


-- gun.set(data, callback)
-- Add a unique item to an unordered list.
foreign import set :: GunChainCtx -> GunChainCtx -> Effect GunChainCtx


-- gun.map(callback)
-- Map iterates over each property and item on a node, passing it down the chain, 
-- behaving like a forEach on your data. It also subscribes to every item as well 
-- and listens for newly inserted items. 
foreign import map :: GunChainCtx -> GunChainCtx

foreign import mapAndFilter :: forall a. (a -> Boolean) -> GunChainCtx -> GunChainCtx

-- gun.on(callback, option)
-- Subscribe to updates and changes on a node or property in realtime.
foreign import on :: forall a b. (a -> b -> Effect Unit) -> GunChainCtx -> Effect GunChainCtx

