module Formatter where

import String

import Tokenizer exposing (Token(..))
import Parser exposing (ParseTree(..))


type ParseStatus
    = Valid
    | Error String


toJavaScript : String -> String
toJavaScript input =
    let
        parsed  = Parser.toParseTree input
        (_, formatted) = 
            case validateParseTree [parsed] of
                Valid ->
                    format [parsed] 0 ""
                Error str ->
                    ([], str)
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


validateParseTree : List ParseTree -> ParseStatus
validateParseTree parseTrees =
    case parseTrees of
        ParseError str :: rest ->
            Error str
        Node _ contents :: rest ->
            validateParseTree <| contents ++ rest
        node :: rest ->
            validateParseTree rest
        [] ->
            Valid
