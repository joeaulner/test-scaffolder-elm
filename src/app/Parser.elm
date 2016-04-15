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
        Samedent :: tks -> parseFeature tks
        Feature :: (Description str) :: tks ->
            let
                d = LeafNode (Description str)
                (tks', desc) = dropIndent tks |> descriptions
                -- (scen, tks'') = scenarios tks'
            in
                Node (Feature, d :: desc)
        _ -> Node (Samedent, [])


descriptions : List Token -> (List Token, List ParseTree)
descriptions tokens =
    case tokens of
        Samedent :: tks -> descriptions tks
        NoBlock :: tks -> descriptions tks
        (Description str) :: tks ->
            let
                node = LeafNode (Description str)
                (tks', pts) = descriptions tks
            in
                (tks', node :: pts)
        _ -> (tokens, [])


dropIndent : List Token -> List Token
dropIndent tokens =
    case tokens of
        Indent :: ts -> dropIndent ts
        _ -> tokens