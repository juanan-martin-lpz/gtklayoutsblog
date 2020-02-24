{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

module Main where
    
    import qualified GI.Gtk as Gtk
    import qualified GI.Gtk.Enums as Enums
    
    import Data.GI.Base
    import Data.Text
    import Control.Monad.IO.Class
    import GHC.Int

    -- creamos la ventana
    createWindow ::  MonadIO m => Text -> m Gtk.Window
    createWindow title = do
        win <- new Gtk.Window [ #title := title ]
        liftIO $ return win

    -- creamos un Box
    createBox :: MonadIO m => Enums.Orientation -> Int32 -> m Gtk.Box
    createBox orientation spacing = do
        box <-  if orientation == Enums.OrientationHorizontal then
                    new Gtk.Box [ #orientation := orientation, #spacing := spacing, #hexpand := True ]
                else
                    new Gtk.Box [ #orientation := orientation, #spacing := spacing, #vexpand := True, #hexpand := True ]
            
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
        Gtk.setWidgetHalign box Enums.AlignEnd

        aceptar <- new Gtk.Button [ #label := "Aceptar", #margin := 10 ]
        cancelar <- new Gtk.Button [ #label := "Cancelar", #margin := 10 ]

        #add box aceptar
        #add box cancelar
        liftIO $ return box

    main :: IO ()
    main = do
        Gtk.init Nothing

        win <- createWindow "Layouts Sample"
        on win #destroy Gtk.mainQuit

        box <- createBox Enums.OrientationVertical 10
        createBox Enums.OrientationVertical 10 >>= createInputArea >>= #add box
        createBox Enums.OrientationHorizontal 10 >>= createButtons >>= #add box

        #add win box

        #showAll win

        Gtk.main