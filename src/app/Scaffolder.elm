module Scaffolder (model, view, actions) where

import Html exposing (Html, div, nav, span, text, textarea, label, form)
import Html.Attributes exposing (class, id, for)
import Signal exposing (Signal, Mailbox, Address)


-- MODEL


type alias Model =
    { testCases : String
    , testSource : String
    }


model : Signal Model
model =
    Signal.foldp update initModel actions.signal


initModel : Model
initModel =
    { testCases = ""
    , testSource = ""
    }


-- UDPATE


type Action =
    NoOp


actions : Mailbox Action
actions =
    Signal.mailbox NoOp


update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model


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
                        [ div [ class "input-field col s6" ]
                            [ textarea
                                [ id "textarea1"
                                , class "materialize-textarea"
                                ] []
                            , label [ for "textarea1" ]
                                [ text "Test cases" ]
                            ]
                        , div [ class "input-field col s6" ]
                            [ textarea
                                [ id "textarea2"
                                , class "materialize-textarea"
                                ] []
                            , label [ for "textarea2" ]
                                [ text "Output" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]