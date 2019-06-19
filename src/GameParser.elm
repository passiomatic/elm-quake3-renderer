module GameParser exposing
    ( GameEntity
    , Value(..)
    , run
    )

{-| Game entities parsing.
-}

import Dict exposing (Dict)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Parser as P exposing ((|.), (|=), Parser)


type Value
    = Text String
    | Number Float
    | Vector Vec3


type alias GameEntity =
    Dict String Value


run : String -> List GameEntity
run data =
    P.run entitiesParser data
        |> Result.withDefault []


entitiesParser : Parser (List GameEntity)
entitiesParser =
    P.loop [] entitiesParserHelp


entitiesParserHelp : List GameEntity -> Parser (P.Step (List GameEntity) (List GameEntity))
entitiesParserHelp entities =
    P.oneOf
        [ P.succeed (\entity -> P.Loop (entity :: entities))
            |= entityParser
            |. P.symbol "\n"
        , P.succeed ()
            |> P.map (\_ -> P.Done entities)
        ]


{-| A game entity is a list of properties named after its `classname`.
-}
entityParser : Parser GameEntity
entityParser =
    P.sequence
        { spaces = P.spaces
        , start = "{"
        , end = "}"
        , separator = ""
        , trailing = P.Optional
        , item = propertyParser
        }
        |> P.map Dict.fromList


propertyParser : Parser ( String, Value )
propertyParser =
    P.succeed Tuple.pair
        -- Key
        |= stringParser
        |. whitespace
        -- Value
        |= P.oneOf
            [ P.map Vector (P.backtrackable vec3Parser)
            , P.map Number (P.backtrackable floatParser)
            , P.map Text stringParser
            ]
        |. P.chompIf (\c -> c == '\n')


vec3Parser : Parser Vec3
vec3Parser =
    P.succeed vec3
        |. P.symbol dquote
        |= signedFloat
        |. whitespace
        |= signedFloat
        |. whitespace
        |= signedFloat
        |. P.symbol dquote


floatParser : Parser Float
floatParser =
    P.succeed identity
        |. P.symbol dquote
        |= signedFloat
        |. P.symbol dquote


stringParser : Parser String
stringParser =
    P.succeed identity
        |. P.symbol dquote
        |= (P.getChompedString <| P.chompUntil dquote)
        |. P.symbol dquote


dquote =
    "\""


signedFloat : Parser Float
signedFloat =
    P.oneOf
        [ P.succeed negate
            |. P.symbol "-"
            |= P.float
        , P.float
        ]


whitespace : Parser ()
whitespace =
    P.chompWhile (\c -> c == ' ')
