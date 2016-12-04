{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Cliente where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postClienteR :: Handler ()
postClienteR = do
    clis <- requireJsonBody :: Handler Cliente
    cid <- runDB $ insert clis
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey cid))])
    
getClientesR :: Handler Html
getClientesR = do
    clis <- runDB $ selectList [] [Asc ClienteRazao]
    sendResponse (object [pack "resp" .= toJSON clis])
    

deleteDelClienteR :: ClienteId -> Handler ()
deleteDelClienteR cid = do
    runDB $ get404 cid
    runDB $ delete cid
    sendResponse (object [pack "resp" .= pack "DELETED!"])      
    
    
-- CASO SEJA UM CAMPO, USAMOS PATCH
-- patchUpdateR
putUpdClienteR :: ClienteId -> Handler ()
putUpdClienteR cid = do
    clis <- requireJsonBody :: Handler Cliente
    runDB $ get404 cid
    runDB $ update cid [ClienteRazao =. (clienteRazao clis)
                      , ClienteCnpj  =. (clienteCnpj clis)
                      , ClienteEmail =. (clienteEmail clis)]
    sendResponse (object [pack "resp" .= pack "UPDATED!"])  
        