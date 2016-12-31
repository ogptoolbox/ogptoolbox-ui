module Http.Error exposing (..)

import Http exposing (Error(..))
import I18n


toString : I18n.Language -> Http.Error -> String
toString language err =
    case err of
        BadPayload message response ->
            I18n.translate language I18n.BadPayloadExplanation

        BadStatus response ->
            if response.status.code == 404 then
                I18n.translate language I18n.PageNotFoundExplanation
            else
                -- TODO Add I18n.BadStatusExplanation prefix
                Basics.toString response

        BadUrl message ->
            I18n.translate language I18n.BadUrlExplanation

        NetworkError ->
            I18n.translate language I18n.NetworkErrorExplanation

        Timeout ->
            I18n.translate language I18n.TimeoutExplanation
