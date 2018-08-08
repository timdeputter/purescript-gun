module Gun where

import Effect (Effect)


data GoBack = Root | NumberOfHops Int


foreign import data GunDb :: Type

foreign import GunChainCtx :: Type


--Gun(options)
-- Used to create a new gun database instance.

foreign import syncWithPeer :: String -> Effect GunDb

foreign import syncWithPeers :: Array String -> Effect GunDb


-- gun.get(key)
-- Where to read data from.

class Getable a where
  get :: a -> String

instance getGunDb :: Getable GunDb where
  get = getOnGunDb

instance getGunChainCtx :: Getable GunChainCtx where
  get = getOnChain 

foreign import getOnGunDb :: GunDb -> String -> GunChainCtx

foreign import getOnChain :: GunChainCtx -> String -> GunChainCtx


-- gun.back(amount)
-- Move up to the parent context on the chain.
foreign import back :: GunChainCtx -> GoBack -> GunChainCtx


-- gun.put(data, callback) 
-- Save data into gun, syncing it with your connected peers.
foreign import _put :: forall a. GunChainCtx -> a -> EffectFnAff Unit

put :: forall a. GunChainCtx -> a -> Aff Unit
put = fromEffectFnAff <<< _put
