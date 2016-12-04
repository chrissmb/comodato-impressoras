{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Cliente where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postClienteR :: Handler ()
postClienteR = do
    clis <- requireJsonBody :: Handler Cliente
    cid <- runDB $ insert clis
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey cid))])
    

    