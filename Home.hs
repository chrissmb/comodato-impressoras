{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation
import Yesod
import Data.Text

postProdutoR :: Handler ()
postProdutoR = do
    prod <- requireJsonBody :: Handler Produto
    pid <- runDB $ insert prod
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ show pid)])

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    [whamlet|
        <h1> Olá mundo
    |]
    
    
    
    
    
    
    