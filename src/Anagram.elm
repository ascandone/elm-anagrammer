module Anagram exposing (diff)

import Multiset


diff : String -> String -> ( String, String )
diff source draft =
    let
        sourceMultiSet =
            Multiset.fromList (String.toList source)

        draftMultiSet =
            Multiset.fromList (String.toList draft)

        sourceMinusDraft =
            Multiset.diff sourceMultiSet draftMultiSet
                |> Multiset.toList
                |> String.fromList

        draftMinusSource =
            Multiset.diff draftMultiSet sourceMultiSet
                |> Multiset.toList
                |> String.fromList
    in
    ( sourceMinusDraft, draftMinusSource )
