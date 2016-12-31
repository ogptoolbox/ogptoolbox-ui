module Image.Types exposing (..)

import Http
import Ports


type ImageUploadStatus
    = ImageNotUploadedStatus
    | ImageSelectedStatus
    | ImageReadStatus Ports.ImagePortData
    | ImageUploadedStatus String
    | ImageUploadErrorStatus Http.Error
