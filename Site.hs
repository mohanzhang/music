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

    match "sass/_*" $ compile $ makeItem ()
    match "sass/main.sass" $ do
      route $ gsubRoute "sass/" (const "css/") `composeRoutes` setExtension "css"
      compile sass

    -- page template
    match "layout.html" $ compile templateCompiler

    -- partials
    match "partials/*.html" $ compile getResourceString
    match "partials/*.haml" $ compile haml

    match "index.haml" $ do
      route $ setExtension "html"
      compile $ do
        haml >>= loadAndApplyTemplate "layout.html" fullContext

    -- robots.txt
    match "robots.txt" $ route idRoute >> compile copyFileCompiler


fullContext :: Context String
fullContext = mconcat [
    field "footer" (\_ -> loadBody "partials/footer.haml")
  , field "typekit" (\_ -> loadBody "partials/typekit.html")
  , field "analytics" (\_ -> loadBody "partials/google_analytics.html")
  , defaultContext
  ]

sass :: Compiler (Item String)
sass = getResourceString >>= withItemBody (unixFilter "bundle" ["exec", "sass -s"]) >>= return . fmap compressCss

haml :: Compiler (Item String)
haml = getResourceString >>= withItemBody (unixFilter "bundle" ["exec", "haml -s -r coffee-filter -f html5"])

hamlTemplateCompiler :: Compiler (Item Template)
hamlTemplateCompiler = cached "Hakyll.Web.Template.templateCompiler" $ do
    item <- haml
    return $ fmap readTemplate item

coffee :: Compiler (Item String)
coffee = getResourceString >>= withItemBody (unixFilter "./coffee-compile" [])

openssl :: String -> Item String -> Compiler (Item String)
openssl pass = withItemBody (unixFilter "openssl" ["enc", "-aes-256-cbc", "-k", pass, "-e", "-base64"])

