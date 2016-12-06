{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveDataTypeable #-}
module Handler.Consumo where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postConsumoR :: Handler ()
postConsumoR = do
    cons <- requireJsonBody :: Handler Consumo
    cid <- runDB $ insert cons
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey cid))])