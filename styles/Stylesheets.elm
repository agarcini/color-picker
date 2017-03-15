port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import ColorPicker.Styles


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "styles.css", Css.File.compile [ ColorPicker.Styles.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
