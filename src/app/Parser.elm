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
        Samedent :: ts -> parseFeature ts
        Feature :: (Description str) :: ts ->
            let
                d = LeafNode (Description str)
                (ts', desc) = dropIndent ts |> descriptions
                (ts'', scen) = dropIndent ts' |> scenarios
            in
                Node Feature (List.concat [d :: desc, scen])
        _ -> Node Samedent []


descriptions : List Token -> (List Token, List ParseTree)
descriptions tokens =
    case tokens of
        Samedent :: ts -> descriptions ts
        NoBlock :: ts -> descriptions ts
        (Description str) :: ts ->
            let
                node = LeafNode (Description str)
                (ts', pts) = descriptions ts
            in
                (ts', node :: pts)
        _ -> (tokens, [])


scenarios : List Token -> (List Token, List ParseTree)
scenarios tokens =
    case tokens of
        Samedent :: ts -> scenarios ts
        Scenario :: (Description str) :: ts ->
            let
                d = LeafNode (Description str)
                (ts', t) = dropIndent ts |> tests
                s = Node Scenario (d :: t)
                (ts'', pts) = scenarios ts
            in
                (ts'', s :: pts)
        Dedent :: ts ->
            dropDedent ts |> scenarios
        _ -> (tokens, [])


tests : List Token -> (List Token, List ParseTree)
tests tokens =
    case tokens of
        Samedent :: ts -> tests ts
        Test :: (Description str) :: ts ->
            let
                d = LeafNode (Description str)
                t = Node Test [d]
                (ts', pts) = tests ts
            in
                (ts', t :: pts)
        Dedent :: ts ->
            dropDedent ts |> scenarios
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