module Main exposing (..)

import Html exposing (..)


model : String
model =
    ""


view : String -> Html msg
view model =
    div [] []


update : msg -> String -> String
update msg model =
    model


main : Program Never String msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }
