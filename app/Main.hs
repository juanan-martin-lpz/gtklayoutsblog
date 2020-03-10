{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

module Main where
    
    import qualified GI.Gtk as Gtk
    import qualified GI.Gtk.Objects.Dialog as Dlg
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
    createWidgets :: MonadIO m => Gtk.Window -> m Gtk.Box
    createWidgets win = do
        -- main box
        box <- createBox Enums.OrientationVertical 10

        -- box para botones
        boxbuttons <- createBox Enums.OrientationHorizontal 10
        -- botones
        aceptar <- new Gtk.Button [ #name := "btn_aceptar", #label := "Aceptar", #margin := 10 ]
        cancelar <- new Gtk.Button [ #name := "btn_cancelar", #label := "Cancelar", #margin := 10 ]
        -- box para componentes
        boxcompo <- createBox Enums.OrientationVertical 5
        label <- new Gtk.Label [ #label := "Sample Text"]
        textbox <- new Gtk.Entry [ #marginLeft := 10, #marginRight := 10, #placeholderText := "Teclee algo y pulse aceptar..."]

        -- Manejamos el evento clicked del boton aceptar
        on aceptar #clicked $ do
            -- Leemos el contenido del textbox para mostrarlo en la msgbox
            ebuffer <- Gtk.entryGetBuffer textbox
            text <- Gtk.entryBufferGetText ebuffer
            -- Creamos una caja de mensajes
            msg <- new Gtk.MessageDialog [ #text := text, #buttons := Enums.ButtonsTypeOk ]
            Dlg.dialogRun msg       -- la mostramos ...
            Gtk.windowClose msg     -- ... y la cerramos al hacer click en Ok
            return ()

        on cancelar #clicked $ do
            -- Eliminamos el contenido del textbox
            ebuffer <- Gtk.entryGetBuffer textbox
            Gtk.entryBufferSetText ebuffer "" (-1)
            return ()
    

        -- anadimos los botones
        #add boxbuttons aceptar
        #add boxbuttons cancelar
        -- anadimos el resto de widgets
        #add boxcompo label
        #add boxcompo textbox
        -- anadimos las cajas a la caja principal
        #add box boxcompo
        #add box boxbuttons
        
        Gtk.windowSetFocus win $ Just aceptar

        liftIO $ return box


    main :: IO ()
    main = do
        -- inicializamos Gtk
        Gtk.init Nothing

        -- creamos una ventana y asignamos el proceso de cierre a la destruccion de la ventana
        win <- createWindow "Layouts Sample"
        on win #destroy Gtk.mainQuit

        -- creamos los widgets y los anadimos a la ventana
        box <- createWidgets win
        #add win box
        -- mostramos la ventana
        #showAll win

        -- Gtk main loop
        Gtk.main