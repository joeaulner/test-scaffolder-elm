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
        Feature :: tks ->
            let
                (tks', desc) = descriptions tks
                -- (scen, tks'') = scenarios tks'
            in
                Node (Feature, desc)
        _ -> Node (Samedent, [])


descriptions : List Token -> (List Token, List ParseTree)
descriptions tokens =
    case tokens of
        Samedent :: NoBlock :: tks -> descriptions tks
        (Description str) :: tks ->
            let
                node = LeafNode (Description str)
                (tks', pts) = descriptions tks
            in
                (tks', node :: pts)
        _ -> (tokens, [])
