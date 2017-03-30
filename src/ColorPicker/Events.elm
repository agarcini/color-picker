module ColorPicker.Events exposing (onMouseMove, Point)

import Svg.Events
import Svg
import Json.Decode exposing (map2, field, float)


onMouseMove : (Point -> msg) -> Svg.Attribute msg
onMouseMove msg =
    Svg.Events.on "mousemove" (Json.Decode.map msg mouseMoveDecoder)


type alias Point =
    { x : Float, y : Float }


mouseMoveDecoder : Json.Decode.Decoder Point
mouseMoveDecoder =
    Json.Decode.map2 Point
        (field "offsetX" float)
        (field "offsetY" float)
