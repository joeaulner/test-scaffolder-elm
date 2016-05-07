module Scaffolder (Model, model, view, actions) where

import Html exposing (Html, div, nav, span, text, textarea, label, form, a)
import Html.Attributes exposing (class, id, for, readonly, href, target)
import Html.Events exposing (on, targetValue)
import Signal exposing (Signal, Mailbox, Address)
import String

import Formatter


-- MODEL


type alias Model =
    { testCases : String
    , codeScaffold : String
    }


model : Signal Model
model =
    Signal.foldp update initModel actions.signal


initModel : Model
initModel =
    { testCases = ""
    , codeScaffold = ""
    }


-- UDPATE


type Action
    = NoOp
    | SetInput String


actions : Mailbox Action
actions =
    Signal.mailbox NoOp


update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model
        SetInput testCases' ->
            let
                codeScaffold' = Formatter.toJavaScript testCases'
            in
                { model
                | testCases = testCases'
                , codeScaffold = codeScaffold'
                }


-- VIEW


view : Address Action -> Model -> Html
view address model =
    div []
        [ nav [ class "light-green darken-1" ]
            [ div [ class "nav-wrapper container" ]
                [ span [ class "brand-logo" ]
                    [ text "Test Scaffolder" ]
                , a [ class "right"
                    , href "https://github.com/pancakeCaptain/test-scaffolder-elm"
                    , target "_blank"
                    ]
                    [ text "View on Github" ]
                ]
            ]
        , div [ class "container" ]
            [ div [ class "section row" ]
                [ form [ class "col s12" ]
                    [ div [ class "row" ]
                        [ viewTestCases address
                        , viewCodeScaffold address model
                        ]
                    ]
                ]
            ]
        ]


viewTestCases : Address Action -> Html
viewTestCases address =
    div [ class "input-field col s6" ]
        [ textarea
            [ id "test-cases"
            , class "materialize-textarea"
            , on "input" targetValue (Signal.message address << SetInput)
            ] []
        , label [ for "test-cases" ]
            [ text "Test Cases" ]
        ]    


viewCodeScaffold : Address Action -> Model -> Html
viewCodeScaffold address model =
    let
        statusClass =
            if String.isEmpty model.codeScaffold
                then ""
                else "active"
    in
        div [ class "input-field col s6" ]
            [ textarea
                [ id "code-scaffold"
                , class "materialize-textarea"
                , readonly True
                ]
                [ text model.codeScaffold ]
            , label [ for "code-scaffold", class statusClass ]
                [ text "Code Scaffold" ]
            ]