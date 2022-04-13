module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig
import IHP.FileStorage.Config
import IHP.Mail

config :: ConfigBuilder
config = do
    currentEnv <- envOrDefault ("DEV"::ByteString) ("ENV"::ByteString)
    if currentEnv == "DEV" then do
        option Development
        option (AppHostname "localhost")
        option $ SMTP
            { host = "127.0.1.1"
            , port = 1025
            , credentials = Nothing
            , encryption = Unencrypted
            }
        
    else do
        option Development
        option (AppHostname "localhost")
        option $ SMTP
            { host = "127.0.1.1"
            , port = 1025
            , credentials = Nothing
            , encryption = Unencrypted
            }
