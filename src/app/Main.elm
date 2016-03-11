module Main where

import Html exposing (Html)
import Html.Attributes as Attr


main : Html
main =
    Html.div
        [ Attr.class "card-panel teal lighten-2" ]
        [ Html.h2 [] [ Html.text "Hello World!" ] ]
