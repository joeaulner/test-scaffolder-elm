module Tokenizer (Token(..), toTokens, tokenToString) where

import String
import Maybe
import Regex exposing (Regex)


type Token
    = Indent
    | Dedent
    | Samedent
    | Feature
    | Scenario
    | Test
    | NoBlock
    | Description String


type alias State =
    { indentStack: List Int
    , tokens: List Token
    }


initState : State
initState = State [] []


toTokens : String -> List Token
toTokens input =
    tokenize input initState
        |> .tokens
        |> List.reverse
        |> Debug.log "tokens"


tokenize : String -> State -> State
tokenize input state =
    if contains "^\\s+" input then indent input state
    else if contains "^feature *: *" input then feature input state
    else if contains "^scenario *: *" input then scenario input state
    else state


indent : String -> State -> State
indent input { indentStack, tokens } =
    let
        matchLength = String.length <| match "^\\s+" input
        input' = String.dropLeft matchLength input
        previousIndent = Maybe.withDefault 0 <| List.head indentStack
        tokens' =
            if matchLength > previousIndent then Indent :: tokens
            else if matchLength < previousIndent then Dedent :: tokens
            else tokens
    in
        tokenize input'
            { indentStack = matchLength :: indentStack
            , tokens = tokens'
            }


feature : String -> State -> State
feature input state =
    let
        matchLength = String.length <| match "^feature *: *" input
        input' = String.dropLeft matchLength input
    in
        tokenize input' { state | tokens = Feature :: state.tokens }


scenario : String -> State -> State
scenario input state =
    let
        matchLength = String.length <| match "^scenario *: *" input
        input' = String.dropLeft matchLength input
    in
        tokenize input' { state | tokens = Scenario :: state.tokens }


contains : String -> String -> Bool
contains regexStr str =
    Regex.contains (Regex.regex regexStr) str


match : String -> String -> String
match regexStr str =
    Regex.find (Regex.AtMost 1) (Regex.regex regexStr) str
        |> List.map .match
        |> List.head
        |> Maybe.withDefault ""


tokenToString : Token -> String
tokenToString token =
    case token of
        Indent -> "indent"
        Dedent -> "dedent"
        Samedent -> "samedent"
        Feature -> "feature"
        Scenario -> "scenario"
        Test -> "test"
        NoBlock -> "noblock"
        Description str -> "description (" ++ str ++ ")"