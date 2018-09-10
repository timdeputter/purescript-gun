module Test.Main where

import Prelude (Unit, bind, discard, (#), ($), (>>=))
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual, fail, shouldContain)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)
import Gun (get, offline, once, put, set, on, each)
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

      it "can organize multiple objects in sets" do
        gundb <- liftEffect offline
        john <- liftEffect $ gundb # get "john" # put {name: "John"}
        jim <- liftEffect $ gundb # get "jim" # put {name: "jim"}
        _ <- liftEffect $ gundb # get "users" # set john
        _ <- liftEffect $ gundb # get "users" # set jim
        assertOnce (gundb # get "users" # each # once) ["John", "jim"]

      it "allows to make subscriptions on changes" do
        gundb <- liftEffect offline
        john <- liftEffect $ gundb # get "john" # put {name: "John"}
        jim <- liftEffect $ gundb # get "jim" # put {name: "jim"}
        _ <- liftEffect $ gundb # get "users" # set john
        _ <- liftEffect $ gundb # get "users" # set jim
        assertOn (gundb # get "users" # each # on) ["John", "jim"]

assertOnce :: forall a b. Aff (Maybe {data :: {name :: String | a} | b}) -> Array String -> Aff Unit
assertOnce aff names = aff >>= \res -> bound res names
  where
  bound (Just gunVal) expectedNames = shouldContain expectedNames gunVal.data.name
  bound Nothing _ = fail "No result"

assertOn :: forall a b. Aff {data :: {name :: String | a} | b} -> Array String -> Aff Unit
assertOn aff names = aff >>= \res -> bound res names
  where
  bound gunVal expectedNames = shouldContain expectedNames gunVal.data.name


assertGunResult :: forall a b. Aff (Maybe {data :: {name :: String | a} | b}) -> String -> Aff Unit
assertGunResult aff name = aff >>= \res -> bound res name
  where
  bound :: forall c d. Maybe {data :: {name :: String | c} | d} -> String -> Aff Unit
  bound (Just gunVal) expectedName = gunVal.data.name `shouldEqual` expectedName
  bound Nothing _ = fail "No result"

