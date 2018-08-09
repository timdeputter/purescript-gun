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
foreign import _once :: forall a. GunChainCtx -> EffectFnAff (Maybe a)

once :: forall a. GunChainCtx -> Aff (Maybe a)
once = fromEffectFnAff <<< _once

-- gun.set(data, callback)
-- Add a unique item to an unordered list.
foreign import set :: forall a. GunChainCtx -> GunChainCtx -> Effect GunChainCtx
