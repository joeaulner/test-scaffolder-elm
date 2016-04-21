module Parser (ParseTree(..), toParseTree) where

import Tokenizer exposing (Token(..), toTokens)


type ParseTree
    = Node Token (List ParseTree)
    | LeafNode Token


toParseTree : String -> ParseTree
toParseTree input =
    let
        tokens = Tokenizer.toTokens input
    in
        parseFeature tokens


parseFeature : List Token -> ParseTree
parseFeature tokens =
    case tokens of
        Feature :: Description str :: ts ->
            let
                description = LeafNode (Description str)
                (ts', scenarios) = dropIndent ts |> parseScenarios
            in
                Node Feature (description :: scenarios)
        _ -> Node Samedent []


parseScenarios : List Token -> (List Token, List ParseTree)
parseScenarios tokens =
    case tokens of
        Scenario :: Description str :: ts ->
            let
                d = LeafNode (Description str)
                (ts', t) = dropIndent ts |> tests
                s = Node Scenario (d :: t)
                (ts'', pts) = parseScenarios ts
            in
                (ts'', s :: pts)
        Dedent :: ts ->
            dropDedent ts |> parseScenarios
        _ -> (tokens, [])


tests : List Token -> (List Token, List ParseTree)
tests tokens =
    case tokens of
        Test :: Description str :: ts ->
            let
                d = LeafNode (Description str)
                t = Node Test [d]
                (ts', pts) = tests ts
            in
                (ts', t :: pts)
        Dedent :: ts ->
            dropDedent ts |> parseScenarios
        _ -> (tokens, [])


dropIndent : List Token -> List Token
dropIndent tokens =
    case tokens of
        Indent :: ts -> dropIndent ts
        _ -> tokens


dropDedent : List Token -> List Token
dropDedent tokens =
    case tokens of
        Dedent :: ts -> dropIndent ts
        _ -> tokens