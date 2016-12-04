{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Handler.Impressora where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postImpressoraR :: Handler ()
postImpressoraR = do
    prts <- requireJsonBody :: Handler Impressora
    pid <- runDB $ insert prts
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey pid))])

getImpressorasR :: Handler Html
getImpressorasR = do
    prts <- runDB $ selectList [] [Asc ImpressoraModelo]
    sendResponse (object [pack "resp" .= toJSON prts])

getImpressorasCartuchoR :: CartuchoId -> Handler Html
getImpressorasCartuchoR cid = do
    cts <- runDB $ (rawSql "SELECT ?? \
            \FROM impressora INNER JOIN impressora_cartucho \
            \ON impressora.id=impressora_cartucho.impressoraid \
            \AND impressora_cartucho.cartuchoid=?" [toPersistValue cid])::Handler [(Entity Impressora)]
    sendResponse (object [pack "resp" .= toJSON cts]) 

deleteDelImpressoraR :: ImpressoraId -> Handler ()
deleteDelImpressoraR pid = do
    runDB $ get404 pid
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "DELETED!"])  

-- CASO SEJA UM CAMPO, USAMOS PATCH
-- patchUpdateR
putUpdImpressoraR :: ImpressoraId -> Handler ()
putUpdImpressoraR pid = do
    prts <- requireJsonBody :: Handler Impressora
    runDB $ get404 pid
    runDB $ update pid [ImpressoraModelo =. (impressoraModelo prts)
                       ,ImpressoraMultifuncional =. (impressoraMultifuncional prts)
                       ,ImpressoraTipoCartucho =. (impressoraTipoCartucho prts)
                       ,ImpressoraColorida =. (impressoraColorida prts)]
    sendResponse (object [pack "resp" .= pack "UPDATED!"])  
    
    