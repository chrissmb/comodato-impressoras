-- TipoCartucho.hs
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Tipo.TipoCor where

import Database.Persist.TH
import Prelude

import Data.Aeson
import Data.Aeson.Types
import Control.Monad
import Data.Text as Text

data TipoCor = Preto | Ciano | Amarelo | Magenta
    deriving (Show, Eq, Read)

derivePersistField "TipoCor"

instance ToJSON TipoCor where
    toJSON Preto  = "Preto"
    toJSON Ciano  = "Ciano"
    toJSON Amarelo  = "Amarelo"
    toJSON Magenta  = "Magenta"
    
instance FromJSON TipoCor where
  parseJSON (String s) =  pure $ mkCor s
  parseJSON _ = fail "Falha ao converter objeto TipoCor"

mkCor :: Text -> TipoCor
mkCor "Preto" = Preto
mkCor "Ciano" = Ciano
mkCor "Amarelo" = Amarelo
mkCor "Magenta" = Magenta
mkCor _ = error "Cor inválida"
