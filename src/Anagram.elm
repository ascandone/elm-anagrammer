module Anagram exposing (diff)

import List.Extra


normalize : String -> String
normalize str =
    str
        |> String.toLower
        |> String.filter Char.isAlpha


{-| s1 - s2
-}
strDiffSimple : String -> String -> String
strDiffSimple s1 s2 =
    s2
        |> String.foldl List.Extra.removeFirst (String.toList s1)
        |> String.fromList


diff : String -> String -> ( String, String )
diff source draft =
    let
        source_ =
            normalize source

        draft_ =
            normalize draft

        sourceMinusDraft =
            strDiffSimple source_ draft_

        draftMinusSource =
            strDiffSimple draft_ source_
    in
    ( sourceMinusDraft, draftMinusSource )
