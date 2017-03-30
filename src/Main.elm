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
    , y = Nothing
    }


type alias Model =
    { color : String
    , hasFocus : Bool
    , y : Maybe Float
    }


{ id, class, classList } =
    Html.CssHelpers.withNamespace "colorPicker"
{ css } =
    Css.compile [ ColorPicker.Styles.css ]


popUpHeight : number
popUpHeight =
    120


popUpWidth : number
popUpWidth =
    30


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


hueGradient : Model -> Html Msg
hueGradient model =
    svg
        [ width (toString popUpWidth), height (toString popUpHeight), viewBox ("0 0 " ++ (toString popUpWidth) ++ " " ++ (toString popUpHeight)), ColorPicker.Events.onMouseMove HueMouseMoved ]
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
        [ width "200", height "120", viewBox "0 0 200 120" ]
        [ defs []
            [ linearGradient [ Svg.Attributes.id "saturationGradient" ]
                [ stop [ offset "0%", stopColor "#fff" ] []
                , stop [ offset "100%", stopColor model.color ] []
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

        HueMouseMoved point ->
            let
                _ =
                    Debug.log "point" point
            in
                { model | y = Just point.y }


type Msg
    = TextChanged String
    | InputFocused
    | InputBlurred
    | HueMouseMoved ColorPicker.Events.Point


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = initialModel, view = view, update = update }
