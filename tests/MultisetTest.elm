module MultisetTest exposing (suite)

import Expect
import Fuzz
import Multiset
import Test exposing (Test)


suite : Test
suite =
    Test.describe "Multiset"
        [ Test.fuzz Fuzz.int "should contain a value when inserted" <|
            \x ->
                Multiset.empty
                    |> Multiset.insert x
                    |> expectMember x
        , Test.fuzz Fuzz.int "should contain a value when inserted twice" <|
            \x ->
                Multiset.empty
                    |> Multiset.insert x
                    |> Multiset.insert x
                    |> expectMember x
        , Test.fuzz Fuzz.int "should not contain a value when inserted and removed" <|
            \x ->
                Multiset.empty
                    |> Multiset.insert x
                    |> Multiset.remove x
                    |> expectNotMember x
        , Test.fuzz Fuzz.int "should contain a value when inserted twice and removed" <|
            \x ->
                Multiset.empty
                    |> Multiset.insert x
                    |> Multiset.insert x
                    |> Multiset.remove x
                    |> expectMember x
        , Test.fuzz (Fuzz.list Fuzz.int) "A multiset should contain all values inserted" <|
            \lst ->
                let
                    predicates =
                        List.map expectMember lst
                in
                Multiset.fromList lst
                    |> Expect.all ((\_ -> Expect.pass) :: predicates)
        , Test.fuzz (Fuzz.list Fuzz.int) "A multiset should not contain anything else" <|
            \lst ->
                let
                    predicates =
                        List.map expectNotMember lst
                in
                Multiset.empty
                    |> Expect.all ((\_ -> Expect.pass) :: predicates)
        ]


expectMember : Int -> Multiset.Multiset Int -> Expect.Expectation
expectMember v multiset =
    Expect.true ("Expected " ++ String.fromInt v ++ " to be a multiset member") <|
        Multiset.member v multiset


expectNotMember : Int -> Multiset.Multiset Int -> Expect.Expectation
expectNotMember v multiset =
    Expect.false ("Expected " ++ String.fromInt v ++ " not to be a multiset member") <|
        Multiset.member v multiset
