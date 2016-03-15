module Scaffolder (model, view, actions) where

import Html exposing (Html, div, nav, span, text, textarea, label, form)
import Html.Attributes exposing (class, id, for)
import Signal exposing (Signal, Mailbox, Address)

import Parser exposing (Parser)
import Formatter exposing (Formatter)


-- MODEL


type alias Model =
    { parser : Parser
    , formatter : Formatter
    }


model : Signal Model
model =
    Signal.foldp update initModel actions.signal


initModel : Model
initModel =
    { parser = Parser.init
    , formatter = Formatter.init
    }


-- UDPATE


type Action
    = NoOp
    | ParserInput Parser.Action


actions : Mailbox Action
actions =
    Signal.mailbox NoOp


update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model
        ParserInput act ->
            let
                parser' = Parser.update act model.parser
                formatter' = Formatter.update
                    (Formatter.SetOutput parser'.output) model.formatter
            in
                { model | parser = parser', formatter = formatter' }


-- VIEW


view : Address Action -> Model -> Html
view address model =
    div []
        [ nav [ class "light-green darken-1" ]
            [ div [ class "nav-wrapper container" ]
                [ span [ class "brand-logo" ]
                    [ text "Test Scaffolder" ]
                ]
            ]
        , div [ class "container" ]
            [ div [ class "section row" ]
                [ form [ class "col s12" ]
                    [ div [ class "row" ]
                        [ Parser.view (Signal.forwardTo address ParserInput) model.parser
                        , Formatter.view (Signal.forwardTo address (\x -> NoOp)) model.formatter
                        ]
                    ]
                ]
            ]
        ]