;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Kevin caye"
      user-mail-address "kevin.caye@probayes.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 17 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;; :ui
(map! (:when (featurep! :ui popup)
       "C-<"   #'+popup/toggle
       "C-é"   #'+popup/raise
       "C-x p" #'+popup/other)

      (:when (featurep! :ui workspaces)
        :g "s-t"   #'+workspace/new
        :g "s-T"   #'+workspace/display
        :n "s-&"   #'+workspace/switch-to-0
        :n "s-é"   #'+workspace/switch-to-1
        :n "s-\""   #'+workspace/switch-to-2
        :n "s-'"   #'+workspace/switch-to-3
        :n "s-("   #'+workspace/switch-to-4
        :n "s--"   #'+workspace/switch-to-5
        :n "s-è"   #'+workspace/switch-to-6
        :n "s-_"   #'+workspace/switch-to-7
        :n "s-ç"   #'+workspace/switch-to-8
        :n "s-à"   #'+workspace/switch-to-final
        :n "s-<tab>"   #'+workspace/other

        :leader
        (:prefix-map ("TAB" . "workspace")
        :desc "Display tab bar"           "TAB" #'+workspace/display
        :desc "Switch to last workspace"          "a"   #'+workspace/other
        :desc "Search workspace"          "z"   #'+workspace/switch-to
        ;; for azerty keyboard
        :desc "Switch to worspace 0"          "&"   #'+workspace/switch-to-0
        :desc "Switch to workspace 1"          "é"   #'+workspace/switch-to-1
        :desc "Switch to worspace 2"          "\""   #'+workspace/switch-to-2
        :desc "Switch to worspace 3"          "'"   #'+workspace/switch-to-3
        :desc "Switch to worspace 4"          "("   #'+workspace/switch-to-4
        :desc "Switch to worspace 5"          "-"   #'+workspace/switch-to-5
        :desc "Switch to worspace 6"          "è"   #'+workspace/switch-to-6
        :desc "Switch to worspace 7"          "_"   #'+workspace/switch-to-7

        )

        ))

;;
;;; <leader>
(map! :leader
      (:when (featurep! :ui popup)
       :desc "Toggle last popup"     "é"    #'+popup/toggle)
      (:when (featurep! :ui workspaces)
      :desc "Switch to last buffer" "&"    #'evil-switch-to-windows-last-buffer))

;; windows
(define-key evil-window-map (kbd "<right>") 'evil-window-right)
(define-key evil-window-map (kbd  "<left>") 'evil-window-left)
(define-key evil-window-map (kbd "<up>") 'evil-window-up)
(define-key evil-window-map (kbd "<down>") 'evil-window-down)

;; org capture
;;
(after! org
  (add-to-list 'org-capture-templates
               '("m" "Meeting" entry (file "~/org/INBOX.org")
                 "* meeting with %? :MEETING:\n%U"
                 :clock-in t
                 :clock-resume t))
  ;; org tag
  (setq org-tag-alist (quote ((:startgroup)
                              ;; who is the client/owner ?
                              ("@probayes" . ?s)
                              ("@perso" . ?p)
                              (:endgroup)
                              )))
  ;; org agenda
  (setq org-agenda-files
        '("~/org/INBOX.org"
          "~/org/todo.org"
          "~/org/notes.org"
          "~/org/probayes/probayes.org"
          "~/org/probayes/framatome/framatome.org"
          "~/org/probayes/demoauto/demoauto.org"
          )
        )
  (set-popup-rule! "*Org Agenda*" :side 'right :size .40 :select t :vslot 2 :ttl 3)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  (setq org-log-state-notes-into-drawer t)

  (setq org-duration-units
        `(("min" . 1)
          ("h" . 60)
          ;; seven-hour days
          ("d" . ,(* 60 7))
          ;; five-day work week
          ("w" . ,(* 60 8 5))
          ;; four weeks in a month
          ("m" . ,(* 60 8 5 4))
          ;; work a total of 12 months a year --
          ;; this is independent of holiday and sick time taken
          ("y" . ,(* 60 8 5 4 12))))
)

(after! org
  (setq org-agenda-custom-commands
        '(("d" "Day" agenda "Day of work"
          (
           (org-agenda-span 1)
           (org-agenda-start-with-log-mode '(closed clock state))
           (org-agenda-start-with-clockreport-mode t)
           )
          )))
  )

(setq deft-recursive t)
(setq org-roam-tag-sources '(prop all-directories))

(after! notmuch
  (setq send-mail-function 'sendmail-send-it
        sendmail-program "/usr/bin/msmtp"
        mail-specify-envelope-from t
        message-sendmail-envelope-from 'header
        mail-envelope-from 'header
        notmuch-message-headers-visible t
        )
)
