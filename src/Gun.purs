module Gun where

import Effect (Effect)


foreign import data GunDb :: Type

foreign import syncWithPeer :: String -> Effect GunDb

foreign import syncWithPeers :: Array String -> Effect GunDb

