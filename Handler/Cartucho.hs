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

getCartuchosR :: Handler Html
getCartuchosR = do
    cts <- runDB $ selectList [] [Asc CartuchoModelo]
    sendResponse (object [pack "resp" .= toJSON cts])

deleteDelCartuchoR :: CartuchoId -> Handler ()
deleteDelCartuchoR cid = do
    runDB $ get404 cid
    runDB $ delete cid
    sendResponse (object [pack "resp" .= pack "DELETED!"])  