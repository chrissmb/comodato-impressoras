{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}
module Foundation where

import Yesod
import Data.Text
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool)
import Handler.TipoCartucho
import Handler.TipoCor

data App = App {connPool :: ConnectionPool }

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|

Usuario json
    nome Text
    email Text
    deriving Show

Cliente json
    razao Text
    cnpj Text
    email Text
    deriving Show

Impressora json
    modelo Text
    multifuncional Bool
    tipoCartucho TipoCartucho
    colorida Bool

Cartucho json
    modelo Text
    cor TipoCor
    tipoCartucho TipoCartucho

ImpressoraCartucho json
    impressoraId ImpressoraId
    cartuchoId CartuchoId
    UniqueImpressoraCartucho impressoraId cartuchoId

Comodato
    impressoraId ImpressoraId
    clienteId ClienteId
    valor Double
    franquia Int

Consumo
    comodatoId ComodatoId
    consumo Int

|]

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

