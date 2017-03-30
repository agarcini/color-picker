module ColorPicker.Events exposing (onMouseEvent, Point)

import Svg.Events
import Svg
import Json.Decode exposing (map2, field, float, int)


onMouseEvent : (Point -> msg) -> Svg.Attribute msg
onMouseEvent msg =
    Svg.Events.on "mousemove" (Json.Decode.map msg mouseEventDecoder)


type alias Point =
    { x : Float, y : Float, button : Int }


mouseEventDecoder : Json.Decode.Decoder Point
mouseEventDecoder =
    Json.Decode.map3 Point
        (field "offsetX" float)
        (field "offsetY" float)
        (field "buttons" int)
