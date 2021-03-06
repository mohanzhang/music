{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import System.Environment

import Control.Exception
import Control.Applicative ((<$>))
import Control.Monad (forM_)
import Data.Monoid
import Data.Maybe

import Hakyll

main = do
  hakyll $ do
    -- assets
    match "js/**" $ route idRoute >> compile copyFileCompiler
    match "img/**" $ route idRoute >> compile copyFileCompiler
    match "css/**" $ route idRoute >> compile copyFileCompiler

    match "sass/main.sass" $ do
      route $ gsubRoute "sass/" (const "css/") `composeRoutes` setExtension "css"
      compile sass

    -- page template
    match "layout.html" $ compile templateCompiler

    -- partials
    match "partials/*.html" $ compile templateCompiler
    match "partials/*.haml" $ compile hamlTemplateCompiler

    -- individual album lyrics as partials
    match "albums/*" $ do
      compile $ pandocCompiler
          >>= saveSnapshot "html_lyrics"

    match "index.haml" $ do
      route $ setExtension "html"
      compile $ do
        let lyricsContext =
              field "html_lyrics" (\_ -> loadSnapshotBody "albums/2015_western_hearts_pacific_skies_ep.textile" "html_lyrics")
        haml >>= applyAsTemplate lyricsContext >>= loadAndApplyTemplate "layout.html" defaultContext

    match "emmy_ep.haml" $ do
      route $ setExtension "html"
      compile $ do
        let lyricsContext =
              field "html_lyrics" (\_ -> loadSnapshotBody "albums/2013_the_every_mile_made_yours_ep.textile" "html_lyrics")
        haml >>= applyAsTemplate lyricsContext >>= loadAndApplyTemplate "layout.html" defaultContext

    -- robots.txt
    match "robots.txt" $ route idRoute >> compile copyFileCompiler


sass :: Compiler (Item String)
sass = getResourceString >>= withItemBody (unixFilter "bundle" ["exec", "sass -s"]) >>= return . fmap compressCss

haml :: Compiler (Item String)
haml = getResourceString >>= withItemBody (unixFilter "bundle" ["exec", "haml -s -f html5"])

hamlTemplateCompiler :: Compiler (Item Template)
hamlTemplateCompiler = cached "Hakyll.Web.Template.templateCompiler" $ do
    item <- haml
    return $ fmap readTemplate item

coffee :: Compiler (Item String)
coffee = getResourceString >>= withItemBody (unixFilter "./coffee-compile" [])

openssl :: String -> Item String -> Compiler (Item String)
openssl pass = withItemBody (unixFilter "openssl" ["enc", "-aes-256-cbc", "-k", pass, "-e", "-base64"])

