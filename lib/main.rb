require 'gtk2'
require 'libglade2'
require 'rubygems'
require "mini_exiftool"
require "find"

class ExifItem
  attr_accessor :option, :value, :check
  def initialize(o, v); @option, @value = o, v; end
end

class ExifPl
  EXIFTAGS = {
    "FlashBits"=>"rozblyski flesza", 
    "RawFile"=>"Plik RAW",
    "CMSharpness"=>"Ostrosc CMS",
    "ColorFilter"=>"Filtr koloru",
    "Face7Position"=>"Pozycja twarzy7",
    "FocalType"=>"Typ ogniskowej",
    "FolderName"=>"Nazwa folderu",
    "Anti-Blur"=>"Technika Anti-Blur",
    "BestQualityScale"=>"najlepsza skala jakosci",
    "ImageOrientation"=>"Orientacja zdjecia",
    "OECFRows"=>"Wiersze OECF",
    "DriveMode"=>"Tryb sterownika",
    "CalibrationIlluminant1"=>"Kalibracja naslonecznienia1",
    "DurationValue"=>"Wartosc dzialania",
    "AELock"=>"Blokada AE",
    "FaceDetectFrameWidth"=>"Szerokosc obszaru detekcji twarzy",
    "CalibrationIlluminant2"=>"Kalibracja naslonecznienia2",
    "LocationShownCountryName"=>"Lokacja pokazuje nazwe panstwa",
    "CropHeight"=>"Wysykosc wycinania",
    "MaxApertureAtCurrentFocal"=>"Maksymalna apertura  przy biezacej ogniskowej",
    "JpgRecordedPixels"=>"Nagrane piksele JPG",
    "SanyoQuality"=>"Jakosc Sanyo",
    "LocalizedCameraModel"=>"Lokalny model aparatu",
    "NPages"=>"Strony N",
    "CCDScanMode"=>"Modal skanowania CCD",
    "SubjectDistance"=>"Odleglosc tematu",
    "RGBCurvePoints"=>"Punkty krzywych RGB",
    "ProgramLine"=>"Linia programowa",
    "ThumbnailLength"=>"Dlugosc miniatury",
    "Azimuth"=>"Azymut",
    "CCDVersion"=>"Wersja CCD",
    "RecognizedFace2Age"=>"Wiek rozpoznanej twarzy2",
    "Edition"=>"Edycja",
    "ColorMatrix"=>"Kolorowa Matryca",
    "MultiSample"=>"Multi-probkowanie",
    "AutoISO"=>"Automatyczy wspolczynnik ISO",
    "DateTime"=>"Data i czas",
    "AssignFuncButton"=>"Przycisk z prYpisana funkcja",
    "MonitorOffTime"=>"czas wylaczenia monitora",
    "Face1Position"=>"Poztcja twarzy1",
    "SaturationAdjustmentBlue"=>"Konfiguracja nasycenia- niebieski",
    "Location"=>"Polozenie",
    "DigitalZoomRatio"=>"Cyfrowy zoom optyczny",
    "PhotoEffectsType"=>"Typ efektu zdjecia",
    "WordCount"=>"Licznik swiatowy",
    "SceneMode"=>"Typ sceny",
    "People"=>"Ludzie",
    "ShotDate"=>"Data zrobienia zdjecia:",
    "ConvertToGrayscale"=>"Konwersja do skali szarosci",
    "FocalPlaneResolutionUnit"=>"Jednostka rozdzielczosci ogniskowej",
    "ManagedFromFilePath"=>"Sciezka zarzadzania",
    "MakerNoteSony"=>"Notatka Sony",
    "MonochromeFilterEffect"=>"Efekt filtra monochromatycznego",
    "PhotoEffectsBlue"=>"Efekt zdjecia - nibiski",
    "ColorReproduction"=>"Reprodukcja koloru",
    "JobID"=>"ID pracy",
    "ExposureLevelIncrements"=>"Poziom wzrostu ekspozycji",
    "OtherLicenseDocuments"=>"Inne dokumenty licencji",
    "OriginalDocumentID"=>"ID oryginalnego dokumentu",
    "DistortionCorrection"=>"Korekcja znieksztalcen",
    "GrayMixerOrange"=>"Mikser szary-pomaranczowy",
    "PreviewApplicationName"=>"Nazwa aplikacji podgladu",
    "ExternalFlashFlags"=>"Zewnetrzne flagi blysku",
    "MakerNoteKodak1a"=>"Notatka Kodak1a",
    "SharpnessFaithful"=>"Wiernosc ostrosci",
    "MakerNoteKodak1b"=>"Notatka Kodak1b",
    "AFAperture"=>"Apartura AFA",
    "SpecialMode"=>"Tryb specjalny",
    "VideoAlphaUnityIsTransparent"=>"Przezroczystosc VideoAlphaUnity",
    "ResampleParamsQuality"=>"Jakosc probkowania parametrow",
    "RecordingMode"=>"Tryb nagrywania",
    "FlashGroupAOutput"=>"Grupy rozblyskow na wyjsciu",
    "CameraType"=>"Typ aparatu",
    "LocationShownWorldRegion"=>"Lokalizacja pokazuje region swiata",
    "MaxSampleValue"=>"Maksymalna wartosc probki",
    "DynamicRangeOptimizerMode"=>"Zasieg trybu dynamicznej optymalizacji",
    "PhotoEffectsGreen"=>"Efekt zdjecia - zielony",
    "HighlightTonePriority"=>"Priorytet jasnych tonow",
    "SRHalfPressTime"=>"Polowiczny czas przycisniecia SR",
    "FlashSetting"=>"Ustawienia blysku",
    "ExifByteOrder"=>"Porzatej bajtow Exif",
    "ImageHistory"=>"Historia zdjecia",
    "PhoneNumber"=>"Numer telefonu",
    "ComplianceProfile"=>"Profile podporzadkowania",
    "GPSTrack"=>"Namiar GPS",
    "OtherLicenseInfo"=>"Inne dane licencji",
    "PanasonicExifVersion"=>"Wersja Exif panasonic",
    "TimerLength"=>"Dlugosc zegara",
    "CanonImageType"=>"Typ zdjecia canon",
    "PreviewHeight"=>"Wysokosc podgladu",
    "PreviewImageValid"=>"Poprawnosc podgladu zdjecia",
    "ApplicationNotes"=>"Notatki aplikacji",
    "ColorSequence"=>"Sekwebja kolorow",
    "FlashActivity"=>"Aktywnosc flesza",
    "BrightnessAdj"=>"Ustawienia jasnosci",
    "PF3Value"=>"Wartosc PF3",
    "GPSDestLatitudeRef"=>"Wysokosc GPS",
    "ActiveD-LightingMode"=>"Aktywnosc trybu D-ligthning",
    "MakerNoteOlympus"=>"Notatka Olympus",
    "GPSSpeedRef"=>"Predkosc GPS",
    "BracketMode"=>"Tryb koszykowy",
    "ShotLocation"=>"Lokacja zdjecia",
    "InternalFlashAE1_0"=>"Flesz zewnetrzny AE1_0",
    "RecordID" =>" ID nagrania",
    "ImageProcessing"=>"Przetwarzanie zdjecia",
    "RatingPercent"=>"Procent Oceny",
    "ShutterSpeedValue"=>"Predkosc przeslony",
    "PanoramaMode"=>"Tryb panoramiczny",
    "CopyrightNotice"=>"Prawa wlasnosci",
    "SelfTimerTime"=>"Czas wewnetrznego zegara",
    "FileName"=>"Nazwa pliku",
    "SharpnessStandard"=>"Standard ostrosci",
    "KodakInfoType"=>"Typ informacji Kodak",
    "AEExposureTime"=>"Czas ekspozycji AE",
    "ProductionCode"=>"Kod produkcji",
    "SequenceShotInterval"=>"Przerwa sekwencji zdjec",
    "StartingPage"=>"Strona startowa",
    "Thresholding"=>"Progowanie",
    "LinearResponseLimit"=>"Limit odpowiedzi liniowej",
    "TransferFunction"=>"Funkcja przekazania",
    "Unsharp3Intensity"=>"Intensywnosc Unsharp3",
    "GPSProcessingMethod"=>"Metoda obliczania GPS",
    "LicenseeImageID"=>"ID licencji zdjecia",
    "PreviewImageName"=>"Nazwa podgladu",
    "Face3Position"=>"Pozycja twarzy3",
    "ColorTempCustom"=>"Temperatura kolorow uzytkownika",
    "License"=>"Licencja",
    "LicensorPostalCode"=>"Kod pocztowy licencjonera",
    "CreditLine"=>"Linia kredytowa",
    "PageRange"=>"Zasieg stron",
    "OutputImageWidth"=>"Wyjsciowa szerokosc zdjecia",
    "ColorTempShade"=>"temperatura kolorow cieni",
    "ApplicationRecordVersion"=>"Wersja programu nagrywajacego",
    "MakerNoteSanyo"=>"Notatka Sanyo",
    "CropHiSpeed"=>"Duża predkosc wycinania",
    "LCDPanels"=>"panele lcd",
    "ServiceIdentifier"=>"identyfikator uslugi",
    "ColorProfile"=>"profil koloru",
    "PictureControlName"=>"nazwa kontrolna obrazka",
    "FlashExposureLock"=>"Blokada ekspozycji flesza",
    "RelatedImageWidth"=>"Szerokosc powiazanego zdjecia",
    "ModifyDate"=>"modyfikator daty",
    "MinoltaImageSize"=>"rozmiar zdjecia - minolta",
    "ManualExposureTime"=>"manualny czas naswietlania",
    "ViewfinderWarning"=>"widok odnajdywania ostrzezen",
    "FilterEffect"=>"efekt filtra",
    "DevelopmentDynamicRange"=>"dynamiczny zasieg rozwoju",
    "CropBottom"=>"gora obcinania",
    "SaturationAdjustmentOrange"=>"Zasieg kontroli naswietlania",
    "EpsonSoftware"=>"program Epson",
    "LocationCreatedCountryName"=>"nazwa kraju stworzonej lokacji",
    "StartTimecodeTimeFormat"=>"czas startu i foramt czasu",
    "SceneModeUsed"=>"uzyto trybu sceny",
    "DestinationCityCode"=>"kod miasta przeznaczenia",
    "FirstPublicationDate"=>"pierwsza data publikacji",
    "SoftwareVersion"=>"wersja oprogramowania",
    "ExternalFlashBounce"=>"zewnetrzne oswietlenie",
    "ExposureMode"=>"tryb naswietlania",
    "ExternalFlashAE2_0"=>"zewnetrzny flesz AE2_0",
    "UserDef1PictureStyle"=>"styl zdjecia definiowany rpzez uzytkownika",
    "AFAssistLamp"=>"lampa przy AF",
    "CorporateEntity"=>"dane korporacji",
    "AntiAliasStrength"=>"sila anty aliasingu",
    "RegionRectangle"=>"kwadrat regionu",
    "DynamicRangeMax"=>"dynamiczny zasieg MAX",
    "SelfTimer2"=>"wenetrzny zegar2",
    "Identifier"=>"identyfikator",
    "ManagedFromDocumentID"=>"stworzono z dokumentu ID",
    "ShadingCompensation"=>"kompensacja cieni",
    "AutoRotate"=>"auto obrot",
    "ShakeReduction"=>"redukcja wstrzasow",
    "AEProgramMode"=>"tryb programowy AE",
    "TermsAndConditionsText"=>"Warunki gwarancji",
    "Engineer"=>"mechanika",
    "FontFamily"=>"czcionka rodzinna",
    "PageImageFormat"=>"format zdjecia strony",
    "SensorTemperature"=>"czujnik temperatury",
    "ModifiedSaturation"=>"modyfikowany balans bieli" ,
    "MakerNoteUnknown"=>"nieznany tworca notatki",
    "YResolution"=>"rozdzielczosc Y",
    "DotRange"=>"zasieg punktu/kropki",
    "LCDDisplayAtPowerOn"=>"LCD wlaczony",
    "ColorTempFlash"=>"temperatura kolorow flesza",
    "MonochromeSharpness"=>"ostrosc monochromatyczna",
    "RegistryOrganisationID"=>"organizacja rejestru ID",
    "RicohImageHeight"=>"Wysokosc zdjecia - Ricoh",
    "MediaConstraints"=>"powiazania mediow",
    "MakerNoteSigma"=>"tworca notki - Sigma",
    "RelatedVideoFileName"=>"nazwa powiazanego pliku wideo",
    "FacePositions"=>"pozycje twarzy",
    "CropSourceResolution"=>"zrodlo rozdzielczosci obcinania",
    "FontType"=>"typ czcionki",
    "ProgramVersion"=>"wersja programu",
    "UV-IRFilterCorrection"=>"korekcyjny filtr UV-IR",
    "SubjectLocation"=>"lokalizacja tematu",
    "Instructions"=>"instrukcje",
    "AdvancedSceneMode"=>"tryb zaawansowanej sceny",
    "ExternalSensorBrightnessValue"=>"wartosc zewnetrznego czujnika jasnosci",
    "VibrationReduction"=>"redukcja wibracji",
    "FocusStepNear"=>"najblizszy krok skupienia",
    "VersionsVersion"=>"wersja wersji",
    "WhiteLevel"=>"poziom bieli",
    "RelatedVideoFileType"=>"typ powiazanego pliku wideo",
    "UserFields"=>"pola uzytkownikow",
    "TimeCreated"=>"czas stworzenia",
    "ArtworkDateCreated"=>"data stworzenia sztuki",
    "WorkColorSpace"=>"kolor miejsca pracy",
    "IsCorrectionOf"=>"czy korekcja wylaczona",
    "HometownCity"=>"miasto rodzinne",
    "VersionsEventSoftwareAgent"=>"wersja programu agenta wydarzen",
    "CatalogSets"=>"ustawione katalogi",
    "PictureControlMode"=>"tryb kontroli obrazka",
    "ColorTempPC1"=>"temperatura kolorow PC1",
    "LightSource"=>"zrodlo swiatla",
    "Unsharp2Intensity"=>"intensywnosc Unsharp2",
    "ManufactureDate"=>"data produkcji",
    "ColorTempPC2"=>"temperatura kolorow PC2",
    "InstantPlaybackTime"=>"czas natychmiastowego odtwarzania",
    "CropWidth"=>"szerokosc obcinania",
    "MakerNoteRicoh"=>"tworca notki -Ricoh",
    "ColorTempPC3"=>"temperatura kolorow PC3",
    "CardShutterLock"=>"blokada zatrzasku karty",
    "PhotoEffects"=>"efekty zdjecia",
    "ColorControl"=>"kontrola kolorow",
    "StudyDateTime"=>"data i czas uczenia",
    "ColorPlanes"=>"kolory planow",
    "Label"=>"etykieta",
    "RegistryItemID"=>"ID przedmiotow rejestru",
    "PanoramaFrameNumber"=>"numer klatki panoramy",
    "FocusMode"=>"Tryb ostrosci",
    "LocationCreatedSublocation"=>"tworzenie podlokacji",
    "CustomWBSetting"=>"ustawienia uzytkownika balansu bieli",
    "Keyword"=>"slowo kluczowe",
    "WhiteBalanceComp"=>"porownanie balansu bieli",
    "VideoColorSpace"=>"miejsce koloru wideo",
    "RecognizedFace2Position"=>"pozycja rozpoznanej twarzy2",
    "Highlight"=>"jasnosc",
    "MacroMode"=>"tryb makro",
    "MirrorLockup"=>"lustrzane odbicie",
    "Rights"=>"prawa",
    "InkSet"=>"zestaw tuszu",
    "FlashMetering"=>"matowy flesz",
    "WorldTimeLocation"=>"lokacja czasu swiatowego",
    "Elevation"=>"wzniesienie",
    "FlashGuideNumber"=>"numer przewodnika flash",
    "ColorTemperature"=>"temperatura barw",
    "Teaser"=>"lamiglowka",
    "Event"=>"wydarzenie",
    "FlashDistance"=>"oddalenie flesza",
    "GreenSaturation"=>"nasycenie zieleni",
    "GreenHue"=>"barwa zielona",
    "FlashOutput"=>"wyjscie flesza",
    "Sharpness"=>"ostrosc",
    "HasCorrection"=>"posiada korekcje",
    "DateTimeStamp"=>"data i czas znaczka",
    "OlympusImageWidth"=>"szerokosc zdjec Olympus",
    "SceneCaptureType"=>"typ przejmowania sceny",
    "CompressionRatio"=>"wspolczynnik kompresji",
    "MinoltaModelID"=>"ID modelu Minolta",
    "SubjectProgram"=>"program tematyczny",
    "AudioSamplingRate"=>"czestoliwosc probkowania audio",
    "RelatedImageHeight"=>"wysokosc powiazanego zdjecia",
    "LocationShownCountryCode"=>"lokacja pokazuje kod kraju",
    "SelfTimerMode"=>"tryb wenetrznego zegara",
    "Duration"=>"czas dzialania",
    "CameraID"=>"ID aparatu",
    "PageName"=>"nazwa strony",
    "ImageSize"=>"Rozmiar Obrazu",
    "Warning"=>"Ostrzezenie",
    "Author"=>"Autor",
    "FileSource"=>"Zrodlo pliku",
    "Flash"=>"Flesz",
    "UserComment"=>"Komentarz Użytkownika",
    "Directory"=>"Katalog",
    "Orientation"=>"Orientacja"
  }

  def self.pl_tag_name(str)
    EXIFTAGS[str]
  end

  def self.ang_tag_name(str)
    EXIFTAGS.index str
  end
end

class Exif
    
  attr_accessor :exif_data

  def initialize(f)
    @exif_data = MiniExiftool.new(f)
    @exif_data['Author'] = ' ' if @exif_data['Author'] == nil
    @exif_data['Comment'] = ' ' if @exif_data['Comment'] == nil
    @exif_data.save
    @exif_data.reload
  end

  def save list_store, filename, dialog, error
    options = Hash.new
    options_rek = Hash.new
    list_store.each do |model, path, iter|
      check = list_store.get_value(iter, 2)
      check_r = list_store.get_value(iter, 3)
      option = list_store.get_value(iter, 0).to_s
      option_tmp = ExifPl.ang_tag_name option
      option = option_tmp if option_tmp
      value = list_store.get_value(iter, 1).to_s
      options[option] = value if check
      options_rek[option] = value if check_r
    end
    dir_options(options, filename) if !options.empty?
    dir_options_rek(options_rek, filename) if !options_rek.empty?
    ret = @exif_data.save
    if ret
      dialog.run
      dialog.destroy
    else
      error.run
      error.destroy
    end
  end

  def dir_options options, filename
    dir = File.dirname filename if !File.directory?(filename)
    dir = filename if File.directory?(filename)
    regexp = Regexp.new(/\.(JPG)/)
    Dir.foreach(dir.to_s){ |file|
      if  !File.directory?(file) && regexp.match(file.to_s.upcase)
        exif_tmp = MiniExiftool.new "#{dir.to_s}/#{file.to_s}"
        options.each{|opt, val| exif_tmp[opt] = val}
        exif_tmp.save
      end
    } if File.directory?(dir)
  end

  def dir_options_rek options, filename
    dir = File.dirname filename
    Find.find(dir){|file|
      dir_options options, file if File.directory?(file)
    }
  end

  def load_options list_store, optio, array
    #optio = optio.clear
    @exif_data.to_hash.each { |opt, val|
      pl = ExifPl.pl_tag_name opt.to_s
      optio << ExifItem.new(opt.to_s, val.to_s) if pl.nil?
      optio << ExifItem.new(pl, val.to_s) if pl
    }
    optio.each_with_index do |o, v|
      iter = list_store.append
      list_store.set_value(iter, 0, array[v].option)
      list_store.set_value(iter, 1, array[v].value)
    end
  end
end

class Exif_Editor
  TITLE = "Edytor Exif"
  NAME = "Exif_Editor"
  VERSION = "0.1"
  #attr_accessor :array
  @array
  def initialize(path)    
    @exif
    @glade = GladeXML.new(path) {|handler| method(handler)}
    initialize_toolbar @glade
    @array = Array.new
    @list=@glade.get_widget("treeview1")
    @list.rules_hint=true
    @list_store = Gtk::ListStore.new(String, String, TrueClass, TrueClass)
    @list.model=@list_store
    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new("Opcja", renderer,'text' => 0)
    column.resizable = true
    @list.append_column(column)
    renderer = Gtk::CellRendererText.new
    renderer.editable = true
    renderer.signal_connect('edited') do |w, s1, s2 |
      cell_edited(s1, s2, @list)
    end
    column = Gtk::TreeViewColumn.new("Wartość", renderer, 'text' => 1)
    column.resizable = true
    @list.append_column(column)
    renderer2 = Gtk::CellRendererToggle.new
    renderer2.signal_connect('toggled') do |rend, path |
      cell_toggled(rend, path, @list)
    end
    column = Gtk::TreeViewColumn.new("Katalog", renderer2, :active => 2)
    column.resizable = true
    @list.append_column(column)
    renderer3 = Gtk::CellRendererToggle.new
    renderer3.signal_connect('toggled') do |rend, path |
      cell_toggled_rek(rend, path, @list)
    end
    column = Gtk::TreeViewColumn.new("Podkatalogi", renderer3, :active => 3)
    column.resizable = true
    @list.append_column(column)
    @appwindow = @glade.get_widget("window1")
    @appwindow.show_all
    @openfile = @glade.get_widget("filechooserdialog1")
    @filechoser_open = @glade.get_widget("button2")
    initialize_filechooser
    @image = @glade.get_widget("image1")
    @tree = @glade.get_widget("treeview1")
    @okdialog =  @glade.get_widget("dialog1")
  end

  def initialize_toolbar glade
    tb = glade.get_widget("toolbar1")
    tb.toolbar_style = Gtk::Toolbar::Style::ICONS
    open = Gtk::ToolButton.new(Gtk::Stock::OPEN)
    open.tooltip_text = "Otwórz"
    save = Gtk::ToolButton.new(Gtk::Stock::SAVE)
    save.tooltip_text = "Zapisz"
    tb.insert(0, open)
    tb.insert(1, save)
    open.signal_connect('clicked') {on_file_open}
    save.signal_connect('clicked') {on_file_save}
  end

  def initialize_ok_dialog

  end

  def initialize_filechooser
    @openfile.current_folder = GLib.home_dir
    filter1 = Gtk::FileFilter.new
    filter2 = Gtk::FileFilter.new
    filter1.name = "JPEG"
    filter2.name = "Wszystkie"
    filter1.add_pattern('*.jpg')
    filter1.add_pattern('*.JPG')
    filter1.add_pattern('*.JPEG')
    filter1.add_pattern('*.jpeg')
    filter2.add_pattern('*')
    @openfile.add_filter filter1
    @openfile.add_filter filter2
  end

  def on_window_destroy
    Gtk.main_quit
  end

  def on__ok_dialog
    @okdialog.destroy
  end

  def cell_edited(path, str, trvu)
    if str != ""
      iter = trvu.model.get_iter(path)
      iter[1] = str
      option_tmp = ExifPl.ang_tag_name iter[0].to_s
      option = option_tmp if option_tmp
      @exif.exif_data[option] = str
    end
  end

  def cell_toggled(obj, path, trvu)
    if obj.active?
      iter = trvu.model.get_iter(path)
      iter[2] = false
    else
      iter = trvu.model.get_iter(path)
      iter[2] = true
    end
  end

  def cell_toggled_rek(obj, path, trvu)
    if obj.active?
      iter = trvu.model.get_iter(path)
      iter[3] = false
    else
      iter = trvu.model.get_iter(path)
      iter[3] = true
    end
  end

  #Plik -> Otwórz
  def on_file_open
    @openfile.run    
  end

  def on_file_save
    error = Gtk::MessageDialog.new(nil, Gtk::Dialog::MODAL |
      Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::ERROR,
      Gtk::MessageDialog::BUTTONS_CLOSE, "Dane nie zostały zmodyfikowane.")
    info = Gtk::MessageDialog.new(nil, Gtk::Dialog::MODAL |
      Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::INFO,
      Gtk::MessageDialog::BUTTONS_CLOSE, "Plik został poprawnie zapisany.")
    @exif.save @list_store, @openfile.filename, info, error
  end

  def on_filechooser_open(widget)
    @array = @array.clear
    filename = @openfile.filename
    pixbuf = Gdk::Pixbuf.new filename, 300, 300
    @image.pixbuf = pixbuf
    @exif = Exif.new filename
    @list_store.clear
    @exif.load_options(@list_store, @array, @array)
    @openfile.hide
  end

  def on_filechooser_anuluj(widget)

    @openfile.hide
  end

  #O programie
  def on_about(widget)
    Gnome::About.new(TITLE, VERSION ,
      "",
      "Edytor umożliwia odczyt i edycję EXIF",
      ["Prawda Michał", "Wiśniewski Mariusz"], ["Dokumentacji Brak :)"], nil).show
  end
end

Gnome::Program.new(Exif_Editor::NAME, Exif_Editor::VERSION)
Exif_Editor.new("/home/maykel/Projekty/projekt1/projekt1.glade")

Gtk.main