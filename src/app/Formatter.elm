module Formatter where

import String

import Tokenizer exposing (Token(..))
import Parser exposing (ParseTree(..), ParseResult(..))


toJavaScript : String -> String
toJavaScript input =
    let
        (_, formatted) =
            case Parser.toParseTree input of
                Valid parsed ->
                    format parsed 0 ""
                Error error ->
                    ([], error)
    in
        formatted


format : List ParseTree -> Int -> String -> (List ParseTree, String)
format parseTrees indent output =
    case parseTrees of
        p :: pts ->
            case p of
                Node Feature (LeafNode (Description str) :: children) ->
                    let
                        indent' = indent + 4
                        open = "describe('" ++ str ++ "'), function() {\n"
                        (_, contents) = format children indent' ""
                        close = "});\n"
                    in
                        (pts, output ++ open ++ contents ++ close)
                Node Scenario (LeafNode (Description str) :: children) ->
                    let
                        indent' = indent + 4
                        open = "describe('" ++ str ++ "'), function() {\n"
                        (_, contents) = format children indent' ""
                        close = "});\n"
                    in
                        (pts, output ++ open ++ contents ++ close)
                _ -> (parseTrees, "")
        _ -> (parseTrees, "")