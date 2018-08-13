module Gun.Sea where

import Gun (GunChainCtx, GunDb)
import Effect.Aff (Aff)
import Data.Function.Uncurried (Fn3, runFn3)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import _create :: Fn3 GunDb String String (EffectFnAff GunChainCtx)

foreign import _auth :: Fn3 GunDb String String (EffectFnAff GunChainCtx)

auth :: GunDb -> String -> String -> Aff GunChainCtx 
auth gundb usr pwd = fromEffectFnAff (runFn3 _auth gundb usr pwd)

create :: GunDb -> String -> String -> Aff GunChainCtx 
create  gundb usr pwd = fromEffectFnAff (runFn3 _create gundb usr pwd)
