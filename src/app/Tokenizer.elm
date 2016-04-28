module Tokenizer (Token(..), toTokens, tokenToString) where

import String
import Maybe
import Regex exposing (Regex)


type Token
    = Indent
    | Dedent
    | Feature
    | Scenario
    | Test
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


indentStr = "^\\s+"
featureStr = "^(feature|feat|f) *: *"
scenarioStr = "^(scenario|scen|s) *: *"
testStr = "^(test|t) *: *"
descriptionStr = "^.*?\\n"


tokenize : String -> State -> State
tokenize input state =
    if contains indentStr input then
        indent input state
    
    else if contains featureStr input then
        block featureStr Feature input state
    
    else if contains scenarioStr input then
        block scenarioStr Scenario input state
        
    else if contains testStr input then
        block testStr Test input state
    
    else if contains descriptionStr input then
        description input state
        
    else
        { state | tokens = Description input :: state.tokens }


indent : String -> State -> State
indent input { indentStack, tokens } =
    let
        matchLength = String.length <| match indentStr input
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


block : String -> Token -> String -> State -> State
block regexStr token input state =
    let
        matchLength = String.length <| match regexStr input
        input' = String.dropLeft matchLength input
    in
        tokenize input' { state | tokens = token :: state.tokens }


description : String -> State -> State
description input state =
    let
        matched = match descriptionStr input
        matchLength = String.length matched
        input' = String.dropLeft matchLength input
        token = Description <| String.dropRight 1 matched
    in
        tokenize input' { state | tokens = token :: state.tokens }


contains : String -> String -> Bool
contains regexStr str =
    let
        regex = Regex.caseInsensitive <| Regex.regex regexStr
    in
        Regex.contains regex str


match : String -> String -> String
match regexStr str =
    let
        one = Regex.AtMost 1
        regex = Regex.caseInsensitive <| Regex.regex regexStr
    in
        Regex.find one regex str
            |> List.map .match
            |> List.head
            |> Maybe.withDefault ""


tokenToString : Token -> String
tokenToString token =
    case token of
        Indent -> "indent"
        Dedent -> "dedent"
        Feature -> "feature"
        Scenario -> "scenario"
        Test -> "test"
        Description str -> "description (" ++ str ++ ")"