{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

module Main where
    
    import qualified GI.Gtk as Gtk
    import Data.GI.Base

    main :: IO ()
    main = do
        Gtk.init Nothing

        win <- new Gtk.Window [ #title := "Hi there" ]

        on win #destroy Gtk.mainQuit

        -- Forma alternativa
        -- Gtk.onWidgetDestroy win $ do Gtk.mainQuit

        button <- new Gtk.Button [ #label := "Click me" ]

        on button #clicked (set button [ #sensitive := False, #label := "Thanks for clicking me" ])

        -- Version alternativa
        -- Gtk.onButtonClicked button $ do
        --     button `set ` [ #sensitive := False, #label := "Thanks for clicking me" ]

        #add win button

        #showAll win

        Gtk.main