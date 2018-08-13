module Gun.Sea where

import Effect (Effect)


foreign import _create :: GunDb -> String -> String -> EffectFnAff User

foreign import _auth :: GunDb -> String -> String -> EffectFnAff User

auth :: GunDb -> String -> String -> Aff GunChainCtx 
auth = fromEffectFnAff <<< _auth

create :: GunDb -> String -> String -> Aff GunChainCtx 
create = fromEffectFnAff <<< _create
