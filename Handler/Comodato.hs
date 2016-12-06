{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveDataTypeable #-}
module Handler.Comodato where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postComodatoR :: Handler ()
postComodatoR = do
    comos <- requireJsonBody :: Handler Comodato
    cid <- runDB $ insert comos
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey cid))])

    

getComodatosR :: Handler Html
getComodatosR = do
    comos <- runDB $ selectList [] [Asc ComodatoId]
    sendResponse (object [pack "resp" .= toJSON comos])
    
    
deleteDelComodatoR :: ComodatoId -> Handler ()
deleteDelComodatoR cid = do
    runDB $ get404 cid
    runDB $ delete cid
    sendResponse (object [pack "resp" .= pack "DELETED!"])

    
-- CASO SEJA UM CAMPO, USAMOS PATCH
-- patchUpdateR
putUpdComodatoR :: ComodatoId -> Handler ()
putUpdComodatoR cid = do
    comos <- requireJsonBody :: Handler Comodato
    runDB $ get404 cid
    runDB $ update cid [ComodatoImpressoraId =. (comodatoImpressoraId comos)
                      , ComodatoClienteId  =. (comodatoClienteId comos)
                      , ComodatoValor =. (comodatoValor comos)
                      ,ComodatoFranquia =. (comodatoFranquia comos)]
    sendResponse (object [pack "resp" .= pack "UPDATED!"])  
    

getComodatoIdR :: ComodatoId -> Handler Html
getComodatoIdR cid = do
    comos <- runDB $ (rawSql "SELECT ??,??,??\
            \FROM comodato  INNER JOIN impressora  \
            \ON comodato.impressora_id=impressora.id \
            \inner join cliente on comodato.cliente_id = cliente.id \
            \AND comodato.id=?" [toPersistValue cid])::Handler [(Entity Comodato, Entity Impressora, Entity Cliente)]
    sendResponse (object [pack "resp" .= toJSON comos]) 
    
-- select c.id, i.modelo, cli.razao, c.valor, c.franquia from comodato c inner join impressora i on c.impressora_id = i.id inner join cliente cli on c.cliente_id = cli.id



    
    

    
 
 
 
  
