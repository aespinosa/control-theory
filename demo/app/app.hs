{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import Yesod (warp, Yesod, yesodRunner,
              RenderRoute, Route, renderRoute,
              YesodDispatch, yesodDispatch,
              HandlerT)
import System.Random (randomRs, getStdGen, StdGen)
import Control.Monad.IO.Class (liftIO)


data App = App
instance Yesod App


instance RenderRoute App where
  data Route App = RootR
    deriving (Show, Eq, Read)
  renderRoute _ = ([], [])

instance YesodDispatch App where
  yesodDispatch env req = 
    yesodRunner handleRootR env Nothing req

randomNumbers :: StdGen -> [Float]
randomNumbers g = take 100 $ fmap sqrt $ randomRs (1.0, 1000.0) g

type Handler = HandlerT App IO

handleRootR :: Handler String
handleRootR = do
  seed <- liftIO $ getStdGen
  return $ show $ randomNumbers seed

main :: IO ()
main = warp 3000 App
