module Main where

import Html exposing (Html)
import Html.Attributes as Attr


main : Html
main =
    Html.div []
        [ Html.nav
            [ Attr.class "light-green darken-1" ]
            [ Html.div
                [ Attr.class "nav-wrapper container" ]
                [ Html.span
                    [ Attr.class "brand-logo" ]
                    [ Html.text "Test Scaffolder" ]
                ]
            ]
        , Html.div
            [ Attr.class "container" ]
            [ Html.div [] [ Html.text "<content here>" ] ]
        ]
