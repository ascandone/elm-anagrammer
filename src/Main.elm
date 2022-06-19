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


filterInput : String -> String
filterInput =
    String.filter (\ch -> Char.isAlpha ch || ch == ' ')


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputName value ->
            ( { model | name = filterInput value }
            , Cmd.none
            )

        InputAnagramDraft value ->
            ( { model | anagram = filterInput value }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


getValidation : ( String, String ) -> Maybe (Result String ())
getValidation anagramDiff =
    case anagramDiff of
        ( "", "" ) ->
            Just (Ok ())

        ( _, "" ) ->
            Nothing

        ( _, extraChars ) ->
            Just (Err ("Extra chars: \"" ++ extraChars ++ "\""))


view : Model -> Html Msg
view model =
    let
        (( availableChars, _ ) as anagramDiff) =
            Anagram.diff model.name model.anagram
    in
    div
        [ class "px-4 max-w-sm mx-auto"
        , class "flex flex-col items-center"
        ]
        [ div [ class "h-8" ] []
        , viewImage
        , div [ class "h-6" ] []
        , div [ class "w-full" ]
            [ Ui.Input.view
                [ Ui.Input.label "Name"
                , Ui.Input.placeholder "John Doe"
                , Ui.Input.spellcheck False
                , Ui.Input.value model.name
                , Ui.Input.autofocus True
                , Ui.Input.onInput InputName
                ]
            , div [ class "h-6" ] []
            , Ui.Input.view
                [ Ui.Input.label "Anagram"
                , Ui.Input.placeholder "doe john"
                , Ui.Input.spellcheck False
                , Ui.Input.value model.anagram
                , Ui.Input.onInput InputAnagramDraft
                , if String.isEmpty model.anagram then
                    Ui.Input.validation Nothing

                  else
                    Ui.Input.validation (getValidation anagramDiff)
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
    div [ class "w-64 h-64" ]
        [ img [ Html.Attributes.src "https://i.imgur.com/xCXTHxx.jpg" ] []
        ]
