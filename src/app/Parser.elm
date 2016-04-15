module Parser (toParseTree) where

import Tokenizer exposing (Token(..), toTokens)


type ParseTree
    = Node (Token, List ParseTree)
    | LeafNode Token


toParseTree : String -> String
toParseTree input =
    let
        tokens = Debug.log "tokens" (Tokenizer.toTokens input)
        parseTree = Debug.log "parse tree" (parseFeature tokens)
    in
        input


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
                Node (Feature, List.concat [d :: desc, scen])
        _ -> Node (Samedent, [])


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
                s = Node (Scenario, [d])
                (ts', pts) = scenarios ts
            in
                (ts', s :: pts)
        _ -> (tokens, [])


dropIndent : List Token -> List Token
dropIndent tokens =
    case tokens of
        Indent :: ts -> dropIndent ts
        _ -> tokens