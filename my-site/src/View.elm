module View exposing (View, map, placeholder, simpleDiv)

-- import Html exposing (Html)
import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.ListGroup as ListGroup


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body = [ Html.text moduleName ]
    }

simpleDiv : String -> View msg
simpleDiv moduleName =
    { title = "Placeholder - " ++ moduleName
    , body = [ h1 [] [ text "Legal Department" ]
             , ListGroup.ul
                 [ ListGroup.li [] [ text moduleName ]
                 , ListGroup.li [] [ text ":)" ]
                 , ListGroup.li [] [ text "Even More Laws" ]
                 ]
             ]
    }
