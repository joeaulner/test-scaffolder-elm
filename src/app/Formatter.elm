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
                close = "});\n"
                contents =
                    { state | indent = state.indent + 4 }
                        |> formatList children
                        |> .output
                output' = state.output ++ open ++ contents ++ close
            in
                { state | output = output' }

        Node Scenario (LeafNode (Description desc) :: children) ->
            let
                open = tabs state ++ "describe('" ++ desc ++ "', function() {\n"
                close = "});\n"
                contents =
                    { state | indent = state.indent + 4 }
                        |> formatList children
                        |> .output
                output' = state.output ++ open ++ contents ++ close
            in
                { state | output = output' }
        _ -> state


tabs : State -> String
tabs state =
    String.repeat state.indent " "
