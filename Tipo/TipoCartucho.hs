-- TipoCartucho.hs
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Tipo.TipoCartucho where

import Database.Persist.TH
import Prelude

import Data.Aeson
import Data.Aeson.Types
import Control.Monad
import Data.Text as Text

data TipoCartucho = Toner | Tinta 
    deriving (Show, Eq, Read)

derivePersistField "TipoCartucho"

instance ToJSON TipoCartucho where
    toJSON Toner  = "Toner"
    toJSON Tinta  = "Tinta"
    
instance FromJSON TipoCartucho where
  parseJSON (String s) =  pure $ mkCartucho s
  parseJSON _ = fail "Falha ao converter objeto TipoCartucho"

mkCartucho :: Text -> TipoCartucho
mkCartucho "Toner" = Toner
mkCartucho "Tinta" = Tinta
mkCartucho _ = error "Cartucho inválido"