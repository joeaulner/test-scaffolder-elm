module Formatter where

import String

import Tokenizer exposing (Token(..))
import Parser exposing (ParseTree(..), ParseResult(..))


type alias State =
    { indent: Int
    , output: String
    }


initState =
    { indent = 0
    , output = ""
    }


toJavaScript : String -> String
toJavaScript input =
    case Parser.toParseTree input of
        Valid parsed ->
            formatList parsed initState |> .output
        Error error ->
            error


formatList : List ParseTree -> State -> State
formatList parseTrees state =
    case parseTrees of
        pt :: pts ->
            format pt state
                |> formatList pts
        [] ->
            state


format : ParseTree -> State -> State
format parseTree state =
    case parseTree of
        Node Feature (LeafNode (Description desc) :: children) ->
            let
                open = tabs state ++ "describe('" ++ desc ++ "', function() {\n"
                close = tabs state ++ "});\n"
                state' =
                    { state
                    | indent = state.indent + 4
                    , output = state.output ++ open
                    }
                withContents = formatList children state' |> .output
            in
                { state | output = withContents ++ close }

        Node Scenario (LeafNode (Description desc) :: children) ->
            let
                open = tabs state ++ "describe('" ++ desc ++ "', function() {\n"
                close = tabs state ++ "});\n"
                state' =
                    { state
                    | indent = state.indent + 4
                    , output = state.output ++ open
                    }
                withContents = formatList children state' |> .output
            in
                { state | output = withContents ++ close }
        
        Node Test (LeafNode (Description desc) :: []) ->
            let
                open = tabs state ++ "it('" ++ desc ++ "', function() {\n"
                close = tabs state ++ "});\n"
            in
                { state | output = state.output ++ open ++ close }
                
        _ -> state


tabs : State -> String
tabs state =
    String.repeat state.indent " "
