module Ui.InputTest exposing (suite)

import Fuzz
import Html.Attributes
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Ui.Input


suite : Test
suite =
    Test.describe "Ui.Input"
        [ Test.fuzz2 Fuzz.string Fuzz.string "should override arguments when given again" <|
            \s1 s2 ->
                Ui.Input.view [ Ui.Input.value s1, Ui.Input.value s2 ]
                    |> Query.fromHtml
                    |> Query.has [ Selector.attribute (Html.Attributes.value s2) ]
        , Test.fuzz Fuzz.string "Should trigger input event" <|
            \value ->
                Ui.Input.view [ Ui.Input.onInput identity ]
                    |> Query.fromHtml
                    |> Event.simulate (Event.input value)
                    |> Event.expect value
        ]
