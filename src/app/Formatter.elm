module Formatter where

import Html exposing (Html, div, textarea, label, text)
import Html.Attributes exposing (class, id, for)
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
    div [ class "input-field col s6" ]
        [ textarea [ id "formatter", class "materialize-textarea" ]
            [ text formatter.output ]
        , label [ for "formatter" ]
            [ text "Code Scaffold" ]
        ]