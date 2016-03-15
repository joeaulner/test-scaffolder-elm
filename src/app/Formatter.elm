module Formatter where

import Html exposing (Html, div, textarea, label, text)
import Html.Attributes exposing (class, id, for, readonly)
import Signal exposing (Signal, Address)


-- MODEL


type alias Formatter = { output : String }


init : Formatter
init =
    { output = "" }


-- UPDATE


type Action
    = NoOp
    | SetOutput String


update : Action -> Formatter -> Formatter
update action formatter =
    case action of
        NoOp -> formatter
        SetOutput output' ->
            { formatter | output = output' }


-- VIEW


view : Address Action -> Formatter -> Html
view address formatter =
    let
        statusClass = if formatter.output == "" then "" else " active"
    in
        div [ class "input-field col s6" ]
            [ textarea
                [ id "formatter"
                , class "materialize-textarea"
                , readonly True
                ]
                [ text formatter.output ]
            , label [ for "formatter", class statusClass ]
                [ text "Code Scaffold" ]
            ]