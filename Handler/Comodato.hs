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
    
 
  
