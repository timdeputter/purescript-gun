module Test.Main where

import Prelude (Unit, bind, discard, (#), ($), (>>=))
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (pending, describe, it)
import Test.Spec.Assertions (shouldEqual, fail)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)
import Gun (get, offline, once, put)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)

main :: Effect Unit
main = run [consoleReporter] do
  describe "purescript-gun" do


    describe "Gun api" do

      it "puts data into the gun db" do
        gundb <- liftEffect offline
        ctx <-  liftEffect $ gundb # get "users" # put {name: "John", surname: "Doe"}
        assertGunResult (gundb # get "users" # once) "John"

      it "allows multiple path elements" do
        gundb <- liftEffect offline
        ctx <-  liftEffect $ gundb # get ["users", "friends"] # put {name: "John", surname: "Doe"}
        assertGunResult (gundb # get ["users", "friends"] # once) "John"

      -- !!!!! HIER MUSS WARSCHEINLICH EIN REF (Effect.Ref) BENUTZT WERDEN UM ZU TESTEN !!!!
      -- it "can subscribe to changes on a chaincontext" do
      --  gundb <- liftEffect offline
      --  let p = gundb # get "users"
      --  liftEffect $ p # on handleUserChanges >>= put {name: "John", surname: "Doe"}

      pending "map"

-- !!!!! HIER MUSS WARSCHEINLICH EIN REF (Effect.Ref) BENUTZT WERDEN UM ZU TESTEN !!!!
-- handleUserChanges :: forall a. {name :: String | a} -> String -> Effect Unit
-- handleUserChanges {name} expectedName = name `shouldEqual` expectedName 

assertGunResult :: forall a b. Aff (Maybe {data :: {name :: String | a} | b}) -> String -> Aff Unit
assertGunResult aff name = aff >>= \res -> bound res name
  where
  bound :: forall c d. Maybe {data :: {name :: String | c} | d} -> String -> Aff Unit
  bound (Just gunVal) expectedName = gunVal.data.name `shouldEqual` expectedName
  bound Nothing _ = fail "No result"

