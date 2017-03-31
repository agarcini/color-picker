module Main exposing (..)

import Html exposing (Html, div, input)
import Html.Attributes exposing (type_, value, style)
import Html.Events exposing (onInput, onFocus, onBlur)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import ColorPicker.Styles exposing (css, CssClasses(..))
import Html.CssHelpers
import Css
import ColorPicker.Events


initialModel : Model
initialModel =
    { color = "#CCC"
    , hasFocus = False
    , hueY = Nothing
    , satX = Nothing
    , satY = Nothing
    }


type alias Model =
    { color : String
    , hasFocus : Bool
    , hueY : Maybe Float
    , satX : Maybe Float
    , satY : Maybe Float
    }


{ id, class, classList } =
    Html.CssHelpers.withNamespace "colorPicker"
{ css } =
    Css.compile [ ColorPicker.Styles.css ]


popUpHeight : number
popUpHeight =
    120


hueWidth : number
hueWidth =
    30


saturationWidth : number
saturationWidth =
    200


view : Model -> Html Msg
view model =
    div []
        [ Html.node "style" [] [ Html.text css ]
        , div
            [ class [ Container ]
            ]
            [ input
                [ Html.Attributes.type_ "text"
                , class [ ColorInput ]
                , value model.color
                , onInput TextChanged
                , onFocus InputFocused
                , onBlur InputBlurred
                , Html.Attributes.style
                    [ ( "border-color", model.color ) ]
                ]
                []
              --, if model.hasFocus == True then
            , if True then
                colorPicker model
              else
                text ""
            ]
        ]


colorPicker : Model -> Html.Html Msg
colorPicker model =
    div
        [ class [ ColorPopUp ]
        ]
        [ saturationGradient model
        , hueGradient model
        ]


hueYCoordToColor : Model -> String
hueYCoordToColor model =
    case model.hueY of
        Nothing ->
            model.color

        Just y ->
            let
                pct =
                    y / popUpHeight * 100
            in
                "rgb(" ++ red pct ++ "," ++ green pct ++ "," ++ blue pct ++ ")"



--red pct =


satCoordToColor : Model -> String
satCoordToColor model =
    case ( model.satX, model.satY, model.hueY ) of
        ( Nothing, _, _ ) ->
            model.color

        ( _, Nothing, _ ) ->
            model.color

        ( _, _, Nothing ) ->
            model.color

        ( Just x, Just y, Just hueY ) ->
            let
                hue =
                    toString ((hueY / popUpHeight) * 360)

                saturation =
                    toString ((x / saturationWidth) * 100)

                lightness =
                    toString (100 - ((y / popUpHeight) * 100))
            in
                "hsl(" ++ hue ++ ", " ++ saturation ++ "%, " ++ lightness ++ "%)"


hueGradient : Model -> Html Msg
hueGradient model =
    svg
        [ width (toString hueWidth)
        , height (toString popUpHeight)
        , viewBox ("0 0 " ++ (toString hueWidth) ++ " " ++ (toString popUpHeight))
        , ColorPicker.Events.onMouseEvent HueMouseDragged
        ]
        [ defs []
            [ linearGradient [ Svg.Attributes.id "hueGradient", x1 "0", x2 "0", y1 "0", y2 "1" ]
                [ stop [ offset "0%", stopColor "#F00" ] []
                , stop [ offset "16.666666%", stopColor "#FF0" ] []
                , stop [ offset "33.333333%", stopColor "#0F0" ] []
                , stop [ offset "50%", stopColor "#0FF" ] []
                , stop [ offset "66.666666%", stopColor "#00F" ] []
                , stop [ offset "83.333333%", stopColor "#F0F" ] []
                , stop [ offset "100%", stopColor "#F00" ] []
                ]
            ]
        , rect [ fill "url(#hueGradient)", x "0", y "0", width "100%", height "100%" ] []
        ]


saturationGradient : Model -> Html Msg
saturationGradient model =
    svg
        [ width (toString saturationWidth)
        , height (toString popUpHeight)
        , viewBox ("0 0 " ++ (toString saturationWidth) ++ " " ++ (toString popUpHeight))
        , ColorPicker.Events.onMouseEvent SaturationMouseDragged
        ]
        [ defs []
            [ linearGradient [ Svg.Attributes.id "saturationGradient" ]
                [ stop [ offset "0%", stopColor "#fff" ] []
                , stop [ offset "100%", stopColor (hueYCoordToColor model) ] []
                ]
            , linearGradient [ Svg.Attributes.id "blacknessGradient", x1 "0", x2 "0", y1 "0", y2 "1" ]
                [ stop [ offset "0%", stopColor "rgba(0,0,0,0)" ] []
                , stop [ offset "100%", stopColor "#000" ] []
                ]
            ]
        , rect
            [ fill "url(#saturationGradient)"
            , x "0"
            , y "0"
            , width "100%"
            , height "100%"
            ]
            []
        , rect
            [ fill "url(#blacknessGradient)"
            , x "0"
            , y "0"
            , width "100%"
            , height "100%"
            ]
            []
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextChanged value ->
            { model | color = value }

        InputFocused ->
            { model | hasFocus = True }

        InputBlurred ->
            { model | hasFocus = False }

        HueMouseDragged point ->
            if point.button == 1 then
                { model | hueY = Just point.y }
            else
                model

        SaturationMouseDragged point ->
            if point.button == 1 then
                let
                    updatedModel =
                        { model | satX = Just point.x, satY = Just point.y }
                in
                    { updatedModel | color = satCoordToColor updatedModel }
            else
                model


type Msg
    = TextChanged String
    | InputFocused
    | InputBlurred
    | HueMouseDragged ColorPicker.Events.Point
    | SaturationMouseDragged ColorPicker.Events.Point


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = initialModel, view = view, update = update }
