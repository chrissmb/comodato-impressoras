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
    
    
  
 

    
    

    
 
 
 
  
