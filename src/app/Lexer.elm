module Lexer (Token, toTokens) where

import String
import Maybe
import Regex

-- REMOVE
import Debug
-- REMOVE


type Token
    = Indent
    | Dedent
    | Samedent


toTokens : String -> List Token
toTokens input =
    let
        lines = String.lines input
        (_, linesTks) = tokenizeLines [] lines
    in
        Debug.log "tokenized"
            (List.foldr (++) [] linesTks)


tokenizeLines : List Int -> List String -> (List Int, List (List Token))
tokenizeLines indentStack lines =
    case lines of
        [] -> (indentStack, [])
        hd :: tl ->
            let
                (indentStack', headTks) = tokenizeLine indentStack hd
                (indentStack'', tailTks) = tokenizeLines indentStack' tl
            in
                (indentStack'', [ headTks ] ++ tailTks)


tokenizeLine : List Int -> String -> (List Int, List Token)
tokenizeLine indentStack str =
    let
        matchedStr = Debug.log "test regex" (match str)
        (indentCt, indentTk) = tokenizeIndent indentStack str
        indentStack' =
            case indentTk of
                Indent -> indentCt :: indentStack
                Dedent -> Maybe.withDefault [] (List.tail indentStack)
                Samedent -> indentStack
    in
        (indentStack', [ indentTk ])


match : String -> List (Maybe String)
match str =
    let
        regex = Regex.regex "^(\\s*)(feature|test)\\s*:\\s*(\\w.*)"
            |> Regex.caseInsensitive
    in
        Regex.find (Regex.All) regex str
            |> List.map .submatches
            |> List.head
            |> Maybe.withDefault []


tokenizeIndent : List Int -> String -> (Int, Token)
tokenizeIndent indentStack str =
    let
        prevIndentCt = Maybe.withDefault 0 (List.head indentStack)
        indentCt = countSpaces str
        indentTk =
            if indentCt > prevIndentCt then Indent
            else if indentCt < prevIndentCt then Dedent
            else Samedent
    in
        (indentCt, indentTk)


countSpaces : String -> Int
countSpaces s =
    case Maybe.withDefault ('.', "") (String.uncons s) of
        (' ', ss) -> 1 + countSpaces ss
        _ -> 0