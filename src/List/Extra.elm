module List.Extra exposing (removeFirst)


removeFirst : a -> List a -> List a
removeFirst toRemove lst =
    case lst of
        [] ->
            []

        hd :: tl ->
            if hd == toRemove then
                tl

            else
                hd :: removeFirst toRemove tl
