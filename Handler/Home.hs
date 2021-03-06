module Handler.Home where

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}


import Yesod
import Control.Applicative

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              withSmallInput)
import Text.Julius (RawJS (..))

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Calculator API!"
        $(widgetFile "homepage")

getAddR :: Int -> Int -> Handler TypedContent
getAddR x y = selectRep $ do
	provideRep $ return
		[shamlet|  <p> Hi, with your input: #{x} + #{y} the answer is = #{result}|]
	provideRep $ return $ object
		[ "First value" .= x
		, "Second value" .= y
		]
	   where result = x + y

getSubR :: Int -> Int -> Handler TypedContent
getSubR x y = selectRep $ do
	provideRep $ return
		[shamlet|  <p> Hi, with your input: #{x} - #{y} the answer is = #{result}|]
	provideRep $ return $ object
		[ "First value" .= x
		, "Second value" .= y
		]
	   where result = x - y

getMultiR :: Int -> Int -> Handler TypedContent
getMultiR x y = selectRep $ do
	provideRep $ return
		[shamlet|  <p> Hi, with your input: #{x} * #{y} the answer is = #{result}|]
	provideRep $ return $ object
		[ "First value" .= x
		, "Second value" .= y
		]
	   where result = x * y

getDiviR :: Int -> Int -> Handler TypedContent
getDiviR x y = selectRep $ do
	provideRep $ return
		[shamlet|  <p> Hi, with your input: #{x} / #{y} the answer is = #{result}|]
	provideRep $ return $ object
		[ "First value" .= x
		, "Second value" .= y
		]
	   where result = x `div` y

postHomeR :: Handler Html
postHomeR = do
    ((result, formWidget), formEnctype) <- runFormPost sampleForm
    let handlerName = "postHomeR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing

    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Welcome To Yesod!"
        $(widgetFile "homepage")

sampleForm :: Form (FileInfo, Text)
sampleForm = renderBootstrap3 BootstrapBasicForm $ (,)
    <$> fileAFormReq "Choose a file"
    <*> areq textField (withSmallInput "What's on the file?") Nothing

commentIds :: (Text, Text, Text)
commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")
