module Main exposing (main)

import Anagram
import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Ui.Input


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    {}


type alias Model =
    { name : String
    , anagram : String
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { name = ""
      , anagram = ""
      }
    , Cmd.none
    )


type Msg
    = InputName String
    | InputAnagramDraft String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputName value ->
            ( { model | name = value }
            , Cmd.none
            )

        InputAnagramDraft value ->
            ( { model | anagram = value }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        ( availableChars, illegalChars ) =
            Anagram.diff model.name model.anagram
    in
    div
        [ class "px-4 max-w-sm mx-auto"
        , class "flex flex-col items-center"
        ]
        [ div [ class "h-6" ] []
        , viewImage
        , div [ class "h-6" ] []
        , div [ class "w-full" ]
            [ Ui.Input.view
                [ Ui.Input.label "Name"
                , Ui.Input.placeholder "John Doe"
                , Ui.Input.value model.name
                , Ui.Input.autofocus True
                , Ui.Input.onInput InputName
                ]
            , div [ class "h-6" ] []
            , Ui.Input.view
                [ Ui.Input.label "Anagram"
                , Ui.Input.placeholder "hooned"
                , Ui.Input.value model.anagram
                , Ui.Input.onInput InputAnagramDraft
                ]
            , div [ class "h-6" ] []
            , viewCharsLeft availableChars
            ]
        ]


viewCharsLeft : String -> Html msg
viewCharsLeft str =
    if String.isEmpty str then
        text ""

    else
        div []
            [ span [ class "text-gray-500" ] [ text "Chars left: " ]
            , span [ class "text-gray-900" ] [ text str ]
            ]


viewImage : Html msg
viewImage =
    div [ class "w-64" ]
        [ img [ Html.Attributes.src "https://i.imgur.com/xCXTHxx.jpg" ] []
        ]
