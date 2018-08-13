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
        res <- path # once 
        res.name `shouldEqual` "John"        
      it "organises things in sets" do
        gundb <- offline
        user <-  gundb # get "users" # put {name: "John", surname: "Doe"}
        list <- gundb # get "userlist" # set user
        pure unit
      it "provides a shorthand for chaining gets" do
        gundb <- offline
        let path = gundb # path "users.jim"
        ctx <-  path # put {name: "John", surname: "Doe"}
        res <- path # once 
        res.name `shouldEqual` "John"                
      
      pending "map"
      pending "path"

