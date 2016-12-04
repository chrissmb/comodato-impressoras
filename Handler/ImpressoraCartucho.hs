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

getImpressoraCartuchosR :: Handler Html
getImpressoraCartuchosR = do
    prtcts <- runDB $ selectList [] [Asc ImpressoraId]
    sendResponse (object [pack "resp" .= toJSON prtcts])

deleteDelImpressoraCartuchoR :: ImpressoraCartuchoId -> Handler ()
deleteDelImpressoraCartuchoR pid = do
    runDB $ get404 pid
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "DELETED!"])
