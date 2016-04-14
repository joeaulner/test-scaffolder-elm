module Tokenizer (Token(..), toTokens) where

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


toTokens : String -> List Token
toTokens input =
    let
        lines = String.lines input
        (_, linesTks) = tokenizeLines [] lines
    in
        List.foldr (++) [] linesTks


tokenizeLines : List Int -> List String -> (List Int, List (List Token))
tokenizeLines indentStack lines =
    case lines of
        [] -> (indentStack, [])
        hd :: tl ->
            let
                (indentStack', headTks) = tokenizeLine indentStack hd
                (indentStack'', tailTks) = tokenizeLines indentStack' tl
            in
                (indentStack'', headTks :: tailTks)


tokenizeLine : List Int -> String -> (List Int, List Token)
tokenizeLine indentStack str =
    let
        (indentStack', indentToken, str') = tokenizeIndent indentStack str
        (typeToken, str'') = tokenizeType str'
        descToken = tokenizeDesc str''
    in
        (indentStack', [indentToken, typeToken, descToken])


tokenizeIndent : List Int -> String -> (List Int, Token, String)
tokenizeIndent indentStack str =
    let
        matched = find "^\\s*" str
        indentCt = String.length matched
        str' = String.dropLeft indentCt str
        indentTk =
            let
                prevIndentCt = List.head indentStack |> Maybe.withDefault 0
            in
                if indentCt > prevIndentCt then Indent
                else if indentCt < prevIndentCt then Dedent
                else Samedent
        indentStack' =
            case indentTk of
                Indent -> indentCt :: indentStack
                Dedent -> Maybe.withDefault [] (List.tail indentStack)
                _ -> indentStack
    in
        (indentStack', indentTk, str')


tokenizeType : String -> (Token, String)
tokenizeType str =
    let
        trim n s = String.dropLeft n s
        (tk, str') =
            if contains "^feature:\\s*" str then (Feature, trim 8 str)
            else if contains "^scenario:\\s*" str then (Scenario, trim 9 str)
            else if contains "^test:\\s*" str then (Test, trim 5 str)
            else (NoBlock, str)
    in
        (tk, str')


tokenizeDesc : String -> Token
tokenizeDesc str =
    Description <| String.trim str


contains : String -> String -> Bool
contains regexStr str =
    Regex.contains (Regex.regex regexStr) str


find : String -> String -> String
find regexStr str =
    Regex.find (Regex.AtMost 1) (Regex.regex regexStr) str
        |> List.map .match
        |> List.head
        |> Maybe.withDefault ""