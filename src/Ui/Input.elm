module Ui.Input exposing
    ( Attribute
    , autofocus
    , label
    , onInput
    , placeholder
    , value
    , view
    )

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events
import Html.Extra


type Attribute msg
    = Attribute (Config msg -> Config msg)


attribute : Html.Attribute msg -> Attribute msg
attribute attr_ =
    Attribute <| \c -> { c | inputAttributes = attr_ :: c.inputAttributes }


placeholder : String -> Attribute msg
placeholder =
    attribute << Html.Attributes.placeholder


autofocus : Bool -> Attribute msg
autofocus =
    attribute << Html.Attributes.autofocus


label : String -> Attribute msg
label label_ =
    Attribute <| \c -> { c | label = Just label_ }


value : String -> Attribute msg
value =
    attribute << Html.Attributes.value


onInput : (String -> msg) -> Attribute msg
onInput =
    attribute << Html.Events.onInput


type alias Config msg =
    { inputAttributes : List (Html.Attribute msg)
    , label : Maybe String
    }


defaultConfig : Config msg
defaultConfig =
    { inputAttributes = []
    , label = Nothing
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    List.foldr (\(Attribute setConfig) current -> setConfig current) defaultConfig


view : List (Attribute msg) -> Html msg
view attributes =
    let
        config =
            makeConfig attributes
    in
    case config.label of
        Nothing ->
            viewInput config

        Just labelText ->
            Html.label [ class "group" ]
                [ viewLabelContent labelText
                , viewInput config
                ]


viewLabelContent : String -> Html msg
viewLabelContent labelText =
    Html.span
        [ class "ml-2 mb-1 leading-none text-gray-500 group-hover:text-indigo-500 group-focus-within:text-indigo-500" ]
        [ Html.text labelText ]


viewInput : Config msg -> Html msg
viewInput config =
    Html.Extra.concatAttributes Html.input
        config.inputAttributes
        [ class "group-hover:border-indigo-500 border px-4 py-2 transition-colors rounded-md w-full focus:ring ring-indigo-200 focus:outline-none focus:border-indigo-600 shadow-sm"
        ]
        []
