module Main where

import Html exposing (Html)
import Html.Attributes as Attr


main : Html
main =
    Html.div
        [ Attr.class "mui-appbar" ]
        [ Html.h2 [ Attr.style [ ("padding", "8px") ] ] [ Html.text "Hello World!" ] ]
