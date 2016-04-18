module Formatter where

import Tokenizer exposing (Token(..))
import Parser exposing (ParseTree(..), toParseTree)


toJavaScript : String -> String
toJavaScript input =
    let
        parsed  = Debug.log "parsed" (Parser.toParseTree input)
        (_, formatted) = format [parsed] 0 ""
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