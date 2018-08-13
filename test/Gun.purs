module Test.Main where

import Prelude
import Effect (Effect)
import Test.Spec (pending, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)
import Gun

main :: Effect Unit
main = run [consoleReporter] do
  describe "purescript-gun" do
    describe "Gun api" do
      it "puts data into the gun db" do
        gundb <- offline
        let path = gundb # get "users"
        ctx <-  path # put {name: "John", surname: "Doe"}
        res <- once 
        res.name `shouldEqual` "John"        
      pending "set"
      pending "map"
      pending "path"

