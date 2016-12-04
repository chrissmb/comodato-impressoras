{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Handler.Cartucho where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postCartuchoR :: Handler ()
postCartuchoR = do
    cts <- requireJsonBody :: Handler Cartucho
    cid <- runDB $ insert cts
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey cid))])


    