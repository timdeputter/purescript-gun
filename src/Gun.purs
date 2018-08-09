module Gun where

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat
import Data.Maybe (Maybe)
import Control.Semigroupoid ((<<<))



foreign import data GunDb :: Type

foreign import data GunChainCtx :: Type


--Gun(options)
-- Used to create a new gun database instance.

foreign import syncWithPeer :: String -> Effect GunDb

foreign import syncWithPeers :: Array String -> Effect GunDb


-- gun.get(key)
-- Where to read data from.
class Getable a where
  get :: a -> String -> GunChainCtx

instance getGunDb :: Getable GunDb where
  get = getOnGunDb

instance getGunChainCtx :: Getable GunChainCtx where
  get = getOnChain 

foreign import getOnGunDb :: GunDb -> String -> GunChainCtx

foreign import getOnChain :: GunChainCtx -> String -> GunChainCtx


-- gun.back(amount)
-- Move up to the parent context on the chain.
data GoBack = Root | NumberOfHops Int

foreign import back :: GunChainCtx -> GoBack -> GunChainCtx


-- gun.put(data, callback) 
-- Save data into gun, syncing it with your connected peers.
foreign import put :: forall a. GunChainCtx -> a -> Effect GunChainCtx


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
foreign import map :: forall a. GunChainCtx -> (a -> Boolean) -> GunChainCtx
