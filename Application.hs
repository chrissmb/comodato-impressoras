{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

module Application where

import Foundation
import Yesod

-- AQUI MORAM OS HANDLERS
-- import Add
-- PARA CADA NOVO GRUPO DE HANDLERS, CRIAR UM AQUIVO
-- DE HANDLER NOVO E IMPORTAR AQUI
import Handler.Usuario
import Handler.Impressora
import Handler.Cliente
import Handler.Cartucho
import Handler.ImpressoraCartucho
import Handler.Comodato
import Handler.Consumo

------------------
mkYesodDispatch "App" resourcesApp
