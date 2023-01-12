module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import DataSource
import Html exposing (Html)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)

import Bootstrap.Navbar as Navbar


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg
    | NavMsg Navbar.State


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    , navState : Navbar.State
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()

menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.collapseMedium            -- Collapse menu at the medium breakpoint
        |> Navbar.dark                      -- Customize coloring
        |> Navbar.brand                     -- Add logo to your brand with a little styling to align nicely
            [ href "#" ]
            [ img
                [ src "./logo.png"
                , class "d-inline-block align-top"
                , id "logo"
                ]
                []
            , text " State of Anywhere"
            ]
        |> Navbar.items
            [ Navbar.itemLink
                [ href "#" ] [ text "State Home Page" ]
            , Navbar.dropdown              -- Adding dropdowns is pretty simple
                { id = "navDropdownDept"
                , toggle = Navbar.dropdownToggle [] [ text "Departments" ]
                , items =
                    [ Navbar.dropdownHeader [ text "State of Anywhere" ]
                    , Navbar.dropdownItem
                        [ href "#accounting" ]
                        [ text "Accounting" ]
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "IT" ]
                    , Navbar.dropdownItem
                        [ href "#legal" ]
                        [ text "Legal" ]
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "Administration" ]
                    , Navbar.dropdownDivider
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "Marketing" ]
                    ]
                }
            , Navbar.dropdown              
                { id = "navDropdownOutput"
                , toggle = Navbar.dropdownToggle [] [ text "Outputs" ]
                , items =
                    [ Navbar.dropdownHeader [ text "" ]
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "View HTML Table" ]
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "Export Excel (.csv, .xlsx)" ]
                    ]
                }
            ]
        |> Navbar.customItems
            [ Navbar.formItem []
                [ Input.text [ Input.attrs [placeholder "enter" ]]
                , Button.button
                    [ Button.success
                    , Button.small
                    , Button.attrs [ Spacing.ml2Sm ]
                    ]
                    [ text "Search"]
                ]
            , Navbar.textItem [ Spacing.ml2Sm, class "muted" ] [ text "Text"]
            ]
        |> Navbar.view model.navState


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body = Html.div [] pageView.body
    , title = pageView.title
    }
