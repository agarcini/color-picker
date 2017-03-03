module Main exposing (..)

import Html exposing (Html, div, input)
import Html.Attributes exposing (type_, value, style)
import Html.Events exposing (onInput, onFocus, onBlur)
import Svg exposing (..)
import Svg.Attributes exposing (..)


initialModel : Model
initialModel =
    { color = "#CCC"
    , hasFocus = False
    }


type alias Model =
    { color : String
    , hasFocus : Bool
    }


view : Model -> Html Msg
view model =
    div
        [ Html.Attributes.style [ ( "position", "relative" ) ]
        ]
        [ input
            [ Html.Attributes.type_ "text"
            , value model.color
            , onInput TextChanged
            , onFocus InputFocused
            , onBlur InputBlurred
            , Html.Attributes.style
                [ ( "border", "none" )
                , ( "border-right", "solid 20px " ++ model.color )
                , ( "box-shadow", "0 0 0 1px rgba(0,0,0,0.1)" )
                ]
            ]
            []
        , if model.hasFocus == True then
            roundRect model
          else
            text ""
        ]


roundRect : Model -> Html.Html msg
roundRect model =
    svg
        [ width "120", height "120", viewBox "0 0 120 120", Svg.Attributes.style "position:absolute;top:100%;left:0" ]
        [ rect [ fill model.color, x "10", y "10", width "100", height "100", rx "15", ry "15" ] [] ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextChanged value ->
            { model | color = value }

        InputFocused ->
            { model | hasFocus = True }

        InputBlurred ->
            { model | hasFocus = False }


type Msg
    = TextChanged String
    | InputFocused
    | InputBlurred


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = initialModel, view = view, update = update }
