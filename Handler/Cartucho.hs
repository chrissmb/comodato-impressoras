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

getCartuchosImpressoraR :: ImpressoraId -> Handler Html
getCartuchosImpressoraR pid = do
    cts <- runDB $ (rawSql "SELECT ?? \
            \FROM cartucho INNER JOIN impressora_cartucho \
            \ON cartucho.id=impressora_cartucho.cartuchoid \
            \AND impressora_cartucho.impressoraid=?" [toPersistValue pid])::Handler [(Entity Cartucho)]
    sendResponse (object [pack "resp" .= toJSON cts]) 

deleteDelCartuchoR :: CartuchoId -> Handler ()
deleteDelCartuchoR cid = do
    runDB $ get404 cid
    runDB $ delete cid
    sendResponse (object [pack "resp" .= pack "DELETED!"])

putUpdCartuchoR :: CartuchoId -> Handler ()
putUpdCartuchoR cid = do
    cts <- requireJsonBody :: Handler Cartucho
    runDB $ get404 cid
    runDB $ update cid [CartuchoModelo =. (cartuchoModelo cts)
                       ,CartuchoCor =. (cartuchoCor cts)
                       ,CartuchoTipo =. (cartuchoTipo cts)]
    sendResponse (object [pack "resp" .= pack "UPDATED!"])