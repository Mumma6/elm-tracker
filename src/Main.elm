module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type_, value)


main : Html text
main =
    div []
        [ h1 [] [ text "My tracker" ]
        , table []
            [ tr []
                [ th [] [ text "Date" ]
                , th [] [ text "Type" ]
                , th [] [ text "Distance " ]
                , th [] [ text "Comment" ]
                ]
            ]
        , fieldset []
            [ legend [] [ text "Add activity" ]
            , form []
                [ table []
                    [ tr []
                        [ td [] [ label [] [ text "Date" ] ]
                        , tr []
                            [ input
                                [ style "width" "100%"
                                , type_ "date"
                                ]
                                []
                            ]
                        ]
                    , tr []
                        [ td [] [ label [] [ text "Type" ] ]
                        , tr []
                            [ select
                                [ style "width" "100%"
                                ]
                                [ option [ value "Walk" ] [ text "Walk " ]
                                , option [ value "Run" ] [ text "Run " ]
                                , option [ value "Bike" ] [ text "Bike " ]
                                ]
                            ]
                        ]
                    , tr []
                        [ td [] [ label [] [ text "Distance" ] ]
                        , td [] [ input [ type_ "number" ] [] ]
                        ]
                    , tr []
                        [ td [] [ label [] [ text "Comment" ] ]
                        , td [] [ textarea [] [] ]
                        ]
                    ]
                , button [ type_ "submit" ] [ text "Add" ]
                ]
            ]
        ]
