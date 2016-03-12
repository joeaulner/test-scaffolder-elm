module Main where

import Html exposing (Html)
import Signal exposing (Signal)
import Scaffolder


main : Signal Html
main =
    let
        actions = Scaffolder.actions
    in
        Signal.map
            (Scaffolder.view actions.address)
            Scaffolder.model