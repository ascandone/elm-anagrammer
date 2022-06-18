module Example exposing (..)

import Expect
import Test exposing (Test)


suite : Test
suite =
    Test.describe "My suite"
        [ Test.test "1 + 1 should equal 2" <|
            \() ->
                (1 + 1)
                    |> Expect.equal 2
        ]
