module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Iso8601
import Svg.Attributes exposing (string)
import Time


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : a -> Sub msg
subscriptions _ =
    Sub.none


init : a -> ( Model, Cmd msg )
init _ =
    ( Model
        [ Activity (toPosix "2022-01-01") Walk 2.3 "Waaalk" ]
        (DraftActivity "" "" "" "")
        Time.utc
    , Cmd.none
    )


type alias Activity =
    { date : Time.Posix
    , activityType : ActivityType
    , distance : Float
    , commment : String
    }


type ActivityType
    = Walk
    | Run
    | Bike


activityTypeToString : ActivityType -> String
activityTypeToString activityType =
    case activityType of
        Walk ->
            "Walk"

        Run ->
            "Run"

        Bike ->
            "Bike"


activityStringToType : String -> ActivityType
activityStringToType activityType =
    case activityType of
        "Walk" ->
            Walk

        "Run" ->
            Run

        "Bike" ->
            Bike

        _ ->
            Walk


type alias DraftActivity =
    { date : String
    , activityType : String
    , distance : String
    , comment : String
    }


type alias Model =
    { activites : List Activity
    , draft : DraftActivity
    , timeZone : Time.Zone
    }


type Msg
    = AddActivity
    | ChangeDate String
    | ChangeType String
    | ChangeDistance String
    | ChangeComment String


addActivity model =
    let
        date =
            toPosix model.draft.date

        activityType =
            activityStringToType model.draft.activityType

        distance =
            case String.toFloat model.draft.distance of
                Just x ->
                    x

                Nothing ->
                    0

        comment =
            model.draft.comment

        newActivity =
            Activity date activityType distance comment
    in
    { model
        | draft = DraftActivity "" "" "" ""
        , activites = newActivity :: model.activites
    }


changeDate newDate model =
    let
        draft =
            model.draft

        newDraft =
            { draft | date = newDate }
    in
    { model | draft = newDraft }


changeType newType model =
    let
        draft =
            model.draft

        newDraft =
            { draft | activityType = newType }
    in
    { model | draft = newDraft }


changeDistance newDistance model =
    let
        draft =
            model.draft

        newDraft =
            { draft | distance = newDistance }
    in
    { model | draft = newDraft }


changeComment newComment model =
    let
        draft =
            model.draft

        newDraft =
            { draft | comment = newComment }
    in
    { model | draft = newDraft }


update msg model =
    case msg of
        AddActivity ->
            ( addActivity model, Cmd.none )

        ChangeDate newDate ->
            ( changeDate newDate model, Cmd.none )

        ChangeType newType ->
            ( changeType newType model, Cmd.none )

        ChangeDistance newDistance ->
            ( changeDistance newDistance model, Cmd.none )

        ChangeComment newComment ->
            ( changeComment newComment model, Cmd.none )


view model =
    { title = "ActivityField"
    , body =
        [ h1 [] [ text "My tracker" ]
        , table []
            (tr []
                [ th [] [ text "Date" ]
                , th [] [ text "Type" ]
                , th [] [ text "Distance " ]
                , th [] [ text "Comment" ]
                ]
                :: List.map (viewActivity model.timeZone) model.activites
            )
        , fieldset []
            [ legend [] [ text "Add activity" ]
            , form [ onSubmit AddActivity ]
                [ table []
                    [ tr []
                        [ td [] [ label [] [ text "Date" ] ]
                        , tr []
                            [ input
                                [ style "width" "100%"
                                , type_ "date"
                                , value model.draft.date
                                , onInput ChangeDate
                                ]
                                []
                            ]
                        ]
                    , tr []
                        [ td [] [ label [] [ text "Type" ] ]
                        , tr []
                            [ select
                                [ style "width" "100%"
                                , value model.draft.activityType
                                , onInput ChangeType
                                ]
                                [ option [ value "Walk" ] [ text "Walk " ]
                                , option [ value "Run" ] [ text "Run " ]
                                , option [ value "Bike" ] [ text "Bike " ]
                                ]
                            ]
                        ]
                    , tr []
                        [ td [] [ label [] [ text "Distance" ] ]
                        , td [] [ input [ type_ "number", value model.draft.distance, onInput ChangeDistance ] [] ]
                        ]
                    , tr []
                        [ td [] [ label [] [ text "Comment" ] ]
                        , td [] [ textarea [ value model.draft.comment, onInput ChangeComment ] [] ]
                        ]
                    ]
                , button [ type_ "submit" ] [ text "Add" ]
                ]
            ]
        ]
    }


viewActivity : Time.Zone -> Activity -> Html msg
viewActivity zone activity =
    tr []
        [ td [] [ text (viewDate zone activity.date) ]
        , td [] [ text (activityTypeToString activity.activityType) ]
        , td [] [ text (String.fromFloat activity.distance) ]
        , td [] [ text activity.commment ]
        ]


viewDate : Time.Zone -> Time.Posix -> String
viewDate zone time =
    (Time.toYear zone time |> String.fromInt)
        ++ "-"
        ++ (Time.toMonth zone time |> monthToString)
        ++ "-"
        ++ (Time.toDay zone time |> String.fromInt)


monthToString : Time.Month -> String
monthToString month =
    case month of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"


toPosix : String -> Time.Posix
toPosix date =
    case Iso8601.toTime date of
        Ok x ->
            x

        _ ->
            Time.millisToPosix 0
