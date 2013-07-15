;; Copyright (C) 1996 Stephen Eglen
;; Author:       Stephen Eglen, stephene@cogs.susx.ac.uk
;; Maintainer:   Stephen Eglen, stephene@cogs.susx.ac.uk
;; Keywords:     tools extensions
;; Created:      Apr 15 1996

;; LCD Archive Entry:
;; sje-switch-buffer|Stephen Eglen|stephene@cogs.susx.ac.uk|
;; Switch between buffers using substrings|
;; 22-Apr-1996|$Revision: 1.10 $|~/misc/sje-switch-buffer.el.Z|

;;; COPYRIGHT NOTICE
;;;
;;; This program is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the Free
;;; Software Foundation; either version 2 of the License, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;;; for more details.
;;;
;;; You should have received a copy of the GNU General Public License along
;;; with GNU Emacs.  If you did not, write to the Free Software Foundation,
;;; Inc., 675 Mass Ave., Cambridge, MA 02139, USA.


;;; Installation
;;;
;;; (require 'sje-switch-buffer)
;;; to load the functions.
;;;
;;; To override the default functions bound to C-x b, C-x 4 b, and
;;; C-x 5 b, call the following function
;;; (sje-switch-buffer-default-keybindings nil)
;;; or (sje-switch-buffer-default-keybindings 'iswitch)

;;; iswitch is a slightly neater version that gives you a list of
;;; matching buffers as you type, but buffer name completion is not
;;; available.  (I recommend the iswitch version!)

;;; Commentary:

;;; Overview

;;; This code provides a simple extension to the buffer switching
;;; functions so that you can specify the buffer using a substring as
;;; well as still using the full name of the buffer.  There are two
;;; slightly different versions available here: Using the iswitch
;;; version you can see the matching buffers as you type the
;;; substring, whereas with the switch version you can use tab for
;;; completion on buffer names in the normal fashion.

;;; Only tested on emacs 19.27 and Xemacs 19.14

;;; Switch or iswitch?

;;; Switch has the advantage that tab can be used to complete on
;;; buffer names. Iswitch on the other hand offers a list of possible
;;; buffers that currently match the substring typed by the user.  It
;;; also allows you to change the order of preference of the
;;; buffers. eg to edit the second most recent .c file, you can type:
;;; .c and then ^s to make the second c file become top of the list
;;; which can then be selected by pressing TAB.

;;; Switch -- How it works.

;;; When switching buffers, you can still use completion to select a
;;; buffer, or type in its full name.  However, you can also type a
;;; substring to specify a buffer.  So, if you have the following
;;; buffers (in order):

;;; file.c		(most recent)
;;; makefile
;;; file.l
;;; file.h
;;; file.data

;;; Typing "data" will take you to the most recent buffer containing
;;; the string "data", whereas "ake" would take you to the makefile.
;;; Using a substring rather than using the full name can be quicker
;;; when you can think of a useful substring (eg, type .c to go back
;;; to the most recent c file, shell, to take you back to the most
;;; *shell* buffer.)

;;; Also, with the confirm option, you can step through the buffer
;;; names matching your substring until you find the buffer that you
;;; are looking for. So, if you have three C files open, typing .c
;;; will give you the option of going to the newest C buffer.  If you
;;; dont want the newest C file, you can then go to the second newest
;;; buffer, and so on.

;;; Creating new buffers.
;;;
;;; If no buffer matches the substring, the default behaviour is to
;;; ask you if you want to create a new buffer.  If you dont ever want
;;; to be asked if you want to switch to a new buffer, set
;;; sje-switch-buffer-prompt-newbuffer to nil.
;;;
;;; If C-u (with default arg of 4) is given, if the buffer name typed
;;; in does not exactly match an existing buffer, a new buffer is
;;; created.  To allow substring matching of buffers when you want to
;;; create new buffers also, set sje-switch-buffer-create-substring to
;;; a non nil value.  For example, by default if you want to create a
;;; new buffer "ail", you could type "ail", and if the buffer does not
;;; exist, it will be created.  However, if
;;; sje-switch-buffer-create-substring is set to a non nil value, the
;;; new buffer "ail" will only be created if "ail" is not a substring
;;; of any buffer name. So in this case, if there is a buffer called
;;; RMAIL, we will switch to this buffer, rather than create the new
;;; buffer "ail".

;;; Options
;;; -------
;;; The buffer switching has a couple of options coded as variables.

;;; Substring confirmation

;;; If confirm is nil, we switch to the newest buffer matching the
;;; substring.  Otherwise, the user will be prompted if the buffer
;;; matching the substring is the required buffer.  If the user
;;; answers negative, the next function continues to look for the next
;;; buffer matching the substring.

;;; A tweak to the confirmation is that if sje-switch-buffer-confirm
;;; is set to 'if-multiple, then it will only ask for confirmation if
;;; there is more than one match.

;;; No confirming means that the user doesnt need an extra key press
;;; to confirm the switch to the new buffer.  However, with the
;;; confirm option, if the most recent buffer matching the substring
;;; is not the one you want, you get the chance to ignore the buffer
;;; in continue searching through the older buffers.

;;; Substring searching - exact or regexp

;;; By default, the substring search is an exact match, rather than a
;;; regexp match, but this can be changed by setting the variable
;;; sje-switch-buffer-regexp to a non nil value.  Regexp searching is
;;; more powerful, but then certain characters (most commonly . which
;;; appears quite often in filenames) need to be prefixed by a slash,
;;; eg if you are looking for the most recent .el file you would need
;;; to type \.el rather than just .el (because this may get you the
;;; shell buffer for example).

;;; Ignoring certain buffer names

;;; The variable sje-switch-buffer-ignore can be set to ignore certain
;;; buffer names when it is looking through the substring match.  This
;;; normally is set to ignore file names beginning with a space. Eg to
;;; ignore substring searching in C source files as well you could do:
;;; (setq sje-switch-buffer-ignore  '("^ " "\\.c"))

;;; You can also provide functions to see if a buffer should be
;;; ignored.  The function should accept one argument, the buffer
;;; name, and return true if that buffer should be ignored during
;;; substring searching.  For example, we can ignore all buffers in C
;;; mode by using the following function:

;(defun ignore-c-mode (name)
;  "ignore all c mode buffers"
;  (save-excursion
;    (set-buffer name)
;    (string-match "^C$" mode-name)))
;
; (setq sje-switch-buffer-ignore '("^ " ignore-c-mode ))

;;; Prefix args:
;;; The following prefix args can be used to modify the effect of
;;; buffer switching.

;;; C-u 2 - toggle value of sje-switch-buffer-regexp before doing search
;;; C-u 3 - toggle value of sje-switch-buffer-confirm before doing search
;;; C-u 4 - create buffer if no buffer exists with the exact name "substring"

;;; When using these, C-u takes a default value of 4, so the 4 does not
;;; need to be specified.


;;; Iswitch

;;; As you type in the substring for a buffer match, the buffers
;;; currently matching the substring are displayed as you type.  This
;;; is inspired by the code written by Michael R Cook
;;; <mcook@cognex.com>.  The difference between this code and
;;; Michael's is that his looks for exact matches rather than
;;; substring matches.  Jari should take credit for creating this
;;; function based on Michael's.


;;; Example, say you are looking for a file called "file.c"
;;; when you first use the iswitch function you get a default suggestion
;;; which is the "other-buffer"
;Switch to buffer: file.h
;Then I type "i", so this gives me all buffers with "i" in the name:

;Switch to buffer: i  {file.h,sje-switch-buffer.el,file.data,file.c,
;expanding.tex,intro.tex,gen.bib,biol.tex,,*Warnings*...} 

;now I type "l" and I get just a few selections left
;Switch to buffer: il  {file.h,file.data,file.c,MAIL,*mail*}
;and at this point,  I can either type "e.c" to specify the c file, or 
;just hit ctrl-s twice so that file.c is at the top of the list:

;(C-s) Switch to buffer: il  {file.data,file.c,MAIL,*mail*,file.h}
;(C-s) Switch to buffer: il  {file.c,MAIL,*mail*,file.h,file.data}

;and finally, I can press TAB to select the first item in the list!

;;; Whilst you are searching, when you press return, the current prompt is
;;; normally selected. But if there is only one match in list, then that
;;; buffer is selected.
;;; in the list matching your substring is selected.  If there are no
;;; matches, you have the option of creating a new buffer.
;;; Also, the following keys are useful:
;;;
;;; RET         Pick the _only_ selection in list OR current prompt.
;;;		If sje-iswitch-allow-ret is non nil, RET will also
;;;		pick the first selection in the list.
;;; C-q         (q)uote, select the prompt "as is"
;;; TAB         Pick _first_ selection in list. (Cycle list with C-d,C-s)
;;; C-r 	switch between (r)egexp matching and exact matching
;;; C-s/SPC	put first matching buffer at the end of the list of
;;;		matching buffers.
;;; C-d	        put last matching buffer at the start of the list.
;;; C-c		switch between (c)ase folding and case sensitive searching.
;;;		See variable sje-iswitch-case-fold-search for default behavior.
;;; C-a		toggle (a)ll: ignore sje-switch-buffer-ignore filter
;;; C-g		Quit.


;;; Thanks to many people for comments.  Copy should also be
;;; available on: http://www.cogs.susx.ac.uk/users/stephene/emacs/

;;; History:


;;; Sat 27 Jul 96
;;; iswitch version released

;;; Tue Jun 11 1996
;;; sje-switch-buffer-ignore now accepts functions as well as
;;; regexps, so that you can use functions to decide whether a buffer
;;; is to be ignored, as well as regexp matching of buffer name.
;;; Also will now prompt you if you want to create a new buffer rather
;;; than relying on a prefix argument. This prompt can be disabled
;;; with sje-switch-buffer-prompt-newbuffer.  Thanks to Jari for these
;;; suggestions.

;;; Mon Apr 22 1996

;;; sje-switch-buffer-ignore regexp added, so that it ignores certain
;;; buffer names, eg those beginning with space.
;;; Added 'if-multiple option for the confirmation variable, so that
;;; if only one buffer matches substring, we do not ask for confirmation.
;;; Delayed evaluation of buffer-names until necessary (Thanks to
;;; Wayne Mesard <wmesard@esd.sgi.com> for mods).

;;; Mon Apr 15 1996

;;; Added provide line and also taken keybindings out into a separate
;;; defun.  Thanks to Christian Moen <christim@ifi.uio.no>, and Jari
;;; Aalto <jaalto@tre.tele.nokia.fi> for suggesting this.

;;; Code:


;;;  Variables storing defaults

(defvar sje-iswitch-case-fold-search
  nil
  "*Case folding search for iswitch function. Non nil if searches should
 ignore case")

(defvar sje-switch-buffer-ignore
  '("^ ")
  "*List of regexps or functions matching buffer names to ignore.  For
example, traditional behavior is not to list buffers whose names begin
with a space, for which the regexp is \"^ \".  See the source file for
example functions that filter buffernames.")

(defvar sje-switch-buffer-regexp nil
"*Control whether the sje-switch-buffer does an exact or regexp search.
Non nil values mean do regexp searching.")

(defvar sje-switch-buffer-confirm nil
"*If nil, we dont ask for confirmation for switching to the buffer.
If 'if-multiple, we only ask for confirmation if multiple buffers
matches substring.  Otherwise, always ask for confirmation.")



(defvar sje-switch-buffer-create-substring nil
"*Non nil value means that if we want to create new buffers, we will
still search first for buffers matching the substring before creating
a new buffer.")


(defvar sje-switch-buffer-prompt-newbuffer t
  "*Non nil value means if no matching buffer found, prompt for a new one")



(defvar sje-iswitch-allow-ret nil
  "*Non nil value means we can use return key to select first element in list
of matching buffers in iswitch")

;;; internal debug variable - set to t for debug in *op* buffer
(setq sje-debug nil)

;;; Defuns
(defun sje-switch-buffer ( &optional create split newframe)

  "Find next buffer matching a substring somewhere within the buffer
name. If prefix arg given and no buffer matches substring, create new
buffer.  If split is set, current window is split in two. If newframe
is set, a new frame is created to display the buffer in.  (Only one of
split or newframe can be specified.)  "

  (interactive "p")
  (let
      ( ;(buffernames (mapcar (function buffer-name) (buffer-list)))
       ;(buffernames (cdr (buffer-list)))
       (buffernames (buffer-list))
       (nextbuffer nil)
       (buffer nil)
       (prompt nil)
       (defaultbuff (buffer-name (other-buffer (current-buffer))))
       (found nil)
       (switchcmd nil)
       (possible-buffer '() )

       orig-buffer-name
       )

    ;;; See if we want to toggle the value of the variables.

    (if (= create 2)
	;; then
	(setq sje-switch-buffer-regexp (not sje-switch-buffer-regexp)) )

    (if (= create 3)
	;; then
	(setq sje-switch-buffer-confirm
	      (next-in-list sje-switch-buffer-confirm '(nil if-multiple t) )) )


    ;;; Decide on how we want to view the new buffer
    (if split
	(setq switchcmd 'pop-to-buffer)
      ;; else
      (if newframe
	  (setq switchcmd 'sje-pop-to-buffer-newframe)
	;; else
	;; normal switch
	(setq switchcmd 'switch-to-buffer)))
    (setq prompt (sje-switch-buffer-prompt))

    (setq buffer
	  (read-buffer
	   (format prompt)
	   defaultbuff))

    (setq orig-buffer-name buffer)

    ;; see if the buffer is a real buffer first.
    (if (get-buffer buffer)
	;; then buffer is a real buffer so lets switch to it.
	(eval (list switchcmd buffer))
      ;; else
      ;; buffer didnt exist, so lets do a substring search.
      (progn

	(if (and (not sje-switch-buffer-create-substring)
		 (= create 4))
	    ;; lets just create the new buffer.
	    (eval (list switchcmd buffer))
	  ;; else
	  (progn
	    ;; Exact or regexp search?
	    (if (not sje-switch-buffer-regexp)
		(setq buffer (regexp-quote buffer)))

	    (setq found nil)
	    (while ( and (not found) buffernames )

	      ;; iterate down the list of buffernames.
	      (setq nextbuffer (buffer-name (car buffernames)) )
	      (setq buffernames (cdr buffernames))
	      ;; look for a match.
	      (if sje-debug
		  (print (format "looking at %s" nextbuffer)
			 (get-buffer-create "op")))
	      (if (and (not (sje-ignore-buffername-p nextbuffer))
			    (string-match buffer nextbuffer))
		  ;; we have found a possible match
		  (progn
		    (if sje-debug
			(print "found a poss match" (get-buffer-create "op")))
		    (cond  ( (eq sje-switch-buffer-confirm 'if-multiple)
			     (setq possible-buffer
				   (cons nextbuffer possible-buffer)))
			   (sje-switch-buffer-confirm
			    ;; then need a confirm
			    (if (y-or-n-p (format "switch to %s? " nextbuffer))
				(setq found nextbuffer)) )
			   (t
			    ;; else no need for confirmation
			    (setq found nextbuffer))
			   ); end cond
		    )
		    ) ;end if string-match
		) ; end while

	    ;; end of searching - lets see if we found a buffer.

	    ;; first of all, check to see if we used if-multiple
	    (if (eq sje-switch-buffer-confirm 'if-multiple)
		(if (eq 1 (length possible-buffer))
		    ;; only 1 choice to make from
		    ;; so we just pick that one.
		    (setq found (car possible-buffer))
		  ;; else we shall iterate down the list
		  ;; and ask the user...
		  ;; reverse destructively - guess it is faster?
		  (setq possible-buffer (nreverse possible-buffer))
		  (while (and (not found) possible-buffer)
		    (setq nextbuffer (car possible-buffer))
		    (if (y-or-n-p (format "switch to %s? " nextbuffer))
			(setq found nextbuffer)
		      ;; else go onto next.
		      (setq possible-buffer (cdr possible-buffer))
		      )
		    ) ; next while
		  )
	      ) ; end 'if-multiple

	    ;; Now do the switch to the relevant buffer.  If a buffer
	    ;; was found, the varaible found stores the name of the
	    ;; buffer to switch to.
	    (if found
		(eval (list switchcmd found))
		;; else
		(if (and sje-switch-buffer-create-substring
			 (= create 4))
		    ;; lets just create the new buffer.
		    (eval (list switchcmd buffer))
		  ;; else
		  (if (and sje-switch-buffer-prompt-newbuffer
			   (y-or-n-p
			    (format
			     "no buffer matching '%s', create one? "
			     orig-buffer-name)))
		      ;; then
		      (switch-to-buffer
		       (get-buffer-create
			orig-buffer-name))
		    ;; else
		    (message (format "no buffer matching '%s'" 
				     orig-buffer-name))
		    )
		  )
		)
	    ) ;end progn exact or regexp search
	  ) ))
    ) ; end let
)

; adapted from files.el
(defun sje-switch-to-buffer-other-window (create)
  "Select buffer BUFFER in another window."
  (interactive "p")
  (sje-switch-buffer create 'split nil))



; adapted from files.el
(defun sje-switch-to-buffer-other-frame (create)
  "Select buffer BUFFER in another frame."
  (interactive "p")
  (let ((pop-up-frames t))
    (sje-switch-buffer create nil 'newframe)
    ))


;; this is copied from switch-to-buffer-other-frame from files.el
;; and is an aux. function.
(defun sje-pop-to-buffer-newframe (buffer)
  "Open up buffer in new frame"
  (let ((pop-up-frames t))
    (pop-to-buffer buffer t)
    (raise-frame (window-frame (selected-window)))))


;;; decide which kind of prompt you would like.
(defun sje-switch-buffer-prompt2 ()
  (format "switch buffer %s %s "
	  (if sje-switch-buffer-regexp "regexp" "exact")
	  (if sje-switch-buffer-confirm "confirm" "no confirm")))

(defun sje-switch-buffer-prompt ()
  (format "switch buffer %s %s "
	  (if sje-switch-buffer-regexp "r" "e")
	  (cond ( (eq sje-switch-buffer-confirm 'if-multiple) "i")
		(  sje-switch-buffer-confirm "c")
		(  t "n"))
	  ))


(defun sje-switch-buffer-default-keybindings (&optional version)
  (interactive "P")
  "Override the definitions of C-x b, C-x 4 b and C-x 5 b for buffer switching.
non nil value of VERSION means use iswitch rather than normal switch"
  (if version
      ;;; iswitch version
      (progn
	;;(message (format "in iswitch %d" version))
	(global-set-key "b" (quote sje-iswitch))
	(global-set-key "4b" (quote sje-iswitch-to-buffer-other-window))
	(global-set-key "5b" (quote sje-iswitch-to-buffer-other-frame)) )
    ;;; else switch version
    (progn
      (global-set-key "b" (quote sje-switch-buffer))
      (global-set-key "4b" (quote sje-switch-to-buffer-other-window))
      (global-set-key "5b" (quote sje-switch-to-buffer-other-frame)) )
    )
)



;;; Aux functions.
;; taken from listbuf-ignore-buffername-p in listbuf.el
;; by friedman@prep.ai.mit.edu
(defun sje-ignore-buffername-p (bufname)
  "returns T if the buffer should be ignored."
  (let ((data (match-data))
        (re-list sje-switch-buffer-ignore)
        (ignorep nil)
	(nextstr nil)
	)
    (while re-list
      (setq nextstr (car re-list))
      (cond
       ((stringp nextstr)
	(if (string-match nextstr bufname)
	    (progn
	      (setq ignorep t)
	      (setq re-list nil))))
       ((fboundp nextstr)
	(if (funcall nextstr bufname)
	    (progn
	      (setq ignorep t)
	      (setq re-list nil))
	  ))
       )
      (setq re-list (cdr re-list)))
    (store-match-data data)

    ;; return the result
    ignorep)
  )


(defun next-in-list (elem list)
  "Return the next element after ELEM in LIST.  If ELEM is last in LIST,
return the first element of LIST. If ELEM is not in LIST, return nil"

  (let ( (next nil) (notfound t) returnval (first (car list)) )
    (setq list (append list (list first)))
    ;(message "new list %s" list)))

    (while (and notfound list)
      (setq next (car list))
      (setq list (cdr list))
      (if (eq next elem)
	  (progn
	    (setq notfound nil)
	    (setq returnval (car list)))
	)
      ) ; while
    (if notfound (setq returnval nil))

    returnval
))



;;; ----------------------------------------------------------------------
;;;
(defun sje-get-matched-buffers  (regexp &optional string-format)
  "Return matched buffers. If STRING-FORMAT is non-nil, consider
REGEXP as string."
  (let* (
	  name
	  ret
	 )
    (mapcar
     '(lambda (x)
	(setq name (buffer-name x))
	(cond
	 ((and (or (and string-format (string-match regexp name))
		   (and (null string-format)
			(string-match (regexp-quote regexp) name)))
	       (not (sje-ignore-buffername-p name)))
	  (setq ret (cons name ret))
	  )))
     (reverse (buffer-list)))
    ret
    ))


;;; ----------------------------------------------------------------------
;;;


(defun sje-iswitch ( &optional split newframe )
  "Switch to buffers -- icomplete styled."
  (interactive)
  (let (;; make local copies, since we may change them dynamically
 	(buffer-ignore-orig             sje-switch-buffer-ignore)
	(sje-switch-buffer-regexp	sje-switch-buffer-regexp)
 	(sje-switch-buffer-ignore       sje-switch-buffer-ignore)
	(rescan				t)
	(defaultbuf			(other-buffer))
	(case-fold-search		sje-iswitch-case-fold-search)
	re
	buf
	bufs
	name
	char
	len
	prompt
	switchcmd
	)

    
    (if split
	(setq switchcmd 'pop-to-buffer)
      ;; else
      (if newframe
	  (setq switchcmd 'sje-pop-to-buffer-newframe)
	;; else
	;; normal switch
	(setq switchcmd 'switch-to-buffer)))

    (save-window-excursion
      (while (not (memq char '(?\C-m)))	;RETURN KEY

	;;  The default is to match "a" buffer, either regexp or
	;;  not, it still returns quite a few buffers for initial
	;;  prompt :-)
	;;
	;;  Let the initial prompt be empty, only when user types
	;;  something we get activated
	;;
	(if (and rescan
		 (not (null prompt)))
	    (setq bufs (sje-get-matched-buffers
			(or prompt "a")
			sje-switch-buffer-regexp)))

	(setq rescan t)			;set to default again

	;; ............................................ set up prompt ...
	;;
	(if (null prompt)
	    ;; first time round print the default
	    (message "Switch to buffer: %s" defaultbuf)
	  ;; else
	  (message "Switch to buffer: %s  %s"
		   (or prompt "")
		   (cond
		    ((and prompt (null bufs))
		     "{<no match>}")
		    (t
		     (format "{%s}" (mapconcat 'concat bufs ","))
		     )))
	  )
	;; ......................................... read char safely ...
	;;
	(setq
	 char
	 (condition-case nil
	     (progn
	       (discard-input)		;this is a must
	       (read-char))
	   (error
	   ;; return char code 0, eg. mouse-event kicks us out here...
	    0)))

	;; .............................................. handle char ...
	;;

	(if (stringp prompt)		;len needed later
	    (setq len (length prompt))
	  (setq len nil))

	(cond
	 ((and len (eq char ?\177)) ;; DEL: remove the last character)
	  (if (eq len 1)
	      (setq prompt nil)
	    (setq prompt (substring prompt 0 (1- len)))
	    ))

	 ((memq char '(?\ ?\C-s))
	  ;;  SPC: Move the first-matched buffer name to the end
	  (setq tmp  (car bufs))
	  (setq bufs (cdr bufs))
	  (setq bufs (append bufs (list tmp)))

	  (setq rescan nil)		;prevent scanning
	  )

	 ((memq char '(?\C-d))
	  ;;  C-d goes back through list
	  ;;  convert (a b c d) to (d a b c)
	  ;;  there is probably a quicker way to do this!
	  (setq tmp (last bufs))
	  (setq bufs (reverse (cdr (reverse (append tmp bufs)))))
	  (setq rescan nil)		;prevent scanning
	  )

	 ((eq char ?\C-g )		;Quit
	  (keyboard-quit)
	  )

	 ((eq char ?\C-r )		;Regexp toggle
	  (setq sje-switch-buffer-regexp (not sje-switch-buffer-regexp))
	  )

	 ((eq char ?\C-a )		;"all" toggle
	  (if sje-switch-buffer-ignore
	      (setq sje-switch-buffer-ignore nil)
	    (setq sje-switch-buffer-ignore buffer-ignore-orig))
	  )



	 ((eq char ?\C-c )		;Case toggle
 	  (setq case-fold-search (not case-fold-search))
	  )


	 ((and (> char 31)		;add the character
	       (< char 127))
	  (setq prompt
		(concat (or prompt "")
			(char-to-string char)))
	  )

	 ;; ................................................ selections ...
	 ;;
	 ((eq char ?\t )		; TAB, take first in list
	  (if (> (length bufs) 0)	; myst be only one selection
	      (setq buf (car bufs)))	; take that
	  (setq char ?\C-m)		; signal selection
	  ;; If there is no list, do nothing
	  )

	 ((eq char ?\C-m )		; RET, a selection
	  ;; else
	  (if (or (eq 1 (length bufs))	; myst be only one selection
		  (and sje-iswitch-allow-ret
		       (> (length bufs) 0)))
	      (setq buf (car bufs))	; take that
	    (setq buf prompt))		; otherwise keep prompt
	  )

	 ((eq char ?\C-q )		; RET, a selection
	  (if prompt			; accept prompt literally.
	      (setq buf prompt))	; but only if it exists.
	  (setq char ?\C-m)		; signal selection
	  ))


	))				;while, window...

    ;; ............................................... handling result ...
    ;;
    ;; buffer to switch to is in buf
    ;;(message "buffer is %s" buf)
    (if (null prompt)
	(setq buf defaultbuf))
    (cond
     ((and buf
	   (get-buffer buf))			;does it exist ?
      (eval (list switchcmd buf))
      (message ""))

     (t
      (if (and sje-switch-buffer-prompt-newbuffer
	       (y-or-n-p
		(format
		 "No buffer matching '%s', create one? "
		 prompt)))
	  ;; then
	  (eval (list switchcmd (get-buffer-create buf)))
	(message (format "no buffer matching '%s'" prompt))
	)))

    ;; Let - func end
    ))





; adapted from files.el
(defun sje-iswitch-to-buffer-other-window ()
  "Select buffer BUFFER in another window."
  (interactive)
  (sje-iswitch 'split nil))



; adapted from files.el
(defun sje-iswitch-to-buffer-other-frame ()
  "Select buffer BUFFER in another frame."
  (interactive)
  (let ((pop-up-frames t))
    (sje-iswitch nil 'newframe)
    ))

(provide 'sje-switch-buffer)

