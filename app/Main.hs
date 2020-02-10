{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

module Main where
    
    import qualified GI.Gtk as Gtk
    import qualified GI.Gtk.Enums as Enums
    
    import Data.GI.Base
    import Data.Text
    import Control.Monad.IO.Class

    -- creamos la ventana
    createWindow ::  MonadIO m => Text -> m Gtk.Window
    createWindow title = do
        win <- new Gtk.Window [ #title := title ]
        liftIO $ return win

    -- creamos un Box
    createBox :: MonadIO m => Enums.Orientation -> m Gtk.Box
    createBox orientation = do
        box <- new Gtk.Box [ #orientation := orientation]
        liftIO $ return box   
    
    -- creamos componentes
    createInputArea :: MonadIO m => Gtk.Box -> m Gtk.Box
    createInputArea box = do
        label <- new Gtk.Label [ #label := "Sample Text"]
        textbox <- new Gtk.TextView []

        #add box label
        #add box textbox
        
        liftIO $ return box


    createButtons :: MonadIO m => Gtk.Box -> m Gtk.Box
    createButtons box = do
        aceptar <- new Gtk.Button [ #label := "Aceptar"]
        cancelar <- new Gtk.Button [ #label := "Cancelar"]

        #add box aceptar
        #add box cancelar
        liftIO $ return box


    main :: IO ()
    main = do
        Gtk.init Nothing

        win <- createWindow "Layouts Sample"
        on win #destroy Gtk.mainQuit

        box <- createBox Enums.OrientationVertical
        createBox Enums.OrientationVertical >>= createInputArea >>= #add box
        createBox Enums.OrientationHorizontal >>= createButtons >>= #add box

        #add win box

        #showAll win

        Gtk.main