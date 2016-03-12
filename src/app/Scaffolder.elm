module Scaffolder (model, view, actions) where

import Html exposing (Html)
import Signal exposing (Signal, Mailbox, Address)
import Html.Attributes as Attr


type Action =
    NoOp


type alias Model =
    { nothing : String }


actions : Mailbox Action
actions =
    Signal.mailbox NoOp


model : Signal Model
model =
    Signal.foldp update initModel actions.signal


initModel : Model
initModel =
    { nothing = "" }


update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model


view : Address Action -> Model -> Html
view address model =
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