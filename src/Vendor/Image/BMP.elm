module Vendor.Image.BMP exposing (encode24, encodeWith)

{-|


# BMP image creating

@docs encode24, encodeWith

-}

-- import BinaryBase64

import Base64 as Base64
import Bitwise exposing (and, shiftRightBy)
import Bytes exposing (Endianness(..))
import Bytes.Encode as Encode exposing (Encoder, unsignedInt16, unsignedInt32, unsignedInt8)
import Vendor.Image exposing (ColorDepth(..), Options, Order(..), Pixels, defaultOptions)


header : Int -> Int -> Int -> List Encoder
header w h dataSize =
    [ {- BMP Header -}
      -- "BM" -|- ID field ( 42h, 4Dh )
      --   [ 0x42, 0x4D ] |> List.map unsignedInt8
      unsignedInt16 BE 0x424D

    --   70 bytes (54+16) -|- Size of the BMP file
    -- , [ 0x46, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE (54 + dataSize)

    -- -- Unused -|- Application specific
    -- , [ 0x00, 0x00 ] |> List.map
    -- -- Unused -|- Application specific
    -- , [ 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 0

    -- 54 bytes (14+40) -|- Offset where the pixel array (bitmap data) can be found
    -- , [ 0x36, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 54

    {- DIB Header -}
    --40 bytes -|- Number of bytes in the DIB header (from this point)
    -- , [ 0x28, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 40

    -- 2 pixels (left to right order) -|- Width of the bitmap in pixels
    -- , [ 0x02, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE w

    -- 2 pixels (bottom to top order) -|- Height of the bitmap in pixels. Positive for bottom to top pixel order.
    -- , [ 0x02, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE h

    --1 plane -|-  Number of color planes being used
    -- , [ 0x01, 0x00 ] |> List.map unsignedInt8
    , unsignedInt16 LE 1

    -- 24 bits -|- Number of bits per pixel
    -- , [ 0x18, 0x00 ] |> List.map unsignedInt8
    , unsignedInt16 LE 24

    -- 0 -|- BI_RGB, no pixel array compression used
    -- , [ 0x00, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 0

    -- 16 bytes -|- Size of the raw bitmap data (including padding)
    -- , [ 0x10, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 16

    -- 2835 pixels/metre horizontal  | Print resolution of the image, 72 DPI × 39.3701 inches per metre yields 2834.6472
    -- , [ 0x13, 0x0B, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 2835

    -- 2835 pixels/metre vertical
    -- , [ 0x13, 0x0B, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 2835

    -- 0 colors -|- Number of colors in the palette
    -- , [ 0x00, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 0

    -- 0 important colors -|- 0 means all colors are important
    -- , [ 0x00, 0x00, 0x00, 0x00 ] |> List.map unsignedInt8
    , unsignedInt32 LE 0
    ]


{-| ##Eexample

shortcut for [`encode24With`](#encode24With) with [`defaultOptions`](#defaultOptions)

    encode24With :
        Width
        -> Height
        -> Pixels
        -> Base64String

-}
encode24 : Int -> Int -> Pixels -> String
encode24 w h pixels =
    encodeWith { defaultOptions | order = RightUp, depth = Bit24 } w h pixels


{-|

    encodeWith :
        Options
        -> Width
        -> Height
        -> Pixels
        -> Base64String

-}
encodeWith : Options a -> Int -> Int -> Pixels -> String
encodeWith opt w h pixels =
    let
        pixels_ =
            encodeImageData w opt pixels
                |> Encode.encode

        result =
            header w h (Bytes.width pixels_)
                ++ [ Encode.bytes pixels_ ]

        imageData =
            Encode.sequence result
                |> Encode.encode
                |> Base64.fromBytes
                |> Maybe.withDefault ""
    in
    "data:image/bmp;base64," ++ imageData


encodeImageData : Int -> Options a -> List Int -> Encoder
encodeImageData w { depth, order } pxs =
    let
        delme line acc =
            case order of
                RightDown ->
                    lineFolder24 line [] ++ acc

                RightUp ->
                    acc ++ lineFolder24 line []

                LeftDown ->
                    lineFolder24reverse line [] ++ acc

                LeftUp ->
                    acc ++ lineFolder24reverse line []
    in
    case depth of
        Bit24 ->
            Encode.sequence <| greedyGroupsOfWithStep delme [] w w pxs


{-| Insipired by List.Extra
-}
greedyGroupsOfWithStep : (List a -> acc -> acc) -> acc -> Int -> Int -> List a -> acc
greedyGroupsOfWithStep f acc size step xs =
    let
        xs_ =
            List.drop step xs

        okayArgs =
            size > 0 && step > 0

        okayXs =
            List.length xs > 0
    in
    if okayArgs && okayXs then
        greedyGroupsOfWithStep f (f (List.take size xs) acc) size step xs_

    else
        acc


lineFolder24 : List Int -> List Encoder -> List Encoder
lineFolder24 pixelInLineLeft acc =
    -- TODO remove ++ - use reverse folding
    case pixelInLineLeft of
        e1 :: e2 :: e3 :: e4 :: rest ->
            [ unsignedInt24 Bytes.LE e1
            , unsignedInt24 Bytes.LE e2
            , unsignedInt24 Bytes.LE e3
            , unsignedInt24 Bytes.LE e4
            ]
                |> (++) acc
                |> lineFolder24 rest

        [ e1, e2, e3 ] ->
            [ unsignedInt24 Bytes.LE e1
            , unsignedInt24 Bytes.LE e2
            , unsignedInt24 Bytes.LE e3
            , unsignedInt8 0
            , unsignedInt8 0
            , unsignedInt8 0
            ]
                |> (++) acc

        [ e1, e2 ] ->
            [ unsignedInt24 Bytes.LE e1
            , unsignedInt24 Bytes.LE e2
            , unsignedInt8 0
            , unsignedInt8 0
            ]
                |> (++) acc

        [ e1 ] ->
            [ unsignedInt24 Bytes.LE e1
            , unsignedInt8 0
            ]
                |> (++) acc

        [] ->
            acc


lineFolder24reverse : List Int -> List Encoder -> List Encoder
lineFolder24reverse pixelInLineLeft acc =
    -- [e1] -> 3 bytes -> add 1 to get a multiple of 4
    -- [e1,e2] -> 6 bytes -> add 2 to get a multiple of 4
    -- [e1,e2,e3] -> 9 bytes -> add 3 to get a multiple of 4
    -- [e1,e2,e3,e4] -> 12 bytes -> add 0 to get a multiple of 4
    case pixelInLineLeft of
        e1 :: e2 :: e3 :: e4 :: rest ->
            unsignedInt24 Bytes.LE e4
                :: unsignedInt24 Bytes.LE e3
                :: unsignedInt24 Bytes.LE e2
                :: unsignedInt24 Bytes.LE e1
                :: acc
                |> lineFolder24reverse rest

        [ e1, e2, e3 ] ->
            unsignedInt24 Bytes.LE e3
                :: unsignedInt24 Bytes.LE e2
                :: unsignedInt24 Bytes.LE e1
                :: acc
                ++ [ unsignedInt8 0, unsignedInt8 0, unsignedInt8 0 ]

        [ e1, e2 ] ->
            unsignedInt24 Bytes.LE e2
                :: unsignedInt24 Bytes.LE e1
                :: acc
                ++ [ unsignedInt8 0
                   , unsignedInt8 0
                   ]

        [ e1 ] ->
            unsignedInt24 Bytes.LE e1
                :: acc
                ++ [ unsignedInt8 0
                   ]

        [] ->
            acc


unsignedInt24 : Endianness -> Int -> Encoder
unsignedInt24 endian num =
    if endian == Bytes.LE then
        Encode.sequence
            [ and num 0xFF |> unsignedInt8
            , shiftRightBy 8 (and num 0xFF00) |> unsignedInt8
            , shiftRightBy 16 (and num 0x00FF0000) |> unsignedInt8
            ]

    else
        Encode.sequence
            [ shiftRightBy 16 (and num 0x00FF0000) |> unsignedInt8
            , shiftRightBy 8 (and num 0xFF00) |> unsignedInt8
            , and num 0xFF |> unsignedInt8
            ]