module Gun where

import Effect (Effect)


foreign import data GunDb :: Type

foreign import GunChainCtx :: Type


foreign import syncWithPeer :: String -> Effect GunDb

foreign import syncWithPeers :: Array String -> Effect GunDb


foreign import get :: GunDb -> String -> GunChainCtx

foreign import back :: GunDb -> Int -> GunChainCtx
