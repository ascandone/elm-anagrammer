module AnagramTest exposing (suite)

import Anagram
import Expect
import Fuzz
import Test exposing (Test)


suite : Test
suite =
    Test.describe "Anagram"
        [ Test.test "should report when the second string has missing chars" <|
            \() ->
                Anagram.diff "abZ" "ab"
                    |> Expect.equal ( "z", "" )
        , Test.test "should report when a char has been used too few times" <|
            \() ->
                Anagram.diff "aaa" "a"
                    |> Expect.equal ( "aa", "" )
        , Test.test "should report when a char has been used too many times" <|
            \() ->
                Anagram.diff "a" "aaa"
                    |> Expect.equal ( "", "aa" )
        , Test.test "should report when the second string has missing chars, even with swapped chars" <|
            \() ->
                Anagram.diff "bZa" "ab"
                    |> Expect.equal ( "z", "" )
        , Test.test "should report when the first string has missing chars" <|
            \() ->
                Anagram.diff "ab" "abZ"
                    |> Expect.equal ( "", "z" )
        , Test.test "should report when the first string has missing chars, even with swapped chars" <|
            \() ->
                Anagram.diff "ab" "bZa"
                    |> Expect.equal ( "", "z" )
        , Test.test "should diff two strings with different letters" <|
            \() ->
                Anagram.diff "abc" "efg"
                    |> Expect.equal ( "abc", "efg" )
        , Test.test "should ignore whitespace in the left string" <|
            \() ->
                Anagram.diff "a " "a"
                    |> Expect.equal ( "", "" )
        , Test.test "should ignore whitespace in the right string" <|
            \() ->
                Anagram.diff "a" "a "
                    |> Expect.equal ( "", "" )
        , Test.test "should lowercase inputs" <|
            \() ->
                Anagram.diff "AB" "AC"
                    |> Expect.equal ( "b", "c" )
        , Test.fuzz Fuzz.string "two equal strings are always anagrams" <|
            \s ->
                Anagram.diff s s
                    |> Expect.equal ( "", "" )
        , Test.fuzz Fuzz.string "a string and its reverse are always anagrams" <|
            \s ->
                Anagram.diff s (String.reverse s)
                    |> Expect.equal ( "", "" )
        ]
