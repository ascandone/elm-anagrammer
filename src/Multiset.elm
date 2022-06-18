module Multiset exposing
    ( Multiset
    , diff
    , empty
    , fromList
    , insert
    , insertTimes
    , member
    , remove
    , toList
    )

import Dict exposing (Dict)


type Multiset value
    = Multiset (Dict value Int)


empty : Multiset value
empty =
    Multiset Dict.empty


insertTimes : comparable -> Int -> Multiset comparable -> Multiset comparable
insertTimes value times (Multiset dict) =
    let
        f oldValue =
            case oldValue of
                Nothing ->
                    Just times

                Just old ->
                    Just (old + times)
    in
    Multiset (Dict.update value f dict)


insert : comparable -> Multiset comparable -> Multiset comparable
insert value ms =
    insertTimes value 1 ms


removeTimes : comparable -> Int -> Multiset comparable -> Multiset comparable
removeTimes value times (Multiset dict) =
    let
        f oldValue =
            Maybe.andThen
                (\old ->
                    if times >= old then
                        Nothing

                    else
                        Just (old - times)
                )
                oldValue
    in
    Multiset (Dict.update value f dict)


remove : comparable -> Multiset comparable -> Multiset comparable
remove value md =
    removeTimes value 1 md


member : comparable -> Multiset comparable -> Bool
member value (Multiset multiset) =
    case Dict.get value multiset of
        Nothing ->
            False

        Just _ ->
            True


toList : Multiset value -> List value
toList (Multiset d) =
    d
        |> Dict.toList
        |> List.concatMap (\( k, times ) -> List.repeat times k)


fromList : List comparable -> Multiset comparable
fromList =
    List.foldl insert empty


diff : Multiset comparable -> Multiset comparable -> Multiset comparable
diff (Multiset d1) (Multiset d2) =
    let
        onlyLeft =
            insertTimes

        both k timesD1 timesD2 acc =
            let
                times =
                    timesD1 - timesD2
            in
            if times <= 0 then
                acc

            else
                insertTimes k times acc

        onlyRight _ _ acc =
            acc
    in
    Dict.merge onlyLeft both onlyRight d1 d2 empty
