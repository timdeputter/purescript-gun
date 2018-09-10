module Gun.Sea where

import Prelude (Unit)
import Gun (GunDb, User)
import Effect.Aff (Aff)
import Data.Function.Uncurried (Fn3, runFn3)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)


foreign import _create :: Fn3 GunDb String String (EffectFnAff Unit)

foreign import _auth :: Fn3 GunDb String String (EffectFnAff User)

auth :: String -> String -> GunDb -> Aff User 
auth usr pwd gundb = fromEffectFnAff (runFn3 _auth gundb usr pwd)

create :: String -> String -> GunDb -> Aff Unit 
create  usr pwd gundb = fromEffectFnAff (runFn3 _create gundb usr pwd)
