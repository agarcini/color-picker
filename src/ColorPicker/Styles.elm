module ColorPicker.Styles
    exposing
        ( namespace
        , css
        , CssClasses(..)
        )

import Css exposing (..)
import Css.Namespace


namespace : String
namespace =
    "colorPicker"


type CssClasses
    = Container
    | ColorInput
    | ColorPopUp


type ButtonClass
    = Large
    | Small
    | Medium


css : Stylesheet
css =
    (stylesheet << Css.Namespace.namespace "colorPicker")
        [ class Container
            [ position relative
            ]
        , class ColorInput
            [ borderStyle none
            , boxShadow5 (px 0) (px 0) (px 0) (px 1) (rgba 0 0 0 0.1)
            ]
        , class ColorPopUp
            [ position absolute
            , top (pct 100)
            , left (px 0)
            , boxShadow4 (px 0) (px 0) (px 3) (px 0)
            ]
        ]


withButton : ButtonClass -> List Css.Mixin -> Css.Mixin
withButton class mixin =
    withClass class mixin
