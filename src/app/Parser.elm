module Parser where

import Html exposing (Html, div, textarea, label, text)
import Html.Attributes exposing (class, id, for)
import Html.Events exposing (on, targetValue)
import Signal exposing (Signal, Address)


-- MODEL


type alias Parser =
    { input : String
    , output : String
    }


init : Parser
init =
    { input = ""
    , output = ""
    }


-- UPDATE


type Action
    = NoOp
    | SetInput String


update : Action -> Parser -> Parser
update action parser =
    case action of
        NoOp -> parser
        SetInput input' ->
            { parser | input = input', output = input' }


-- VIEW


view : Address Action -> Parser -> Html
view address parser =
    div [ class "input-field col s6" ]
        [ textarea
            [ id "parser"
            , class "materialize-textarea"
            , on "input" targetValue (Signal.message address << SetInput)
            ] []
        , label [ for "parser" ]
            [ text "Test Cases" ]
        ]