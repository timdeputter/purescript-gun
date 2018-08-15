module Test.Main where

import Prelude (Unit, bind, discard, (#), ($))
import Effect (Effect)
import Effect.Class (liftEffect)
import Test.Spec (pending, describe, it)
import Test.Spec.Assertions (shouldEqual, fail)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)
import Gun (get, offline, once, put)
import Data.Maybe (Maybe(..))

main :: Effect Unit
main = run [consoleReporter] do
  describe "purescript-gun" do
  
    
    describe "Gun api" do
    
      it "puts data into the gun db" do
        gundb <- liftEffect offline
        let p = gundb # get "users"
        ctx <-  liftEffect $ p # put {name: "John", surname: "Doe"}
        assertGunResult (pRef # once) "John"
          
      it "can chain multiple gets" do
        gundb <- liftEffect offline
        let p = gundb # get "users" # get "friends"
        ctx <-  liftEffect $ p # put {name: "John", surname: "Doe"}
        assertGunResult (pRef # once) "John"
          
      it "can go back on the chain" do
        gundb <- liftEffect offline
        let p = gundb # get "users" # get "friends" # get "honks" # back NumberOfHops 2
        let pRef = gundb # get "users"
        ctx <-  liftEffect $ p # put {name: "John", surname: "Doe"}
        assertGunResult (pRef # once) "John"
        
      pending "map"
      pending "path"
      

assertGunResult :: forall r. Aff (Maybe {name :: String | r}) -> String -> Aff Unit
assertGunResult aff name = aff >>= \res -> bound res name
  where
  bound :: forall r. Maybe {name :: String | r} -> String -> Aff Unit
  bound Just gunVal expectedName = gunVal.data.name `shouldEqual` expectedName
  bound Nothing _ = fail "No result"

