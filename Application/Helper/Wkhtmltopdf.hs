module Application.Helper.Wkhtmltopdf where

import System.Process
import GHC.IO.Handle
import Control.Monad
import Text.Blaze.Html (Html)
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import qualified System.Info as SI
import Data.Text as T (unpack)
import Data.ByteString.Lazy as BL (fromStrict)
import IHP.Prelude

convertBytestring :: LByteString -> IO B.ByteString
convertBytestring bs = do
    (Just stdin, Just stdout, _, _) <- createProcess cprocess
    BL.hPutStr stdin bs >> hClose stdin
    B.hGetContents stdout
    where
        procWith p = p { std_out = CreatePipe
                       , std_in  = CreatePipe 
                       }

        cprocess = procWith $ proc "wkhtmltopdf" opts

        opts = map T.unpack ["--user-style-sheet","build/ihp-lib/static/vendor/bootstrap.min.css","--enable-local-file-access","--encoding", "utf-8" , "-", "-"]

-- Convert the given html and return the pdf as a strict bytestring.
convertHtml :: Html -> IO LByteString
convertHtml = fmap fromStrict . convertBytestring . renderHtml
