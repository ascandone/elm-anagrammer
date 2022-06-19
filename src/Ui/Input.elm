module Ui.Input exposing
    ( Attribute
    , autofocus
    , label
    , onInput
    , placeholder
    , spellcheck
    , validation
    , value
    , view
    )

import Heroicons.Outline
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events
import Html.Extra
import Svg.Attributes


type Attribute msg
    = Attribute (Config msg -> Config msg)


attribute : Html.Attribute msg -> Attribute msg
attribute attr_ =
    Attribute <| \c -> { c | inputAttributes = attr_ :: c.inputAttributes }


placeholder : String -> Attribute msg
placeholder =
    attribute << Html.Attributes.placeholder


spellcheck : Bool -> Attribute msg
spellcheck =
    attribute << Html.Attributes.spellcheck


autofocus : Bool -> Attribute msg
autofocus =
    attribute << Html.Attributes.autofocus


label : String -> Attribute msg
label label_ =
    Attribute <| \c -> { c | label = Just label_ }


validation : Maybe (Result String ()) -> Attribute msg
validation validation_ =
    Attribute <| \c -> { c | validation = validation_ }


value : String -> Attribute msg
value =
    attribute << Html.Attributes.value


onInput : (String -> msg) -> Attribute msg
onInput =
    attribute << Html.Events.onInput


type alias Config msg =
    { inputAttributes : List (Html.Attribute msg)
    , label : Maybe String
    , validation : Maybe (Result String ())
    }


defaultConfig : Config msg
defaultConfig =
    { inputAttributes = []
    , label = Nothing
    , validation = Nothing
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
    Html.div []
        [ case config.label of
            Nothing ->
                viewInput config

            Just labelText ->
                Html.label [ class "group" ]
                    [ viewLabelContent labelText config.validation
                    , viewInput config
                    ]
        , Html.div [ class "h-2" ]
            [ case config.validation of
                Just (Err reason) ->
                    viewErrorMessage reason

                _ ->
                    Html.text ""
            ]
        ]


viewErrorMessage : String -> Html msg
viewErrorMessage reason =
    Html.div [ class "ml-2 my-1 leading-none text-xs text-red-500 absolute" ] [ Html.text reason ]


viewLabelContent : String -> Maybe (Result String ()) -> Html msg
viewLabelContent labelText validation_ =
    Html.div
        [ class "ml-2 mb-2 leading-none"
        , class <|
            case validation_ of
                Nothing ->
                    "text-gray-500 group-hover:text-indigo-500 group-focus-within:text-indigo-500"

                Just (Ok _) ->
                    "text-green-600/90 group-hover:text-green-600 group-focus-within:text-green-600"

                Just (Err _) ->
                    "text-red-500/90 group-hover:text-red-500 group-focus-within:text-red-500"
        ]
        [ Html.text labelText ]


viewInput : Config msg -> Html msg
viewInput config =
    Html.div
        [ class "border rounded-md focus-within:ring"
        , class "flex items-center"
        , class <|
            case config.validation of
                Nothing ->
                    "group-hover:border-indigo-500 focus-within:border-indigo-600 ring-indigo-200"

                Just (Ok _) ->
                    "group-hover:border-green-500 focus-within:border-green-600 ring-green-200 border-green-300"

                Just (Err _) ->
                    "group-hover:border-red-500 focus-within:border-red-600 ring-red-200 border-red-200"
        ]
        [ Html.Extra.concatAttributes Html.input
            config.inputAttributes
            [ class "px-4 py-2 transition-colors rounded-md  w-full  focus:outline-none  shadow-sm"
            ]
            []
        , case config.validation of
            Nothing ->
                Html.text ""

            Just result ->
                Html.span [ class "px-2" ]
                    [ case result of
                        Ok _ ->
                            viewCheckIcon

                        Err _ ->
                            viewErrorIcon
                    ]
        ]


viewCheckIcon : Html msg
viewCheckIcon =
    Heroicons.Outline.checkCircle [ Svg.Attributes.class "h-6 w-6 text-green-500" ]


viewErrorIcon : Html msg
viewErrorIcon =
    Heroicons.Outline.exclamationCircle [ Svg.Attributes.class "h-6 w-6 text-red-500" ]
