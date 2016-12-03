{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Usuario where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text

postUsuarioR :: Handler ()
postUsuarioR = do
    usrs <- requireJsonBody :: Handler Usuario
    uid <- runDB $ insert usrs
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey uid))])

getUsuariosR :: Handler Html
getUsuariosR = do
    usrs <- runDB $ selectList [] [Asc UsuarioNome]
    sendResponse (object [pack "resp" .= toJSON usrs])

deleteDelUsuarioR :: UsuarioId -> Handler ()
deleteDelUsuarioR uid = do
    runDB $ get404 uid
    runDB $ delete uid
    sendResponse (object [pack "resp" .= pack "DELETED!"])  

-- CASO SEJA UM CAMPO, USAMOS PATCH
-- patchUpdateR
putUpdUsuarioR :: UsuarioId -> Handler ()
putUpdUsuarioR uid = do
    usrs <- requireJsonBody :: Handler Usuario
    runDB $ get404 uid
    runDB $ update uid [UsuarioNome =. (usuarioNome usrs)
                      , UsuarioEmail  =. (usuarioEmail usrs)]
    sendResponse (object [pack "resp" .= pack "UPDATED!"])  
    
    