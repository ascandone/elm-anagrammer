module Anagram exposing (diff)

import Multiset exposing (Multiset)


strToMultiset : String -> Multiset Char
strToMultiset str =
    str
        |> String.toLower
        |> String.filter (\ch -> ch /= ' ')
        |> String.toList
        |> Multiset.fromList


strDiff : Multiset Char -> Multiset Char -> String
strDiff a b =
    Multiset.diff a b
        |> Multiset.toList
        |> String.fromList


diff : String -> String -> ( String, String )
diff source draft =
    let
        sourceMultiSet =
            strToMultiset source

        draftMultiSet =
            strToMultiset draft

        sourceMinusDraft =
            strDiff sourceMultiSet draftMultiSet

        draftMinusSource =
            strDiff draftMultiSet sourceMultiSet
    in
    ( sourceMinusDraft, draftMinusSource )
