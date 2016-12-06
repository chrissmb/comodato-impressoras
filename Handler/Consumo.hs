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
    
getConsumosR :: Handler Html
getConsumosR = do
    cons <- runDB $ selectList [] [Asc ConsumoId]
    sendResponse (object [pack "resp" .= toJSON cons])    
    
deleteDelConsumoR :: ConsumoId -> Handler ()
deleteDelConsumoR cid = do
    runDB $ get404 cid
    runDB $ delete cid
    sendResponse (object [pack "resp" .= pack "DELETED!"])    
    


-- CASO SEJA UM CAMPO, USAMOS PATCH
-- patchUpdateR
putUpdConsumoR :: ConsumoId -> Handler ()
putUpdConsumoR cid = do
    cons <- requireJsonBody :: Handler Consumo
    runDB $ get404 cid
    runDB $ update cid [ConsumoComodatoId =. (consumoComodatoId cons)
                      , ConsumoConsumo =. (consumoConsumo cons)]
    sendResponse (object [pack "resp" .= pack "UPDATED!"])      