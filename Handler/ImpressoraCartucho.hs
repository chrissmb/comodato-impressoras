{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Handler.ImpressoraCartucho where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postImpressoraCartuchoR :: Handler ()
postImpressoraCartuchoR = do
    prtcts <- requireJsonBody :: Handler ImpressoraCartucho
    pid <- runDB $ insert prtcts
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey pid))])
