module Html.Extra exposing (concatAttributes)


concatAttributes : (appendable -> a) -> appendable -> appendable -> a
concatAttributes f a1 a2 =
    f (a1 ++ a2)
