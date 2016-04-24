module Parser (ParseTree(..), ParseResult(..), toParseTree) where

import Tokenizer exposing (Token(..))


type ParseTree
    = Node Token (List ParseTree)
    | LeafNode Token
    | ParseError String


type ParseResult
    = Valid (List ParseTree)
    | Error String


toParseTree : String -> ParseResult
toParseTree input =
    let
        tokens = Tokenizer.toTokens input
        parsed = parseFeature tokens
    in
        case validateParseTree [parsed] of
            Valid _ ->
                Valid [parsed]
            Error error ->
                Error error


parseFeature : List Token -> ParseTree
parseFeature tokens =
    case tokens of
        Feature :: Description str :: ts ->
            let
                description = LeafNode (Description str)
                (ts', contents) = dropIndent ts |> parseContents
            in
                Node Feature (description :: contents)
        _ ->
            parseError tokens


parseContents : List Token -> (List Token, List ParseTree)
parseContents tokens =
    case tokens of
        Scenario :: Description str :: ts ->
            let
                description = LeafNode (Description str)
                (ts', contents) = dropIndent ts |> parseContents
                scenario = Node Scenario (description :: contents)
                (ts'', rest) = parseContents ts'
            in
                (ts'', scenario :: rest)
        Test :: Description str :: ts ->
            let
                description = LeafNode (Description str)
                test = Node Test [description]
                (ts', rest) = parseContents ts
            in
                (ts', test :: rest)
        Dedent :: ts ->
            (ts, [])
        [] ->
            (tokens, [])
        _ ->
            ([], [parseError tokens])


dropIndent : List Token -> List Token
dropIndent tokens =
    case tokens of
        Indent :: ts -> dropIndent ts
        _ -> tokens


parseError : List Token -> ParseTree
parseError tokens =
    ParseError <|
        case tokens of
            t :: ts ->
                "Unexpected token: " ++ (Tokenizer.tokenToString t)
            [] ->
                "Unexpected end of input"


validateParseTree : List ParseTree -> ParseResult
validateParseTree parseTrees =
    case parseTrees of
        ParseError str :: rest ->
            Error str
        Node _ contents :: rest ->
            validateParseTree <| contents ++ rest
        node :: rest ->
            validateParseTree rest
        [] ->
            Valid []
