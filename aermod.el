
;; define several class of keywords
(setq aermod-keywords '("CO" "SO" "RE" "ME" "EV" "OU") )
(setq aermod-types '("STARTING" "TITLEONE" "TITLETWO" "MODELOPT" "AVERTIME" "POLLUTID" "RUNORNOT" "FINISHED" "LOCATION" "SPCPARAM" "SRCGROUP" " SRCPARAM" "BUILDHGT" "BUILDWID" "GRIDPOLR" "GDIR" "ERRORFIL" "BUILDLEN" "XBADJ" "YBADJ" "EVENTPER" "EVENTLOC" "EVENTOUT" "SRCPARAM" "ELEVUNIT" "DISCCART" "PLOTFILE" "SEASONHR" "FILEFORM" "RECTABLE"))
(setq aermod-constants '("CONC" "FLAT" "PM25" "RUN" "ANNUAL" "SOCONT" "UNITHAP" "METERS" "POINT"  "ORIG" "DIST"))
(setq aermod-events '("SURFFILE" "PROFFILE" "SURFDATA" "UAIRDATA" "PROFBASE"))


;; create the regex string for each class of keywords
(setq aermod-keywords-regexp (regexp-opt aermod-keywords 'words))
(setq aermod-type-regexp (regexp-opt aermod-types 'words))
(setq aermod-constant-regexp (regexp-opt aermod-constants 'words))
(setq aermod-event-regexp (regexp-opt aermod-events 'words))

;; clear memory
(setq aermod-keywords nil)
(setq aermod-types nil)
(setq aermod-constants nil)
(setq aermod-events nil)

;; create the list for font-lock.
;; each class of keyword is given a particular face
(setq aermod-font-lock-keywords
  `(
    (,aermod-type-regexp . font-lock-type-face)
    (,aermod-constant-regexp . font-lock-constant-face)
    (,aermod-event-regexp . font-lock-builtin-face)
    ;; (,aermod-functions-regexp . font-lock-function-name-face)
     (,aermod-keywords-regexp . font-lock-keyword-face)
    ;; note: order above matters. ¡°mylsl-keywords-regexp¡± goes last because
    ;; otherwise the keyword ¡°state¡± in the function ¡°state_entry¡±
    ;; would be highlighted.
))

;; define the mode
(define-derived-mode aermod-mode fundamental-mode
  "aermod mode"
  "Major mode for editing US EPA AERMOD input files"

  ;; code for syntax highlighting
  (setq font-lock-defaults '((aermod-font-lock-keywords)))

  ;; clear memory
  (setq aermod-keywords-regexp nil)
  (setq aermod-types-regexp nil)
  (setq aermod-constants-regexp nil)
  (setq aermod-events-regexp nil)
;;  (setq aermod-functions-regexp nil)
)

;; template for CO pathway

(define-skeleton co-skeleton
"CO Pathway template file"
"CO Path:"
"CO STARTING \n"
"   TITLEONE  "(setq title1 (skeleton-read "TITLEONE:")) " \n"
"   TITLETWO  "(setq title2 (skeleton-read "TITLETWO:")) " \n"
"   MODELOPT  "(setq opt1 (skeleton-read "MODELOPT1:")) " "(setq opt2 (skeleton-read "MODELOPT2:")) " \n"
"   AVERTIME  "(setq time (skeleton-read "AVERAGING TIME:"))" "(setq period (skeleton-read "AVERAGING PERIOD:")) " \n"
"   POLLUTID  "(setq pol (skeleton-read "POLLUTID:")) "\n"
"   RUNORNOT  RUN \n"
"   ERRORFIL  ERRORS.OUT \n"
"CO FINISHED"
 )
;; define binding for CO pathway
(global-set-key [C-S-f1] 'co-skeleton)





;; function for running AERMOD from within Emacs shell
(global-set-key [C-S-f11]
                      (lambda ()
                        (interactive)
                        (shell-command "aermod"
(get-buffer-create "*Standard output*"))))




(provide 'aermod-mode)

;; I think the next step will be to create something that opens the output (maybe in abbreviated form?)

