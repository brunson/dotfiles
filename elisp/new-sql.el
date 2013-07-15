;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sql-mode.el - modes for editing SQL code and interacting with SQL servers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Authors:       1994, 1995 Peter D. Pezaris <pez@atlantic2.sbi.com>
;;                 1992 Jim Nelson
;;  Maintainer:    sql-mode-help@atlantic2.sbi.com
;;  Created:       November 1992 by Jim Nelson
;;  Version:       0.919.1 (beta)
;;  Last Modified: Wed Jul  5 10:08:10 1995
;;  Keywords:      isql fsql sql editing major-mode languages
;;
;;  Copyright © 1994, 1995 Peter D. Pezaris
;;
;;  This file is not part of GNU Emacs
;;
;;  This program is free software; you can redistribute it and/or
;;  modify it under the terms of the GNU General Public License as
;;  published by the Free Software Foundation; either version 1, or (at
;;  your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful, but
;;  WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  General Public License for more details.
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program; if not, write to the Free Software
;;  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Description:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  sql-mode.el offers four major modes relating to SQL code:
;;
;;  sql-mode              major mode for editing SQL code
;;  sql-batch-mode        major mode for entering and execution of SQL
;;                        commands in batches
;;  sql-interactive-mode  major mode for interaction with SQL servers
;;  sql-results-mode      major mode for viewing results returned by the
;;                        execution of commands in sql-batch-mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Features:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  New features to this release are marked with a '+'
;;
;;  o Batch editing of sql commands
;;  o Interactive editing of sql commands
;;  o Warnings for missing `where' clauses
;;  o Warnings for number of rows affected with updates, deletes, etc.
;;  o Command history in batch and interactive modes
;;  o Abbrev definitions for sql commands
;;  o Specialized syntax table for sql code
;;  o Extensive comment and un-comment functionality
;;  o Server/user/password/database associations using mnemonics or menus
;;  o Menubar support
;;  o Popup menu support
;;  o Drag scrolling of results buffers
;;  o Full font-lock support
;;  o Automatic indentation of sql code (still very alpha)
;;  + Printing of results buffers with support for enscript
;;  o Minibuffer completion on servers and users
;;  o Keyword completion
;;  o Table name completion
;;  o Column name completion
;;  o Stored procedure name completion
;;  o Database name completion
;;  o Options menu, including save current options
;;  o Changes are marked (highlighted) in results buffers
;;  o Linked batch and results buffers
;;  o Improved table header management
;;  o Global command history
;;  o Top ten list of commonly used queries
;;  o Automagically builds server list from interfaces file
;;  o Error parsing of results buffers
;;  o SQL Mode specific help system
;;  o SQL Mode specific toolbar
;;  o Loading of stored procedures
;;  o Big menubar for novice users
;;  o bcp in and out
;;  o Canned inserts into a table
;;  + Perform updates simply by typing in the results buffer
;;  + Background evaluation so that you can continue to use emacs
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Installation:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SQL Mode was written for XEmacs (formerly Lucid Emacs) version 19.8 or
;;  later.  Version 19.10 or later is recommended.  For toolbars to really
;;  work well, you need version 19.12 or later.
;;
;;  In addition, sql-mode now works with FSF Emacs version 19 in a slightly
;;  limited way.  The package easymenu is required if you are using FSF
;;  Emacs.  SQL Mode has been tested for FSF Emacs version 19.28.  It may
;;  work with some earlier versions, but has not been tested.
;;
;;  There are two methods to loading sql-mode.el which differ only in
;;  performance.  The first method is perhaps easier to set up, but will
;;  take slightly longer to load.  The second method is therefore
;;  recommended.
;;
;;  Method 1:
;;
;;  Add the following lines to your .emacs file:
;;
;;      (load-file "<path to sql-mode>/sql-mode.el")
;;      (sql-initialize)
;;
;;  Method 2:
;;
;;  Byte compile sql-mode.el and all the other files that came in the
;;  distribution (using M-x byte-compile-file) and put them in your
;;  load-path.  Load the package from your .emacs file with:
;;
;;      (require 'sql-mode)
;;      (sql-initialize)
;;
;;  You may need to alter your load-path to do this.  If so, add lines to
;;  your .emacs similar to the following:
;;
;;      (setq load-path (cons (expand-file-name "~/lisp/") load-path))
;;
;;  To make full use of the help system, you will need to copy the file
;;  SQL-MODE-README into the directory specified by the variable
;;  `data-directory'.  The file should have come with the sql-mode
;;  distribution.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic Usage:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  INVOCATION
;;
;;  To automatically enter sql-mode when editing a file with a ".sql", a
;;  ".tbl" or a ".sp" extension, add the following to your .emacs file.
;;
;;      (autoload 'sql-mode "sql-mode" "SQL Editing Mode" t)
;;      (setq auto-mode-alist
;;         (append '(("\\.sql$" . sql-mode)
;;                   ("\\.tbl$" . sql-mode)
;;                   ("\\.sp$"  . sql-mode))
;;                 auto-mode-alist))
;;
;;  sql-batch-mode and sql-interactive-mode are invoked with
;;  M-x sql-batch-mode and M-x sql-interactive-mode respectively.  You will
;;  be prompted for the SQL server, the login id of the user, and the
;;  password.  Passwords are echoed with `*' characters as you are typing
;;  them by default.  If you would rather see the password as you are
;;  typing it, see the variable `sql-secure-passwords'.
;;
;;  EVALUATION
;;
;;  In an sql-batch-mode buffer, you can evaluate the buffer by invoking
;;  sql-evaluate-buffer (bound to C-c C-e by default, and also M-i for
;;  backwards compatibility).  A region can be evaluated by passing an
;;  argument to sql-evaluate-buffer.
;;
;;  In an sql-interactive-mode buffer, you can evaluate the command you just
;;  entered by typing `go' followed by RETURN (if you are using isql) or
;;  type a semicolon at the end of the line followed by RETURN (if you are
;;  using fsql).
;;
;;  One very important user-definable variable is `sql-command'.  This
;;  variable should be set to "isql", or "fsql" etc., as appropriate.  See
;;  the section on customization for details on how to set sql-command.
;;  Also make sure that the sql-command is in your path.
;;
;;  Switches can be passed to sql-command by setting the variable
;;  sql-batch-command-switches.  Do not, for instance, set sql-command to
;;  "isql -i file".  Instead, set sql-command to "isql" and 
;;  sql-batch-command-switches to "-i file".
;;
;;  COMMENTING
;;
;;  Lines of code can be commented out and un-commented out using various
;;  sql-comment- functions.  The most basic (and most useful) is
;;  sql-comment-line-toggle.  This function will comment out a line of
;;  code if it is not already commented, or un-comment it if it is
;;  commented.  This function is bound to C-c C-c in sql-mode and
;;  sql-batch-mode buffers by default.
;;
;;  COMMAND HISTORY
;;
;;  You can scan through your previous commands with sql-previous-history
;;  and sql-next-history (bound to M-p and M-n in sql-batch-mode buffers
;;  by default).  As you evaluate new commands, they are added to the
;;  history list.  The most recent 40 command are kept by default.
;;
;;  DRAG SCROLLING
;;
;;  sql-mode supports drag-scrolling.  By default this is bound to
;;  shift-button1 in sql-interactive-mode and sql-results-mode buffers.  To
;;  scroll the results, simply click and hold the left mouse button while
;;  holding the shift key, and drag the mouse.  The text should scroll
;;  appropriately.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  To change the value of a user-definable variable, don't change the file
;;  sql-mode.el.  Instead, put a line in either your .emacs file, or the
;;  file $HOME/.sql-mode, as follows:
;;
;;      (setq VARIABLE VALUE)
;;
;;  The usage of the file $HOME/.sql-mode removes some of the clutter from
;;  your .emacs file, speeds up the loading of Emacs, and is therefore
;;  recommended.  The file $HOME/.sql-mode will be loaded once, when
;;  sql-mode, sql-batch-mode, or sql-interactive-mode is first invoked.
;;  Subsequent loadings can be done manually with M-x load-file.
;;
;;  Similarly to changing variable values, if you want to change key
;;  bindings, don't alter the file sql-mode.el, but instead use the
;;  function define-key.  For instance, to bind the key sequence C-c C-a
;;  to the function sql-association-mode, add the following line to your 
;;  $HOME/.emacs file *after* you load sql-mode.el, or add it to your
;;  $HOME/.sql-mode file:
;;
;;      (define-key sql-mode-map "\C-c\C-a" 'sql-association-mode)
;;
;;  This should be used merely as an example, since sql-association-mode
;;  is already bound to C-c C-a by default.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Advanced Usage:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ASSOCIATION
;;
;;  One of the most convienient features is the ability to specify
;;  server/login-id/password/database associations, and log into a specific
;;  server as a specific user (and optionally use a specific database)
;;  with a single key-stroke, without having to specify a password.  To do
;;  this, you need to specify an sql-asociation-alist.  Here is an example
;;  that features two labels, three separators, and four entries.  The
;;  separators and labels are for decorating the popup-menus.
;;
;;  For each association, there are two required fields, and two optional
;;  ones.  The server and login-id are required, but password and database
;;  are optional.  If no password is supplied, you will be prompted for one
;;  when you invoke the association.  If no database is supplied, the
;;  default (master) database is simply used.
;;
;;      (setq sql-association-alist
;;  <1>       '(("-" ("LABEL1" "" ""))
;;  <2>         ("-" ("----" "" ""))
;;  <3>         ("MNEMONIC1" ("SERVER1" "LOGIN-ID1" "PASSWORD1" "DATABASE1"))
;;  <4>         ("MNEMONIC2" ("SERVER2" "LOGIN-ID2" "PASSWORD2"))
;;  <5>         ("-" ("----" "" ""))
;;  <6>         ("-" ("LABEL2" "" ""))
;;  <7>         ("-" ("----" "" ""))
;;  <8>         ("MNEMONIC3" ("SERVER3" "LOGIN-ID3" nil "DATABASE3"))
;;  <9>         ("MNEMONIC4" ("SERVER4" "LOGIN-ID4" "PASSWORD4"))))
;;
;;  <1> a label
;;  <2> a separator
;;  <3> this association has all four components of an association
;;  <4> this association doesn't specify a database
;;  <5> another separator
;;  <6> another label
;;  <7> yet another separator
;;  <8> this association specifies a database, but no password
;;  <9> this association is the same format as <4> -- the most common
;;
;;  MNEMONIC should be a string of one or more characters that you will use 
;;  to reference your association.  You should have a unique mnemonic for
;;  each association, otherwise you will be unable to reference the
;;  duplicates.
;;
;;  This should be put in your $HOME/.sql-mode file.
;;
;;  WARNING: you may have un-encrypted passwords in this file.  This may
;;           pose a security risk.  At the very least, you should change
;;           the permissions on this file so that only you can read it.
;;           If this is unacceptable, you should omit the password entries.
;;           Omitting the passwords will, however, require you to type
;;           them in on each invocation of either sql-batch-mode or
;;           sql-interactive-mode.
;;
;;  To utilize your association list, invoke sql-association-mode.  You
;;  will be prompted for your association mnemonic, and you will get a
;;  new sql-batch-mode buffer with the appropriate server, user, password,
;;  and database set.  If you are already in an sql-mode buffer, you can
;;  select the menu item "Use Association..." to switch to a new
;;  server/login-id/password/database association.
;;
;;  In addition, you can select an association by invoking
;;  sql-popup-association-menu (bound to button3 in sql-batch-mode buffers
;;  by default).
;;
;;  If the value of the variable `sql-add-to-menu-bar' is non-nil,
;;  associations will be accessible through the `Utilities' menu, or under
;;  the menu specified by `sql-parent-menu'.  This is perhaps the best way
;;  to utilize your associations, since they can be launched from any
;;  buffer.
;;
;;  RESULTS BUFFERS
;;
;;  Results buffers can be configured to be disposable -- each new result
;;  will overwrite the previous (the default).  They can also be saved, so
;;  that every results buffer is given a unique buffer name.  If you have
;;  disposable results buffers (sql-save-all-results set to nil), and wish
;;  to save a particular buffer, invoke sql-pop-and-rename-buffer.
;;
;;  It is recommended that you keep results buffers in their default
;;  state (disposable), since the results are saved in the history of the
;;  buffer.
;;
;;  Results buffers can also be configured to appear in a separate screen.
;;  Set sql-results-in-new-screen to t for this to occur.  When the results
;;  appear in a new screen in this fashion, they are uniquely renamed by
;;  default (i.e. the value of sql-save-all-results is ignored, and assumed
;;  to be t).
;;
;;  When results buffers appear in new windows, you can set the size infor-
;;  mation by setting sql-resize-results-screens to t, and
;;  sql-results-screen-width and sql-results-screen-height to appropriate
;;  values.
;;
;;  ABBREVS
;;
;;  You can use abbrevs in sql-mode, sql-batch-mode and
;;  sql-interactive-mode by changing the value of  sql-abbrev-mode to a
;;  non-nil value (it is nil by default).  There are a default set of
;;  abbrevs, but you can customize them by the existance of a file:
;;
;;      $HOME/.sql-abbrevs
;;
;;  This file should be created by M-x write-abbrev-file, or something
;;  similar.  See the help on abbrev-mode, write-abbrev-file, and
;;  define-abbrev-table for details.
;;
;;  There is a default set of abbrevs that map common keywords to one and
;;  two-letter keystrokes.
;;
;;  FONT LOCKING
;;
;;  Font-lock-mode can be turned on by setting the variable
;;  sql-font-lock-buffers to a non-nil value.  You can select which types
;;  of buffers you wish to font lock.  If you want them all to be
;;  font-locked set this variable to 'all.  If you would only like a
;;  subset of the four modes to be font-locked, set this variable to a
;;  list of the mode types you wish to font-lock.  For example, to
;;  font-lock only sql-mode and sql-interactive-mode buffers, add this
;;  to your $HOME/.sql-mode file.
;;
;;      (setq sql-font-lock-buffers '('sql-mode 'sql-interactive-mode))
;;
;;  See the variable sql-mode-font-lock-keywords for details on what will
;;  get font-locked.  By default, it is assumed that you are using a light
;;  background.  If you are using a dark background, set the variable
;;  sql-video-type to 'inverse.  If you are using a monochrome monitor,
;;  set sql-vidoe-type to 'monochrome (see the section Customization).
;;
;;  To change the faces that are used in font-lock-mode, you will need to
;;  set the values of the face variables in your $HOME/.sql-mode file.  An
;;  example, if you want conjunctions to appear blue, include thiese lines:
;;
;;      (make-face 'sql-conjunction-face)
;;      (set-face-foreground sql-conjunction-face "blue")
;;
;;  The face names are: sql-query-face, sql-set-face, sql-special-face,
;;                      sql-conjunction-face, sql-sysadm-face,
;;                      sql-aggregate-face, sql-prompt-face,
;;                      and sql-results-face.
;;
;;  To change the regexp that searches for words to font-lock, you will have
;;  to set the value of the variable sql-mode-font-lock-keywords.  See the
;;  help on the variable font-lock-keywords for more details.
;;
;;  GLOBAL COMMAND HISTORY
;;
;;  If you want to execute a command in one sql-batch-mode buffer that has
;;  already been entered in another buffer, you can access it by browsing
;;  the global command history.  The last 40 commands evaluated in *any*
;;  sql-batch-mode buffer are saved in the global command history.  To
;;  insert the previous global command in the current buffer, simply invoke
;;  sql-previous-global-history (bound to M-P by default).  Similarly, the
;;  next global history element is accessed via sql-next-global-history
;;  (bound to M-N by default).
;;
;;  This can be a useful way to execute similar commands in different
;;  batch mode buffers.
;;
;;  TOP TEN LIST
;;
;;  If you are commonly executing a small set of SQL commands, you can save
;;  them in a top ten list, and later reference them easily.  The commands
;;  are saved in the file $HOME/.sql-top-ten.  To save a common command to
;;  your list, invoke sql-add-top-ten (bound to C-c t by default), which
;;  will save the contents of the current sql-batch-mode buffer into one
;;  of the ten positions available.  To later access a top ten command,
;;  invoke sql-insert-top-ten<n>, where n is a number between 0 and 9.
;;  These functions are bound by default to C-c 0 through C-c 9.
;;
;;  Your top ten list is saved automatically every time you make an
;;  addition to it.
;;
;;  SQL ERRORS
;;
;;  The commands sql-next-error and sql-previous-error (bound to C-c n and
;;  C-c p in sql-batch-buffers by defaults) make it easy to go to the line
;;  of SQL code on which the error occured.  These functions work similarly
;;  to next-error and previous-error.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mailing Lists:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  If you would like to join the beta testers list, or the sql-mode
;;  discussion mailing list, send add/drop requests to
;;  sql-mode-request@atlantic2.sbi.com.  Discussions can be sent to
;;  sql-mode-discuss@atlantic2.sbi.com.  Bug reports and enhancement
;;  requests should still be sent to sql-mode-help@atlantic2.sbi.com only
;;  (see below).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bug Reports:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  You can submit a bug report by typing M-x submit-bug-report or
;;  selecting `Submit Bug Report' from the menu bar.  Try to be as specific
;;  as possible in the description of your problem.
;;
;;  Similarly, enhancement requests can be submitted by typing
;;  M-x submit-enhancement-request or selecting `Submit Enhancement Request'
;;  from the menu bar.
;;
;;  A mail buffer will be set up with some information that will make it
;;  easier to diagnose the problem.  In addition, to To: field will be
;;  filled out for you.  Please don't send bug reports and enhancement
;;  requests to my personal account, as I try to keep them separate from my
;;  `real' work.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Known Bugs:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  o Indentation.  It is in a horrible state.
;;  o Multiple transactions not rolled back properly (this is *huge*).
;;  o sql-save-history doesn't save the results history.  This quickly leads
;;    to unlinked histories.
;;  o False `where clause' warning messages (perhaps fixed when the
;;    variable `sql-risky-searches' is set to t)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Future Enhancements:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Things I'd like to see in sql-mode: (in approximate order of importance)
;;
;;  If you would like to volunteer to help implement any of these items,
;;  please send mail to sql-mode-help@atlantic2.sbi.com.
;;
;;  * Accurate indentation of SQL code
;;      - syntax parser (good for more than just indentation)
;;      - indentation engine (based on cc-mode.el?)
;;  * Support for Sql*Plus, and any other sql really
;;  * Accurate `where' warnings (right now there are some false positives)
;;      - this may be fixed by setting sql-risky-searches to `t'
;;  o Have database sends go through temporary `send' buffer
;;  o sql-rollback-policy
;;  o Better buffer management
;;      - batch and results buffers both created at start
;;  o A filter to process output data to remove ^As and other garbage
;;  o Exit on termination of an interactive process
;;  o Enhanced printing of results buffers (split pages) to printer
;;      - portrait and landscape modes
;;  * A more accurate sql-get-completion-context
;;  o Split modes into sql-batch-mode, and sql-run-batch etc.
;;  o sql-previous-history-unlinked
;;  o toolbars should use transparent backgrounds
;;  o interactive function should only hit the database if completion is
;;    requested (by hitting TAB or SPACE)
;;  * An Info page
;;  * Split the file sql-mode.el into more manageable chunks
;;
;;  `*' means that the item is in progress, `o' means that it isn't (yet)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Revision History:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  22-MAY-95 (pez) - added association completion
;;
;;  14-MAY-95 (pez) - enhanced sql-*yank-under-point functions to work from
;;                    any buffer, including the minibuffer
;;
;;  12-MAY-95 (pez) - printing enhancements: sql-print-command,
;;                    sql-print-switches, enscript auto detection
;;                  - changed sql-results-hook to sql-results-mode-hook
;;                  - added hook variable devfars
;;                  - added database completion
;;
;;  10-MAY-95 (pez) - added sql-finished-query-options
;;                  - fixed sql-stay-in-batch-buffer bug
;;                  - finally made completion work in interactive mode
;;                    buffers
;;
;;  08-MAY-95 (pez) - fixed cleanup of results buffers so that the
;;                    marking-changes functionality isn't in effect
;;
;;  05-MAY-95 (pez) - added sql-stay-in-batch-buffer variable
;;                  - wrote sql-evaluate-buffer-asyncronous and related
;;                    functions
;;                  - modified the behavior of sql-no-warn so that it
;;                    appends to the user's ~/.sql-mode file rather than
;;                    creating a new file
;;                  - changed the default binding of C-L from sql-recenter
;;                    to sql-reposition-windows (C-l is still sql-recenter)
;;
;;  01-MAY-95 (pez) - made sql-*-history functions work from results buffers
;;                  - added canned updates (sql-edit-row and sql-update-row)
;;
;;  26-APR-95 (pez) - fixed sql-insert-row to pay attention to column types
;;                  - added type-to-update functionality
;;                  - enhanced sql-get-columns to get the column type
;;
;;  14-APR-95 (pez) - added sql-bcp-out and sql-bcp-in functions
;;                  - updated big menubar to include much more stuff
;;                  - added sql-magic-yank-under-point
;;
;;  02-APR-95 (pez) - added sql-yank-under-point
;;                  - changed sql-set-database so that it clears cached
;;                    data
;;
;;  31-MAR-95 (pez) - changed sql-evaluate-buffer so that it doesn't
;;                    destroy and re-create results buffers every time
;;                  - added sql-insert-row
;;
;;  17-MAR-95 (pez) - fixed sql-end-of-buffer and sql-beginning-of-buffer
;;                    to push the mark
;;
;;  07-MAR-95 (pez) - split up toolbar code for XEmacs version 19.11 and
;;                    19.12 since it's so different
;;
;;  27-FEB-95 (pez) - made popup on button3 be context sensitive, displaying
;;                    completion lists where appropriate
;;                  - added sql-load-hook
;;
;;  24-FEB-95 (pez) - enhanced sql-get-completion-context to understand
;;                    commas, as in: update a set b=5, c=3
;;
;;  23-FEB-95 (pez) - added sql-load-sp funciton
;;                  - fixed sql-help-for-help to hande button events
;;                  - fixed font-lock regexps to match words
;;                  - fixed sql-determine-video-type
;;
;;  09-FEB-95 (pez) - made isearch interactively recenter horizontally
;;                    thanks to code written by Barry Warsaw
;;
;;  08-FEB-95 (pez) - added sql-previous-matching-history
;;
;;  06-FEB-95 (pez) - wrote sql-toolbar.el (based on toolbar by Andy Piper)
;;                    and related functions
;;                  - designed sql-icons.el
;;                  - fixed sql-goto-history
;;
;;  30-JAN-95 (pez) - added sql-other-window-done
;;
;;  06-JAN-95 (pez) - added sql-split-window-horizontally and related
;;                    functions
;;
;;  28-DEC-94 (pez) - added FSF emacs support
;;
;;  15-DEC-94 (pez) - fixed history/next-error bug
;;
;;  13-DEC-94 (pez) - made sql-stored-procedure-list buffer-local and added
;;                    it to sql-clear-cached-data (these were bugs)
;;
;;  02-DEC-94 (pez) - added sql-next-error and sql-previous-error
;;                  - fixed header-motion/history incompatibility
;;
;;  30-NOV-94 (pez) - added sql-read-interfaces-file
;;                    added sql-set-sybase
;;
;;  29-NOV-94 (pez) - added sql-insert-gos and sql-insert-semi-colons
;;                  - fixed column name completion bug
;;
;;  28-NOV-94 (pez) - added sql-evaluate-buffer-hook
;;                    added sql-exit-sql-mode functions
;;
;;  25-NOV-94 (pez) - fixed sql-drag-display to work with shifting headers
;;
;;  18-NOV-94 (pez) - added global history
;;                  - changed keybindings in sql-results-mode to be closer
;;                    to view-mode
;;                  - added edit mode in sql-results-mode
;;                  - improved header management (no moving of headers if
;;                    there are multiple headers)
;;                  - added top-ten queries
;;
;;  15-NOV-94 (pez) - added scroll-in-place (with header management)
;;                  - changed sql-intersperse-headers to nil
;;
;;  08-NOV-94 (pez) - enhanced column completion to work after `and' and
;;                    `or' clauses
;;                  - fixed regexps for warnings
;;
;;  02-NOV-94 (pez) - made font-lock changes work `on the fly'
;;                  - added monchrome font-lock settings
;;                  - enhanced associations to use databases as well
;;
;;  31-OCT-94 (pez) - cleaned up header comments
;;
;;  28-OCT-94 (pez) - added column completion (first crack at it)
;;                  - header interspersion
;;                  - made keyword completion and font-lock regexps case-
;;                    insensitive
;;                  - fixed poor completion behavior
;;
;;  29-SEP-94 (pez) - linked batch-mode and results-mode buffers
;;
;;  17-AUG-94 (pez) - cleaned up commented-out code
;;                  - added screen-icon-title-format cusomization
;;
;;  25-JUL-94 (pez) - added sql-interactive-command-switches
;;                  - fixed sql-end-of-row for sql-interactive-mode
;;
;;  21-JUL-94 (pez) - linked history of batch buffers
;;                  - changed mode-line-format
;;                  - made results buffers resizable
;;
;;  20-JUN-94 (pez) - added save current options
;;                  - added change highlighting in results buffers
;;                  - fixed some options bugs
;;
;;  16-JUN-94 (pez) - added options menu
;;
;;  08-JUN-94 (pez) - added saving and loading of history
;;
;;  07-JUN-94 (pez) - fixed heinous font-lock bug
;;                  - added more font-lock customizability
;;                  - made completion more flexible
;;                  - made menus version-dependant
;;
;;  24-MAY-94 (pez) - added keyword completion
;;                  - added database buffer-local variable
;;                  - added sql-current-buffer-info
;;
;;  23-MAY-94 (pez) - added font-locking for results buffers
;;                  - made associations work in interactive buffers
;;                  - added table completion
;;
;;  16-MAY-94 (pez) - made isearch-mode-end-hook buffer local in
;;                    sql-interactive-mode and sql-results-mode buffers
;;
;;  12-MAY-94 (pez) - added minibuffer completion for servers and users
;;
;;  09-MAY-94 (pez) - changed buffer names to be consistent with emacs
;;                    conventions
;;                  - made enhancements to sql-previous-history and
;;                    sql-next-history
;;
;;  08-MAY-94 (pez) - broke sql-mode out into sql-mode, sql-batch-mode,
;;                    and sql-interactive-mode
;;                  - added flashing messages
;;
;;  06-MAY-94 (pez) - added full font-lock support (thanks to J. Price)
;;                  - made font-lock colors customizable
;;                  - history bug fixes
;;
;;  02-APR-94 (pez) - changed function comments as per RMS's request
;;
;;  02-MAR-94 (pez) - added warnings for where clauses and rows affected
;;                  - added command history
;;	            - made sql-results-mode separate from the function
;;		      sql-evaluate-buffer
;;
;;  01-MAR-94 (pez) - added a first attempt at automatic indentation of
;;                    SQL code
;;
;;  25-FEB-94 (pez) - added drag scrolling
;;		    - added the following functions:
;;				sql-set-server
;;				sql-set-user
;;				sql-set-password
;;				sql-set-sql-command
;;
;;  22-FEB-94 (pez) - made sql-command customizable
;;		    - updated font-locking to be more customizable
;;		    - added sql-abbrev-mode
;;		    - changed the file name to sql-mode.el
;;
;;  18-FEB-94 (pez) - added popup association menu
;;
;;  17-FEB-94 (pez) - made password entry invisible (customizable)
;;		    - removed autogenerated passwords (bad algorithm)
;;		    - added associations
;;		    - fixed new-screen logic
;;		    - added resizing of new screens
;;
;;  11-FEB-94 (pez) - added comment customization
;;		    - added the following variables:
;;				sql-comment-regions-by-line
;;				sql-scroll-overlap
;;				sql-max-screen-width
;;    				sql-save-all-results
;;		    - fixed sql-beginning-of-row
;;		    - fixed sql-end-of-row
;;		    - created separate menus for sql-mode buffers and 
;;		      sql-results buffers
;;		    - added support for font-lock-mode
;;		    - added results in new screen
;;		    - added results in new screen toggle function
;;		    - added sql-mode hook and sql-results-hook
;;
;;  07-FEB-94 (pez) - added the following functions:
;;				sql-forward-column		C-F
;;				sql-backward-column		C-B
;;				sql-beginning-of-row		C-a
;;				sql-end-of-row			C-e
;;				sql-pop-and-rename-buffer
;;		    - added region commenting
;;		    - added sql-mode-syntax-table
;;		    - added sql-menu (for lemacs 19.x)
;;		    - added bug-reporting mechanism
;;
;;  01-FEB-94 (pez) - changed the file name to isql-mode.el (from isql.el)
;;                  - added line and buffer commenting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Acknowledgements:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  The code for sql-get-password and related functions was copied whole-
;;  sale from Andy Norman's ange-ftp package.
;;
;;  The code for sql-submit-bug-report was based heavily on Kyle Jones'
;;  vm package.
;;
;;  The code for drag scrolling was written by Martin Boyer, Hydro Quebec,
;;  and modified by Laurent Langlois.
;;
;;  The regexps for font-lock-mode were written by James "Clam" Price,
;;  Salomon Brothers, Inc.
;;
;;  The code for sql-restore-window-configuration was shamelessly lifted
;;  from comint.el.
;;
;;  The sql-isearch-begin and sql-isearch-end functions were inspired by
;;  code written by Barry Warsaw.
;;
;;  There are many other small snippets of code throughout sql-mode.el
;;  that have been pilfered from the many excellent elisp packages written
;;  for XEmacs.
;;
;;  Many thanks to the members of the help-xemacs@cs.uiuc.edu (formerly
;;  help-lucid-emacs@lucid.com) mailing list, the members of the CDTS team
;;  at Salomon Brothers, and James "Clam" Price.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Getting the latest version:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Requests can be sent to sql-mode-help@atlantic2.sbi.com to receive the
;;  latest version of sql-mode.el.  It is actively being enhanced (and
;;  fixed).
;;
;;  If you work for Salomon, Inc. you can use anonymous ftp to get the
;;  latest version.  It is on atlantic2 in the directory /pub/sql-mode.
;;  In addition to sql-mode.el, this directory contains a reference card
;;  (a postscript file) and an X bitmap file that I use when iconifying a
;;  sql-mode screen.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sql-lucid (string-match "Lucid" (emacs-version)))

(defvar sql-xemacs (string-match "XEmacs" (emacs-version)))

(defvar sql-xemacs-19-12 (and sql-xemacs (> emacs-minor-version 11)))

(require 'comint)

(or (featurep 'scroll-in-place)
    (condition-case the-error
	(progn
	  (require 'scroll-in-place)
	  (setq scroll-in-place nil))
      (error (progn
	       (defun scroll-up-in-place (arg)
		 (interactive)
		 (scroll-up arg))
	       (defun scroll-down-in-place (arg)
		 (interactive)
		 (scroll-down arg))
	       (setq sql-global-move-headers nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Definable Variables:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sql-mode-hook nil
  "*Function or functions to run on entry to sql-mode.")

(defvar sql-batch-mode-hook nil
  "*Function or functions to run on entry to sql-batch-mode.")

(defvar sql-interactive-mode-hook nil
  "*Function or functions to run on entry to sql-interactive-mode.")

(defvar sql-results-mode-hook nil
  "*Function or functions to run on entry to sql-results-mode.")

(defvar sql-before-evaluate-buffer-hook nil
  "*Function or functions to run just before the buffer is evaluated.")

(defvar sql-evaluate-buffer-hook nil
  "*Function or functions to run after the buffer is evaluated.")

(defvar sql-load-hook nil
  "*Function or functions to run after sql-mode.el is loaded.")

(defvar sql-database-type 'oracle
  "Type of database you are using.  Recognized options are 'sybase and 'oracle.
Setting this variable will change the default value of a few variables, as well
as the behavior of SQL Mode.  Oracle support should be considered limited
compared to Sybase support.")

(defvar sql-command
  (cond ((eq sql-database-type 'sybase)
	 "isql")
	((eq sql-database-type 'oracle)
	 "sqlplus")
	(t
	 "isql"))
  "*Command to invoke sql.
This should be just the program name, NOT path/command.  The command
should be in your path.  If you need to add switches, see the variables
`sql-batch-command-switches' and `sql-interactive-command-switches'.
The value of this variable will have a default based on the value of
the variable `sql-database-type'.  If you are changing the value of this
variable you should also see the variable `sql-database-type'.")

(defvar sql-batch-command-switches nil
  "*Switches to concatenate to the sql-command in sql-batch-mode.")

(defvar sql-interactive-command-switches nil
  "*Switches to concatenate to the sql-command in sql-interactive-mode.")

(defvar sql-bcp-command "bcp"
  "*Command to invoke bcp.
This should be just the program name, NOT path/command.  The command
should be in your path.  If you need to add switches, see the variables
`sql-bcp-command-switches'.")

(defvar sql-bcp-command-switches nil
  "*Switches to concatenate to bcp when running sql-bcp-out or sql-bcp-in.
If the value of this variable is nil (the default), then the following
switches are used: -c -t| -r'\n'")

(defvar sql-bcp-user nil
  "*User name to use for bcp commands.
If non-nil, all bcp commands will be of the form database.SQL-BCP-USER.table")

(defvar sql-preferred-evaluation-method 'foreground
  "*The preferred way to call sql-evaluate-buffer.
Possible options are currently 'foreground, which will block until the
query returns, and 'background, which will evaluate the query in the
background.")

(defvar sql-require-final-go t
  "*Append `go' to the end of the buffer before evaluation if non-nil.")

(defvar sql-secure-passwords t
  "*Make password entry invisible if non-nil.")

(defvar sql-abbrev-mode nil
  "*Invoke abbrev-<minor>-mode if non-nil.")

(define-abbrev-table 'sql-mode-abbrev-table
  '(("s" "select")
    ("f" "from")
    ("w" "where")
    ("l" "like")
    ("u" "update")
    ("ob" "order by")
    ("tr" "transaction")
    ("st" "statistics")))

(defvar sql-video-type nil
  "*The type of video display you are using.  It should be one of
	'regular	for light backgrounds
	'inverse	for dark backgrounds
	'monochrome	for monochrome monitors

If the value of this variable is nil, it will try to guess the appropriate
value in the function `sql-determine-video-type'.")

(defvar sql-minibuffer-status t
  "*This variable is obsolete.  Please see `sql-finished-query-options'.")

(defvar sql-comment-start-regexp "[/][*][ ]"
  "Regexp to match sql-comment-start-string.")

(defvar sql-comment-start-string "/* "
  "Start string to insert in order to comment-out SQL code.")

(defvar sql-comment-end-regexp "[ ][*][/]"
  "Regexp to match sql-comment-end-string.")

(defvar sql-comment-end-string " */"
  "End string to insert in order to comment-out SQL code.")

(defvar sql-resize-results-screens t
  "*Resize screens according to sql-results-screen-width and
sql-results-screen-height if non-nil.")

(defvar sql-results-screen-width 100
  "*Width of new screens generated by sql-mode if
sql-resize-results-screens is non-nil.")

(defvar sql-results-screen-height 25
  "*Height of new screens generated by sql-mode if 
sql-resize-results-screens is non-nil.")

(defvar sql-max-screen-width 5000
  "*Maximum screen width for sql-results buffers.")

(defvar sql-scroll-overlap 2
  "*Number of columns to overlap when scrolling to the end of the row.")

(defvar sql-save-all-results nil
  "*Replace results bufffers as they are generated if nil, save all
results buffers otherwise.")

(defvar sql-results-in-new-screen nil
  "*When non-nil, place results in a new screen, otherwise place
results in the bottom half of the window.")

(defvar sql-comment-regions-by-line t
  "*Setting sql-comment-regions-by-line to a non-nil value will comment out
each line when sql-comment-region is (or related functions are) invoked.
Setting sql-comment-regions-by-line to nil will cause a single
sql-comment-start-string and sql-comment-end-string to be inserted, 
regardless of the region size.")

(defvar sql-comment-buffer-ignore-lines 0
  "*Number of lines at the top of the buffer to ignore whe commenting and
un-commenting with sql-comment-buffer functions.")

(defvar sql-font-lock-buffers (if sql-lucid 'all nil)
  "*When non-nil, invoke font-lock-mode on selected sql-related mode buffers.
To specify buffers to fontify, set to 'all for all buffers, or a list of
which types of buffers, from 'sql-mode, 'sql-batch-mode, 'sql-interactive-mode
and 'sql-results-mode.

For example, to font lock sql-mode buffers and sql-batch-mode buffers, but not
sql-interactive-mode buffers or sql-results buffers, set the value of this
variable to '('sql-mode 'sql-batch-mode).")

(defvar sql-mark-changes t
  "*When non-nil, mark the changes that are made to an sql-results-buffer")

(defvar sql-association-mode-no-create nil
  "*Don't create a new buffer when associations are used from the
pop-up menu if non-nil.")

(defvar sql-risky-searches nil
  "*Search for regexps in a risky way if non-nil.
There seems to be a bug in the function buffer-syntactic-context.  I have
not been able to reliably reproduce this bug, but setting the value of this
variable to t will supress the hacks that prevent the bug from rearing it's
ugly head.  If set to a non-nil value, it is possible that sql code that
should be warned against will not.  This becomes a large bug as users get
more comfortable with their updates, relying on the warnings.")

(defvar sql-require-where t
  "*Require a `where' clause when the user enters SQL code matching regexp
sql-require-where-regexp.")

(defvar sql-require-where-regexp "\\<\\(delete\\|update\\|DELETE\\|UPDATE\\)[\t\n ]"
  "Regular expression matching SQL code that requires a `where' clause.")

(defvar sql-confirm-changes t
  "*Promt for a confirmation when the user enters SQL code matching regexp
sql-confirm-changes-regexp.")

(defvar sql-confirm-changes-regexp "\\<\\(delete\\|update\\|insert\\|truncate\\|DELETE\\|UPDATE\\|INSERT\\|TRUNCATE\\)[\t\n ]"
  "Regular expression matching SQL code that will make potentially
harmful changes to the database.")

(defvar sql-table-prefix-regexp "\\<\\(from\\|delete\\|update\\|into\\|truncate\\|FROM\\|DELETE\\|UPDATE\\|INTO\\|TRUNCATE\\)[\t\n ]"
  "Regular expression matching SQL code that will preceed a table name.")

(defvar sql-history-length 40
  "*Number of SQL batch commands to save in the history table.")

(defvar sql-global-history-length 40
  "*Number of SQL batch commands to save in the global history table.")
  
(defvar sql-deactivate-region nil
  "*Deactivate the region after a comment-region function is called when
non-nil.")

(defvar sql-basic-offset 4
  "*Indentation of SQL statements with respect to containing block.")

(defvar sql-continued-statement-offset 2
  "*Indentation of continued SQL statements with respect to the previous
line.")

(defvar sql-indent-after-newline nil
  "*Indent to the proper indentation after a newline if non-nil.")

(defvar sql-inhibit-startup-message nil
  "*Non-nil causes sql-mode not to display its copyright notice, disclaimers
etc. when started in the usual way.")

(defvar sql-add-to-menu-bar t
  "*Non-nil causes sql-mode to add entries to the menu bar to facilitate
the use of associations.")

(defvar sql-parent-menu (if (and sql-xemacs (> emacs-minor-version 11))
			    '("Apps")
			  '("Utilities"))
  "The menu item under which to add SQL menus.")

(defvar sql-hungry-delete-key nil
  "*Non-nil causes delete to eat all preceeding whitespace.")

(defvar sql-delete-function 'backward-delete-char
  "*Function to delete characters backwards.")

(defvar sql-results-buffer-percent 70
  "*Percent of the window that the results buffer should take up.")

(defvar sql-greedy-results-buffers nil
  "*If non-nil, resize the results buffer to take up as much room as possible
while still leaving the sql-batch-mode buffer visible, with minimum size to
be determined by `sql-results-buffer-percent'")

(defvar sql-mode-line-format '("-----" "SQL:  " server "  " user
			       database-name "   %[("
			       mode-name minor-mode-alist
			       "%n"  ")%]----" (-3 . "%p") "-%-")
  "Template for displaying mode line for sql-batch-mode,
sql-interactive-mode, and sql-results-mode buffers.")

(defvar sql-intersperse-headers nil
  "*Insert a header in the results buffer every N lines, where N is the
height of the results buffer.")

(defvar sql-sybase nil
  "Set the value of the SYBASE environment variable to this value if non-nil.
This provides a way to override the environment variable value.

Do not set this variable directly, instead use the function
`sql-set-sybase'.")

(defvar sql-bypass-cpp nil
  "*Bypass the cpp step when loading stored procedures when non-nil.")

(defvar sql-default-cpp-switches nil
  "*Default switches to pass to cpp when loading stored procedures.")

(defvar sql-holdup-stored-procedure nil
  "*Non-nil means keep stored procedure in batch buffer after load, and
do not execute.  Nil means execute immediately after insertion into the
buffer.")

(defvar sql-use-toolbar sql-xemacs-19-12
  "*Display a SQL Mode toolbar if non-nil.")

(defvar sql-use-big-menus nil
  "*Use larger menus if non-nil")

(defvar sql-error-regexp "Msg .* Level .* State .*\nServer .* Line "
  "*Regular expression to match error lines.")

(defvar sql-noisy t
  "*Make sounds in certain situations if non-nil.")

(defvar sql-string-column-types
  '("39" "45" "47" "58" "61")
  "*A list of column types that requre quotes.")

(defvar sql-ignore-column-types
  '("34" "35" "37" "111")
  "*A list of column types that should be ignored when doing an update.")

(defvar sql-stay-in-batch-buffer nil
  "*A non-nil value will keep the cursor in the sql-batch-mode buffer.
If the value of this variable is nil, the cursor will be in the
results buffer after executin sql-evaluate-buffer.")

;(defvar sql-reposition-windows-when-done nil
;  "*Reposition the batch buffer when the query terminates if non-nil.
;This variable only applies if you invoke the function
;`sql-evaluate-buffer-asyncronous'.")

(defvar sql-finished-query-options '(ding message)
  "*A list of symbols representing things to do when a query is done.
Possibilities are:

'ding		Signal with an audible bell
'open		Open (deiconify) the frame containing the batch and results
		buffers
'raise		Raise the frame containing the batch and results buffers
'rows		Print the number of rows affected as a message in the echo area")

(defvar sql-print-command (if (boundp 'enscript-switches)
			      'enscript-buffer
			    'lpr-buffer)
  "*Command to print a buffer.")

(defvar sql-print-switches (if (boundp 'enscript-switches)
			       '("-fCourier8")
			     nil)
  "*Switches to pass to sql-print-command when printing a buffer.
If non-nil, these will override the values of lpr-swithces and
enscript-switches as appropriate.")

(defvar sql-print-characters-per-line (if (boundp 'enscript-switches)
					  113
					80)
  "*Number of characters to print per line when printing results buffers.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End User Definable Variables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sql-mode-version "0.919.1 (beta)")

(defvar sql-mode-help-address "sql-mode-help@atlantic2.sbi.com")

(defvar sql-loaded nil)

(defvar sql-initialized nil)

(defvar sql-screen nil)

(defvar sql-process nil)

(defvar sql-dont-warn nil)

(defvar sql-temp-string nil)

(defvar sql-query-in-progress nil)

(defvar sql-update-virgin-column-pairs nil)

(defvar sql-update-virgin-line nil)

(defvar sql-results-mode-editing nil)

(defvar sql-marking-changes nil)

(defvar sql-global-move-headers t)

(defvar sql-move-headers t)

(defvar sql-header-text nil)

(defvar sql-interfaces-file-name nil)

(defvar sql-matching-buffer nil)

(defvar sql-association-alist nil)

(defvar sql-history nil)

(defvar sql-history-index 0)

(defvar sql-global-history nil)

(defvar sql-global-history-index 0)

(defvar sql-old-history nil)

(defvar sql-old-history-index 0)

(defvar sql-top-ten (make-vector 10 nil))

(defvar sql-history-file-name (concat (getenv "HOME") "/.sql-history"))

(defvar sql-global-history-file-name (concat (getenv "HOME")
					     "/.sql-global-history"))

(defvar sql-top-ten-file-name (concat (getenv "HOME") "/.sql-top-ten"))

(defvar sql-commented-line-regexp (concat sql-comment-start-regexp
					   ".*"
					   sql-comment-end-regexp))

(defvar old-after-change-function nil)

(defvar sql-strict-syntax-p t)

(defvar sql-echo-syntactic-information-p t)

(defvar sql-current-error-point nil)

(defvar sql-old-contents nil)

(defvar sql-old-window-configuration nil)

(defvar sql-linked-windows nil)

(defvar database nil)

(defvar sql-server-table nil)

(defvar sql-user-table nil)

(defvar sql-table-list nil)

(defvar sql-database-list nil)

(defvar sql-column-list nil)

(defvar sql-stored-procedure-list nil)

(defvar sql-keyword-list nil)

(defvar sql-keywords '("select" "from" "where" "tran" "transaction" "commit" "group" "exec" "execute" "readtext" "rollback" "compute" "union" "by" "order" "having" "set" "update" "delete" "insert" "into" "writetext" "values" "go" "use" "null" "begin" "end" "else" "if" "goto" "break" "continue" "raiserror" "waitfor" "and" "or" "not" "in" "is" "declare" "print" "return" "exists" "like" "sum" "avg" "count" "max" "min" "all" "distinct" "alter" "table" "database" "create" "disk" "nonclustered" "reconfigure" "revoke" "override" "procedure" "proc" "checkpoint" "dump" "drop" "index" "fillfactor" "rule" "shutdown" "tape" "view" "truncate" "kill" "load" "clustered" "dbcc" "grant" "as" "with" "nowait" "no_log" "refit" "reinit" "init" "mirror" "unmirror" "remirror" "default" "statistics" "SELECT" "FROM" "WHERE" "TRAN" "TRANSACTION" "COMMIT" "GROUP" "EXEC" "EXECUTE" "READTEXT" "ROLLBACK" "COMPUTE" "UNION" "BY" "ORDER" "HAVING" "SET" "UPDATE" "DELETE" "INSERT" "INTO" "WRITETEXT" "VALUES" "GO" "USE" "NULL" "BEGIN" "END" "ELSE" "IF" "GOTO" "BREAK" "CONTINUE" "RAISERROR" "WAITFOR" "AND" "OR" "NOT" "IN" "IS" "DECLARE" "PRINT" "RETURN" "EXISTS" "LIKE" "SUM" "AVG" "COUNT" "MAX" "MIN" "ALL" "DISTINCT" "ALTER" "TABLE" "DATABASE" "CREATE" "DISK" "NONCLUSTERED" "RECONFIGURE" "REVOKE" "OVERRIDE" "PROCEDURE" "PROC" "CHECKPOINT" "DUMP" "DROP" "INDEX" "FILLFACTOR" "RULE" "SHUTDOWN" "TAPE" "VIEW" "TRUNCATE" "KILL" "LOAD" "CLUSTERED" "DBCC" "GRANT" "AS" "WITH" "NOWAIT" "NO_LOG" "REFIT" "REINIT" "INIT" "MIRROR" "UNMIRROR" "REMIRROR" "DEFAULT" "STATISTICS"))

(defvar sql-keyword-regexps "\\(\(\\|\{select\\|from\\|where\\|tran\\|transaction\\|commit\\|group\\|exec\\|execute\\|readtext\\|rollback\\|compute\\|union\\|by\\|order\\|having\\|set\\|update\\|delete\\|insert\\|into\\|writetext\\|values\\|go\\|use\\|null\\|begin\\|end\\|else\\|if\\|goto\\|break\\|continue\\|raiserror\\|waitfor\\|and\\|or\\|not\\|in\\|is\\|declare\\|print\\|return\\|exists\\|like\\|sum\\|avg\\|count\\|max\\|min\\|all\\|distinct\\|alter\\|table\\|database\\|create\\|disk\\|nonclustered\\|reconfigure\\|revoke\\|override\\|procedure\\|proc\\|checkpoint\\|dump\\|drop\\|index\\|fillfactor\\|rule\\|shutdown\\|tape\\|view\\|truncate\\|kill\\|load\\|clustered\\|dbcc\\|grant\\|as\\|with\\|nowait\\|no_log\\|refit\\|reinit\\|init\\|mirror\\|unmirror\\|remirror\\|default\\|sp_[a-zA-Z]*\\|statistics\\SELECT\\|FROM\\|WHERE\\|TRAN\\|TRANSACTION\\|COMMIT\\|GROUP\\|EXEC\\|EXECUTE\\|READTEXT\\|ROLLBACK\\|COMPUTE\\|UNION\\|BY\\|ORDER\\|HAVING\\|SET\\|UPDATE\\|DELETE\\|INSERT\\|INTO\\|WRITETEXT\\|VALUES\\|GO\\|USE\\|NULL\\|BEGIN\\|END\\|ELSE\\|IF\\|GOTO\\|BREAK\\|CONTINUE\\|RAISERROR\\|WAITFOR\\|AND\\|OR\\|NOT\\|IN\\|IS\\|DECLARE\\|PRINT\\|RETURN\\|EXISTS\\|LIKE\\|SUM\\|AVG\\|COUNT\\|MAX\\|MIN\\|ALL\\|DISTINCT\\|ALTER\\|TABLE\\|DATABASE\\|CREATE\\|DISK\\|NONCLUSTERED\\|RECONFIGURE\\|REVOKE\\|OVERRIDE\\|PROCEDURE\\|PROC\\|CHECKPOINT\\|DUMP\\|DROP\\|INDEX\\|FILLFACTOR\\|RULE\\|SHUTDOWN\\|TAPE\\|VIEW\\|TRUNCATE\\|KILL\\|LOAD\\|CLUSTERED\\|DBCC\\|GRANT\\|AS\\|WITH\\|NOWAIT\\|NO_LOG\\|REFIT\\|REINIT\\|INIT\\|MIRROR\\|UNMIRROR\\|REMIRROR\\|DEFAULT\\|SP_[a-zA-Z]*\\|STATISTICS\\)[\t\n ]")

(defvar sql-bos-regexps "\\(return\\|go\\|if\\|else\\|begin\\|select\\|update\\|RETURN\\|GO\\|IF\\|ELSE\\|BEGIN\\|SELECT\\|UPDATE\\)\\>")

(defvar sql-offsets-alist
  '((string                . -1000)
;    (c                     . c-lineup-C-comments)
    (defun-open            . 0)
    (defun-close           . 0)
    (defun-block-intro     . +)
    (class-open            . 0)
    (class-close           . 0)
    (inline-open           . +)
    (inline-close          . 0)
    (c++-funcdecl-cont     . -)
    (knr-argdecl-intro     . +)
    (knr-argdecl           . 0)
    (topmost-intro         . 0)
    (topmost-intro-cont    . 0)
    (member-init-intro     . +)
    (member-init-cont      . 0)
;    (inher-intro           . +)
;    (inher-cont            . c-lineup-multi-inher)
    (block-open            . 0)
    (block-close           . 0)
    (brace-list-open       . 0)
    (brace-list-close      . 0)
    (brace-list-intro      . +)
    (brace-list-entry      . 0)
    (statement             . 0)
    (default-statement	   . 0)
    (statement-cont        . +)
    ;; some people might prefer
    ;;(statement-cont        . c-lineup-math)
    (statement-block-intro . +)
    (statement-case-intro  . +)
    (substatement          . +)
    (substatement-open     . +)
    (case-label            . 0)
    (access-label          . -)
    (label                 . 2)
    (do-while-closure      . 0)
    (else-clause           . 0)
;    (comment-intro         . c-lineup-comment)
    (arglist-intro         . +)
    (arglist-cont          . 0)
    (arglist-cont-nonempty . c-lineup-arglist)
    (arglist-close         . +)
    (cpp-macro             . -1000))
  "Default settings for offsets of syntactic elements.
Do not change this constant!  See the variable `sql-offsets-alist' for
more information.

Indentation is currently not fully implemented in SQL Mode.")

(defvar sql-startup-message-lines
  '("Type C-c h for general help on SQL Mode."
    "Type C-h m for help on the current mode."
    "Please use \\[sql-submit-bug-report] to report bugs."
    "Please use \\[sql-submit-enhancement-request] to request enhancements."
    "This is prerelease software.  Use at your own risk."
    "SQL Mode comes with ABSOLUTELY NO WARRANTY."
    "Closed Captioned (CC) for the hearing impaired."))

(defvar sql-command-level 1)

(defconst sql-options-menu-saved-forms
  (purecopy
   '(sql-font-lock-buffers
     sql-mark-changes
     sql-video-type
     sql-command
     sql-batch-command-switches
     sql-interactive-command-switches
     sql-history-length
     sql-global-history-length
     sql-require-final-go
     sql-secure-passwords
     sql-abbrev-mode
;     sql-minibuffer-status
     sql-comment-regions-by-line
     sql-require-where
     sql-confirm-changes
     sql-indent-after-newline
     sql-hungry-delete-key
     sql-save-all-results
     sql-resize-results-screens
     sql-results-screen-width
     sql-results-screen-height
     sql-max-screen-width
     sql-intersperse-headers
     sql-use-toolbar
     sql-use-big-menus
     sql-stay-in-batch-buffer))
  "The variables to save; or forms to evaluate to get forms to write out.")

(defvar sql-old-menu (and sql-xemacs (copy-sequence current-menubar)))

(defvar sql-execute-menu
  '(("Execute"
     ["Evaluate Buffer"			sql-evaluate-buffer		t]
     ["Evaluate Buffer in Background"	sql-evaluate-buffer-asyncronous	t]
     ["Evaluate Region"			sql-evaluate-region		(mark)]
     "----"
     ["Abort Evaluation"		sql-abort			t]
     "----"
     ["Run sp_lock"			sql-sp-lock			t]
     ["Run sp_who"			sql-sp-who			t]
     ["Run sp_what"			sql-sp-what			t]
     "----"
     ("Execute Top Ten Query"
      ["Execute Top Ten #1"		sql-run-top-ten-1
      (aref sql-top-ten 1)]
      ["Execute Top Ten #2"		sql-run-top-ten-2
      (aref sql-top-ten 2)]
      ["Execute Top Ten #3"		sql-run-top-ten-3
      (aref sql-top-ten 3)]
      ["Execute Top Ten #4"		sql-run-top-ten-4
      (aref sql-top-ten 4)]
      ["Execute Top Ten #5"		sql-run-top-ten-5
      (aref sql-top-ten 5)]
      ["Execute Top Ten #6"		sql-run-top-ten-6
      (aref sql-top-ten 6)]
      ["Execute Top Ten #7"		sql-run-top-ten-7
      (aref sql-top-ten 7)]
      ["Execute Top Ten #8"		sql-run-top-ten-8
      (aref sql-top-ten 8)]
      ["Execute Top Ten #9"		sql-run-top-ten-9
      (aref sql-top-ten 9)]
      ["Execute Top Ten #0          "	sql-run-top-ten-0
      (aref sql-top-ten 0)])
     "----"
     ["Load Stored Procedure (CPP)"   	sql-load-sp			t]
     ["Load Stored Procedure (No CPP)"  (let ((sql-bypass-cpp t))
					  (call-interactively 'sql-load-sp)) t]
     "----"
     ["Insert Row..."			sql-insert-row			t]
     "----"
     ["BCP Table IN..."			sql-bcp-in-menu			t]
     ["BCP Table OUT..."		sql-bcp-out-menu		t]
     )))

(defvar sql-actions-menu
  '(("Actions"
     ["Insert File..."			sql-insert-file			t]
     "----"
     ["Insert Stored Procedure (CPP)"	sql-insert-sp			t]
     ["Insert Stored Procedure (No CPP)"	(sql-insert-sp t)	t]
     "----"
     ("Insert Top Ten Query"
      ["Insert Top Ten #1"		sql-insert-top-ten-1
      (aref sql-top-ten 1)]
      ["Insert Top Ten #2"		sql-insert-top-ten-2
      (aref sql-top-ten 2)]
      ["Insert Top Ten #3"		sql-insert-top-ten-3
      (aref sql-top-ten 3)]
      ["Insert Top Ten #4"		sql-insert-top-ten-4
      (aref sql-top-ten 4)]
      ["Insert Top Ten #5"		sql-insert-top-ten-5
      (aref sql-top-ten 5)]
      ["Insert Top Ten #6"		sql-insert-top-ten-6
      (aref sql-top-ten 6)]
      ["Insert Top Ten #7"		sql-insert-top-ten-7
      (aref sql-top-ten 7)]
      ["Insert Top Ten #8"		sql-insert-top-ten-8
      (aref sql-top-ten 8)]
      ["Insert Top Ten #9"		sql-insert-top-ten-9
      (aref sql-top-ten 9)]
      ["Insert Top Ten #0          "	sql-insert-top-ten-0
      (aref sql-top-ten 0)])
     ["Save Current as Top Ten"		sql-add-top-ten			t]
     "----"
     ["Clear Cached Data"		sql-clear-cached-data		t]
     ["Clear Batch and Results Buffers" sql-new-query			t]
     "----"
     ["Next Error"			sql-next-error			t]
     ["Previous Error"			sql-previous-error		t]
     "----"
     ["Print Buffer"			sql-print-buffer		t]
     "----"
     ["Exit SQL Mode"			sql-exit-sql-mode		t]
     ["Exit Emacs"			save-buffers-kill-emacs		t]
     )))

(defvar sql-history-menu
  '(("History"
     ["Previous History"		sql-previous-history		t]
     ["Next History"			sql-next-history		t]
     ["Previous Global History"		sql-previous-global-history	t]
     ["Next Global History"		sql-next-global-history		t]
     ["Previous Matching History"	sql-previous-matching-history	t]
     ["Goto History..."			sql-goto-history		t]     
     ["Goto Global History..."		sql-goto-global-history		t]
     "----"
     ["Save History"			sql-save-history		t]
     ["Load History"			sql-load-history		t]
     ["Save Global History"		sql-save-global-history		t]
     ["Load Global History"		sql-load-global-history		t]
     )))

(defvar sql-settings-menu
  '(("Settings"
     ["Use Database..."			sql-set-database		t]
     ["Reset Database"			sql-reset-database		t]
     "----"
     ["Set Server, User, and Password..."	sql-set-server		t]
     ["Set User and Password..."	sql-set-user			t]
     ["Set Password..."			sql-set-password		t]
     "----"
     ["Set BCP User..."			sql-set-bcp-user		t]
     )))

(defvar sql-help-menu
  '(("Help"
     ["About SQL Mode..."		sql-about-sql-mode		t]
     "----"
     ["SQL Info"			sql-info			nil]
     ["Current Buffer Info"		sql-current-buffer-info		t]
     "----"
     ["Describe Mode"			describe-mode			t]
     ["Describe Key..."			describe-key			t]
     ["Describe Function..."		describe-function		t]
     ["Describe Variable..."		describe-variable		t]
     "----"
     ["Request Latest Version"		sql-request-latest-version	t]
     ["Submit Enhancement Request"	sql-submit-enhancement-request	t]
     ["Submit Bug Report"		sql-submit-bug-report		t]
     )))

(defvar sql-font-lock-menu
  '(("Coloring"
     ["None"	(setq sql-font-lock-buffers nil)
      :style radio
      :selected (eq sql-font-lock-buffers nil)]
     ["All"	(setq sql-font-lock-buffers 'all)
      :style radio
      :selected (eq sql-font-lock-buffers 'all)]
     "----"
     ["SQL Mode Buffers"  		(sql-toggle-font-lock 'sql-mode)
      :style toggle
      :selected (or (eq sql-font-lock-buffers 'all)
		    (member 'sql-mode sql-font-lock-buffers))]
     ["SQL Batch Mode Buffers"  	(sql-toggle-font-lock 'sql-batch-mode)
      :style toggle
      :selected (or (eq sql-font-lock-buffers 'all)
		    (member 'sql-batch-mode sql-font-lock-buffers))]
     ["SQL Interactive Buffers"  	(sql-toggle-font-lock
					 'sql-interactive-mode)
      :style toggle
      :selected (or (eq sql-font-lock-buffers 'all)
		    (member 'sql-interactive-mode sql-font-lock-buffers))]
     ["SQL Results Buffers"  		(sql-toggle-font-lock
					 'sql-results-mode)
      :style toggle
      :selected (or (eq sql-font-lock-buffers 'all)
		    (member 'sql-results-mode sql-font-lock-buffers))]
     "----"
     ["Mark Changes" 			(sql-toggle-marking-changes)
      :style toggle
      :selected sql-marking-changes]
     "----"
     ["Regular Video"			(progn (setq sql-video-type 'regular)
					       (sql-setup-font-lock))
      :style radio
      :selected (eq sql-video-type 'regular)]
     ["Inverse Video"			(progn (setq sql-video-type 'inverse)
					       (sql-setup-font-lock))
      :style radio
      :selected (eq sql-video-type 'inverse)]
     ["Monochrome"			(progn (setq sql-video-type 'monochrome)
					       (sql-setup-font-lock))
      :style radio
      :selected (eq sql-video-type 'monochrome)]
     "----"
     ["Current Buffer"		sql-toggle-font-lock
      :style toggle
      :selected font-lock-mode])))

(defvar sql-options-menu
  (list
   (append
    '("Options")
    sql-font-lock-menu
    '(["SYBASE Environment Variable..."	sql-set-sybase			 t]
      ["SQL Command..."		sql-set-sql-command			 t]
      ["SQL Batch Command Switches..."
       (sql-set-variable 'sql-batch-command-switches) 			 t]
      ["SQL Interactive Command Switches..."
       (sql-set-variable 'sql-interactive-command-switches) 		 t]
      ["History Length..."	(sql-set-variable 'sql-history-length t) t]
      ["Global History Length..." (sql-set-variable 'sql-global-history-length
						    t) t]
      "----"
      ["Require Final `go'"		(setq sql-require-final-go
					      (not sql-require-final-go))
       :style toggle
       :selected sql-require-final-go]
      ["Secure Passwords"		(setq sql-secure-passwords
					      (not sql-secure-passwords))
       :style toggle
       :selected sql-secure-passwords]
      ["Abbrev Mode"			(progn (setq sql-abbrev-mode
						     (not sql-abbrev-mode))
					       (abbrev-mode))
       :style toggle
       :selected abbrev-mode]
;      ["Display Status in Minibuffer" 	(setq sql-minibuffer-status
;					      (not sql-minibuffer-status))
;       :style toggle
;       :selected sql-minibuffer-status]
      ["Comment Regions By Line"		(setq sql-comment-regions-by-line
						      (not sql-comment-regions-by-line))
       :style toggle
       :selected sql-comment-regions-by-line]
      ["Stay in Batch Buffer"		(setq sql-stay-in-batch-buffer
					      (not sql-stay-in-batch-buffer))
       :style toggle
       :selected sql-stay-in-batch-buffer]
      "----"
      ["Require Where Clause"		(setq sql-require-where
					      (not sql-require-where))
       :style toggle
       :selected sql-require-where]
      ["Confirm All Changes"		(setq sql-confirm-changes
					      (not sql-confirm-changes))
       :style toggle
       :selected sql-confirm-changes]
      "----"
      ["Auto Indent"			(setq sql-indent-after-newline
					      (not sql-indent-after-newline))
       :style toggle
       :selected sql-indent-after-newline]
      ["Hungry Delete"			(setq sql-hungry-delete-key
					      (not sql-hungry-delete-key))
       :style toggle
       :selected sql-hungry-delete-key]
;      "----"
      ["Save All Results"		(setq sql-save-all-results
					      (not sql-save-all-results))
       :style toggle
       :selected sql-save-all-results]
;      ["Results In New Screen"		(setq sql-results-in-new-screen
;					      (not sql-results-in-new-screen))
;       :style toggle
;       :selected sql-results-in-new-screen]
;      ["Resize Results Screens"		(setq sql-resize-results-screens
;					      (not sql-resize-results-screens))
;       :style toggle
;       :selected sql-resize-results-screens]
;      ["Results Screen Width..."		(sql-set-variable
;						 'sql-results-screen-width t)
;       sql-resize-results-screens]
;      ["Results Screen Height..."	(sql-set-variable 
;					 'sql-results-screen-height t)
;       sql-resize-results-screens]
;      ["Maximum Results Width..."	(sql-set-variable
;					 'sql-max-screen-width t)
;       t]
      ["Intersperse Headers"		(setq sql-intersperse-headers
					      (not sql-intersperse-headers))
       :style toggle
       :selected sql-intersperse-headers]
      "----"
      ["Display SQL Mode Toolbar"	sql-toolbar
       :style toggle
       :selected sql-use-toolbar]
      "----"
      ["Use Big Menus"			sql-toggle-big-menus
       :style toggle
       :selected sql-use-big-menus]
      "----"
      ["Save Current Options"	sql-save-current-options		 t])
					;   '("----")
    )))

(defvar sql-mode-menu
  (append
   '("SQL")
   (if (and sql-lucid (boundp 'emacs-minor-version) (> emacs-minor-version 9))
       sql-options-menu
     '(["Auto Indent"			sql-toggle-auto-indent t]
       "----"))
   '(["Indent Line"			sql-indent-line			 t]
     ["Indent Region"			indent-region			 t]
     "----"
     ["Toggle Line Comments"		sql-comment-line-toggle  	 t]
     "----"
     ["Comment Region"			sql-comment-region		 t]
     ["Uncomment Region"		sql-uncomment-region		 t]
     ["Toggle Region Comments"		sql-comment-region-toggle	 t]
     "----"
     ["Comment Buffer"			sql-comment-buffer		 t]
     ["Uncomment Buffer"		sql-uncomment-buffer		 t]
     ["Toggle Buffer Comments"		sql-comment-buffer-toggle	 t]
     "----"
     ["Show Current Buffer Info"	sql-current-buffer-info	 	 t]
     "----"
     ["Submit Enhancement Request"	sql-submit-enhancement-request	 t]
     ["Submit Bug Report"		sql-submit-bug-report		 t]
     "----"
     ["About SQL Mode..."		sql-about-sql-mode		 t]
     "----"
     ["Exit SQL Mode"			sql-exit-sql-mode		 t]
     )))

(defvar sql-batch-mode-menu
  (append
   '("SQL")
    (if (and sql-lucid (boundp 'emacs-minor-version) (> emacs-minor-version 9))
	sql-options-menu
      '(["Save All Results"  		sql-toggle-save-all-results      t]
	["Results in New Screen" 	sql-toggle-results-in-new-screen t]
	"----"))
    '(["Evaluate Buffer"		sql-evaluate-buffer		 t]
      ["Evaluate Buffer in Background"	sql-evaluate-buffer-asyncronous	 t]
      ["Evaluate Region"		sql-evaluate-region              t]
      ["Abort Evaluation"		sql-abort			 t]
      "----"
      ["Use Database..."		sql-set-database		 t]
      ["Reset Database"			sql-reset-database		 t]
      ["Clear Cached Data"		sql-clear-cached-data		 t]
      "----"
      ["Set Server, User, and Password..."	sql-set-server		 t]
      ["Set User and Password..."	sql-set-user			 t]
      ["Set Password..."		sql-set-password		 t]
      "----"
      ("Comments"
       ["Toggle Line Comments"		sql-comment-line-toggle		 t]
       "----"
       ["Comment Region"		sql-comment-region		 t]
       ["Uncomment Region"		sql-uncomment-region		 t]
       ["Toggle Region Comments"	sql-comment-region-toggle	 t]
       "----"
       ["Comment Buffer"		sql-comment-buffer		 t]
       ["Uncomment Buffer"		sql-uncomment-buffer		 t]
       ["Toggle Buffer Comments"	sql-comment-buffer-toggle	 t])
      "----"
      ["Save Current History"		sql-save-history		 t]
      ["Load History"			sql-load-history		 t]
      "----"
      ["Save Global History"		sql-save-global-history		 t]
      ["Load Global History"		sql-load-global-history		 t]
      "----"
      ["Show Current Buffer Info"	sql-current-buffer-info		 t]
      "----"
      ["Submit Enhancement Request"	sql-submit-enhancement-request	 t]
      ["Submit Bug Report"		sql-submit-bug-report		 t]
      "----"
      ["About SQL Mode..."		sql-about-sql-mode		 t]
      "----"
      ["Exit SQL Mode"			sql-exit-sql-mode		 t]
      )))

(defvar sql-interactive-mode-menu
  (append
   '("SQL")
   (if (and sql-lucid (boundp 'emacs-minor-version) (> emacs-minor-version 9))
       sql-options-menu
     ())
   '(["Toggle Line Comments"		sql-comment-line-toggle		 t]
     "----"
     ["Scroll Left"			scroll-left			 t]
     ["Scroll Right"			scroll-right			 t]
     "----"
     ["Forward Column"			sql-forward-column		 t]
     ["Backward Column"			sql-backward-column		 t]
     "----"
     ["Recenter"			sql-recenter			 t]
     "----"
     ["Show Current Buffer Info"	sql-current-buffer-info		 t]
     "----"
     ["Submit Enhancement Request"	sql-submit-enhancement-request	 t]
     ["Submit Bug Report"		sql-submit-bug-report		 t]
     "----"
     ["About SQL Mode..."		sql-about-sql-mode		 t]
     "----"
     ["Exit SQL Mode"			sql-exit-sql-mode		 t]
     )))

(defvar sql-results-mode-menu
  (append
   '("SQL")
   (if (and sql-lucid (boundp 'emacs-minor-version) (> emacs-minor-version 9))
       sql-options-menu
     ())
   '(["Edit Mode"			sql-edit-toggle
      :style toggle
      :selected sql-results-mode-editing]
     ["First Row"			sql-first-row			 t]
     ["Last Row"			sql-last-row			 t]
     ["Beginning of Row"		sql-beginning-of-row		 t]
     ["End of Row"			sql-end-of-row			 t]
     "----"
     ["Forward Column"			sql-forward-column		 t]
     ["Backward Column"			sql-backward-column		 t]
     "----"
     ["Edit Row at Point"		sql-edit-row			 t]
     "----"
     ["Insert Header"			sql-insert-header		 t]
     ["Recenter"			sql-recenter			 t]
     "----"
     ["Pop Results Buffer"		sql-pop-and-rename-buffer 	 t]
     "----"
     ["Print Results Buffer"		sql-print-buffer-tiled	 t]
     "----"
     ["Show Current Buffer Info"	sql-current-buffer-info		 t]
     "----"
     ["Submit Enhancement Request"	sql-submit-enhancement-request	 t]
     ["Submit Bug Report"		sql-submit-bug-report		 t]
     "----"
     ["About SQL Mode..."		sql-about-sql-mode		 t]
     "----"
     ["Exit SQL Mode"			sql-exit-sql-mode		 t]
     )))

(defvar sql-mode-syntax-table nil
  "Syntax table used while in sql-mode.")
(if sql-mode-syntax-table
    ()
  (setq sql-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?/ ". 14" sql-mode-syntax-table)  ; comment start
  (modify-syntax-entry ?* ". 23" sql-mode-syntax-table)
  (modify-syntax-entry ?+ "." sql-mode-syntax-table)
  (modify-syntax-entry ?- "." sql-mode-syntax-table)
  (modify-syntax-entry ?= "." sql-mode-syntax-table)
  (modify-syntax-entry ?% "w" sql-mode-syntax-table)
  (modify-syntax-entry ?< "." sql-mode-syntax-table)
  (modify-syntax-entry ?> "." sql-mode-syntax-table)
  (modify-syntax-entry ?& "w" sql-mode-syntax-table)
  (modify-syntax-entry ?| "." sql-mode-syntax-table)
  (modify-syntax-entry ?_ "w" sql-mode-syntax-table)    ; make _ part of words
  (modify-syntax-entry ?\' "\"" sql-mode-syntax-table))

(defvar sql-help-map
  (let ((map (make-sparse-keymap)))
    (and sql-lucid (set-keymap-name map 'sql-help-map))
    (and sql-lucid (set-keymap-prompt map "(Type h or ? for further options)"))
    map)
  "Keymap for characters following the SQL Help key.")

(fset 'sql-help-command sql-help-map)

(define-key sql-help-map "h" 'sql-help-for-help)
(define-key sql-help-map "?" 'sql-help-for-help)
(define-key sql-help-map "a" 'sql-advanced-usage-info)
(define-key sql-help-map "b" 'sql-basic-usage-info)
(define-key sql-help-map "c" 'sql-customization-info)
;(define-key sql-help-map "e" 'sql-evaluate-buffer)
(define-key sql-help-map "i" 'sql-current-buffer-info)
(define-key sql-help-map "k" 'sql-describe-keybindings)
(define-key sql-help-map "m" 'sql-masthead-info)
(define-key sql-help-map "n" 'sql-next-error)
(define-key sql-help-map "p" 'sql-previous-error)
(define-key sql-help-map "r" 'sql-bug-report-info)
(define-key sql-help-map "s" 'sql-about-sql-mode)
(define-key sql-help-map "q" 'sql-help-quit)

(defvar sql-mode-map ()
  "Keymap used while in an sql-mode buffer.")
(if sql-mode-map
    ()
  (setq sql-mode-map (make-keymap))
  (and sql-lucid (set-keymap-name sql-mode-map 'sql-mode-map))
  (define-key sql-mode-map [(return)] 'sql-newline-maybe-indent)
  (define-key sql-mode-map [(newline)] 'sql-newline-maybe-indent)
  (define-key sql-mode-map [(delete)] 'sql-electric-delete)
  (define-key sql-mode-map "\C-c\C-c" 'sql-comment-line-toggle)
  (define-key sql-mode-map "\C-c\C-b" 'sql-comment-buffer-toggle)
  (define-key sql-mode-map "\C-c\C-i" 'sql-comment-buffer)
  (define-key sql-mode-map "\C-c\C-r" 'sql-uncomment-buffer)
  (define-key sql-mode-map "\C-c\C-q" 'sql-exit-sql-mode)
  (define-key sql-mode-map "\C-cc" 'sql-display-completion-context)
  (define-key sql-mode-map "\C-c\C-s" 'sql-show-syntactic-information)
  (define-key sql-mode-map "\C-ch" 'sql-help-command))

(defvar sql-batch-mode-map ()
  "Keymap used while in an sql-batch-mode buffer.")
(if sql-batch-mode-map
    ()
  (setq sql-batch-mode-map (make-keymap))
  (and sql-lucid (set-keymap-name sql-batch-mode-map 'sql-batch-mode-map))
  (define-key sql-batch-mode-map [(delete)] 'sql-electric-delete)
  (define-key sql-batch-mode-map "\M-\i" 'sql-evaluate-buffer)
  (define-key sql-batch-mode-map "\M-e" 'sql-evaluate-buffer-asyncronous)
  (define-key sql-batch-mode-map "\C-c\C-e" 'sql-evaluate-buffer)	
  (define-key sql-batch-mode-map "\C-c\C-c" 'sql-comment-line-toggle)
  (define-key sql-batch-mode-map "\C-c\C-b" 'sql-comment-buffer-toggle)
  (define-key sql-batch-mode-map "\C-c\C-i" 'sql-comment-buffer)
  (define-key sql-batch-mode-map "\C-c\C-r" 'sql-uncomment-buffer)
  (define-key sql-batch-mode-map "\C-c\C-s" 'sql-set-server)
  (define-key sql-batch-mode-map "\C-c\C-u" 'sql-set-user)
  (define-key sql-batch-mode-map "\C-c\C-p" 'sql-set-password)
  (define-key sql-batch-mode-map "\C-c\C-a" 'sql-association-mode)
  (define-key sql-batch-mode-map "\C-c\C-d" 'sql-set-database)
  (define-key sql-batch-mode-map "\C-c0" 'sql-insert-top-ten-0)
  (define-key sql-batch-mode-map "\C-c1" 'sql-insert-top-ten-1)
  (define-key sql-batch-mode-map "\C-c2" 'sql-insert-top-ten-2)
  (define-key sql-batch-mode-map "\C-c3" 'sql-insert-top-ten-3)
  (define-key sql-batch-mode-map "\C-c4" 'sql-insert-top-ten-4)
  (define-key sql-batch-mode-map "\C-c5" 'sql-insert-top-ten-5)
  (define-key sql-batch-mode-map "\C-c6" 'sql-insert-top-ten-6)
  (define-key sql-batch-mode-map "\C-c7" 'sql-insert-top-ten-7)
  (define-key sql-batch-mode-map "\C-c8" 'sql-insert-top-ten-8)
  (define-key sql-batch-mode-map "\C-c9" 'sql-insert-top-ten-9)
  (define-key sql-batch-mode-map '[(control c) (control \0)] 'sql-run-top-ten-0)
  (define-key sql-batch-mode-map '[(control c) (control \1)] 'sql-run-top-ten-1)
  (define-key sql-batch-mode-map '[(control c) (control \2)] 'sql-run-top-ten-2)
  (define-key sql-batch-mode-map '[(control c) (control \3)] 'sql-run-top-ten-3)
  (define-key sql-batch-mode-map '[(control c) (control \4)] 'sql-run-top-ten-4)
  (define-key sql-batch-mode-map '[(control c) (control \5)] 'sql-run-top-ten-5)
  (define-key sql-batch-mode-map '[(control c) (control \6)] 'sql-run-top-ten-6)
  (define-key sql-batch-mode-map '[(control c) (control \7)] 'sql-run-top-ten-7)
  (define-key sql-batch-mode-map '[(control c) (control \8)] 'sql-run-top-ten-8)
  (define-key sql-batch-mode-map '[(control c) (control \9)] 'sql-run-top-ten-9)
  (define-key sql-batch-mode-map "\C-ct" 'sql-add-top-ten)
  (define-key sql-batch-mode-map "\C-cc" 'sql-display-completion-context)
  (define-key sql-batch-mode-map "\M-p" 'sql-previous-history)
  (define-key sql-batch-mode-map "\M-n" 'sql-next-history)
  (define-key sql-batch-mode-map "\M-m" 'sql-previous-matching-history)
  (define-key sql-batch-mode-map "\M-P" 'sql-previous-global-history)
  (define-key sql-batch-mode-map "\M-N" 'sql-next-global-history)
  (define-key sql-batch-mode-map "\C-cn" 'sql-next-error)
  (define-key sql-batch-mode-map "\C-cp" 'sql-previous-error)
  (define-key sql-batch-mode-map [(tab)] 'sql-complete-word-maybe)
  (define-key sql-batch-mode-map [(control L)] 'sql-reposition-windows)
  (define-key sql-batch-mode-map "\C-l" 'sql-recenter)
  (define-key sql-batch-mode-map [(button3)] 'sql-dynamic-popup-menu)
  (define-key sql-batch-mode-map "\C-c\C-q" 'sql-exit-sql-mode)
  (define-key sql-batch-mode-map "\C-ch" 'sql-help-command)
  (define-key sql-batch-mode-map "\C-cl" 'sql-reposition-windows))

(defvar sql-interactive-mode-map ()
  "Keymap used while in an sql-interactive-mode buffer.")
(if sql-interactive-mode-map
    ()
  (setq sql-interactive-mode-map (copy-keymap comint-mode-map))
  (and sql-lucid
       (set-keymap-name sql-interactive-mode-map 'sql-interactive-mode-map))
;  (define-key sql-interactive-mode-map [(delete)] 'sql-electric-delete)
  (define-key sql-interactive-mode-map "\C-a" 'sql-beginning-of-command-line)
  (define-key sql-interactive-mode-map "\C-e" 'sql-end-of-row)
  (define-key sql-interactive-mode-map [(backspace)] 'sql-backward-delete-char)
  (define-key sql-interactive-mode-map [(delete)] 'sql-backward-delete-char)
  (define-key sql-interactive-mode-map [(control F)] 'sql-forward-column)
  (define-key sql-interactive-mode-map [(control B)] 'sql-backward-column)
;  (define-key sql-interactive-mode-map "\M-b" 'scroll-right)
;  (define-key sql-interactive-mode-map "\M-f" 'scroll-left)
  (if sql-lucid
      (progn
	(define-key sql-interactive-mode-map [(control >)] 'sql-forward-column)
	(define-key sql-interactive-mode-map [(control <)] 'sql-backward-column)
	(define-key sql-interactive-mode-map [(control \.)] 'scroll-left)
	(define-key sql-interactive-mode-map [(control ,)] 'scroll-right))
    (define-key sql-interactive-mode-map (quote [4194364]) 'sql-backward-column)
    (define-key sql-interactive-mode-map (quote [4194366]) 'sql-forward-column)
    (define-key sql-interactive-mode-map (quote [4194348]) 'scroll-right)
    (define-key sql-interactive-mode-map (quote [4194350]) 'scroll-left))
  (define-key sql-interactive-mode-map "\C-L" 'sql-recenter)
  (define-key sql-interactive-mode-map [(shift right)] 'sql-forward-column)
  (define-key sql-interactive-mode-map [(shift left)] 'sql-backward-column)
  (define-key sql-interactive-mode-map [(shift button1)] 'sql-drag-display)
  (define-key sql-interactive-mode-map [(button3)] 'sql-popup-association-menu)
  (define-key sql-interactive-mode-map "\C-c\C-q" 'sql-exit-sql-mode)
  (define-key sql-interactive-mode-map "\C-ch" 'sql-help-command)
  (define-key sql-interactive-mode-map [(tab)] 'sql-complete-word-maybe))

(defvar sql-results-mode-map ()
  "Keymap used while in an sql-results-mode buffer.")
(if sql-results-mode-map
    ()
  (setq sql-results-mode-map (make-keymap))
  (and sql-lucid (set-keymap-name sql-results-mode-map 'sql-results-mode-map))
  (suppress-keymap sql-results-mode-map)
  (define-key sql-results-mode-map "\M-<" 'sql-beginning-of-buffer)
  (define-key sql-results-mode-map "\M->" 'sql-end-of-buffer)
  (define-key sql-results-mode-map "<" 'sql-backward-column)
  (define-key sql-results-mode-map "," 'scroll-right)
  (define-key sql-results-mode-map ">" 'sql-forward-column)
  (define-key sql-results-mode-map "." 'scroll-left)
  (define-key sql-results-mode-map " " 'sql-scroll-up)
  (define-key sql-results-mode-map "\C-v" 'sql-scroll-up)
  (define-key sql-results-mode-map "b" 'sql-scroll-down)
  (define-key sql-results-mode-map "\M-v" 'sql-scroll-down)
  (define-key sql-results-mode-map [(delete)] 'sql-scroll-down)
  (define-key sql-results-mode-map [(backspace)] 'sql-scroll-down)
  (define-key sql-results-mode-map "\n" 'sql-scroll-up-one-line)
  (define-key sql-results-mode-map "\r" 'sql-scroll-up-one-line)
  (define-key sql-results-mode-map "=" 'what-line)
  (define-key sql-results-mode-map "x" 'exchange-point-and-mark)
  (define-key sql-results-mode-map "s" 'sql-split-window-horizontally)
  (define-key sql-results-mode-map "d" 'sql-other-window-done)
  (define-key sql-results-mode-map "u" 'sql-edit-row)
  (define-key sql-results-mode-map "i" 'sql-iconify-frame)
  (define-key sql-results-mode-map "w" 'sql-grow-window-horizontally)
  (define-key sql-results-mode-map "n" 'shrink-window-horizontally)
;  (define-key sql-results-mode-map "r" 'isearch-backward)
  (define-key sql-results-mode-map "p" 'sql-pop-and-rename-buffer)
  (define-key sql-results-mode-map "h" 'sql-move-header-toggle)
;  (define-key sql-results-mode-map "f" 'sql-forward-column)
;  (define-key sql-results-mode-map "b" 'sql-backward-column)
  (define-key sql-results-mode-map "\C-ce" 'sql-edit-toggle)
  (define-key sql-results-mode-map "e" 'sql-edit-toggle)
;  (define-key sql-results-mode-map "\C-B" 'sql-backward-column)
  (define-key sql-results-mode-map [(control F)] 'sql-forward-column)
  (define-key sql-results-mode-map [(control B)] 'sql-backward-column)
  (define-key sql-results-mode-map "\C-b" 'scroll-right)
  (define-key sql-results-mode-map "\C-f" 'scroll-left)
  (define-key sql-results-mode-map "\C-a" 'sql-beginning-of-row)
  (define-key sql-results-mode-map "\C-e" 'sql-end-of-row)
  (define-key sql-results-mode-map "l" 'sql-recenter)
  (define-key sql-results-mode-map [(control L)] 'sql-reposition-windows)
  (define-key sql-results-mode-map "\C-l" 'sql-recenter)
  (define-key sql-results-mode-map "o" 'other-window)
  (define-key sql-results-mode-map [(right)] 'scroll-left)
  (define-key sql-results-mode-map [(left)] 'scroll-right)
  (define-key sql-results-mode-map [(shift right)] 'sql-forward-column)
  (define-key sql-results-mode-map [(shift left)] 'sql-backward-column)
  (define-key sql-results-mode-map [(up)] 'sql-scroll-down)
  (define-key sql-results-mode-map [(down)] 'sql-scroll-up)
  (define-key sql-results-mode-map [(shift up)] 'sql-scroll-down-one-line)
  (define-key sql-results-mode-map [(shift down)] 'sql-scroll-up-one-line)
  (define-key sql-results-mode-map [(shift button1)] 'sql-drag-display)
  (define-key sql-results-mode-map [(shift button2)] 'sql-yank-under-point)
  (define-key sql-results-mode-map [(control button2)] 'sql-magic-yank-under-point)
  (define-key sql-results-mode-map "\C-c\C-q" 'sql-exit-sql-mode)
  (define-key sql-results-mode-map "\C-ch" 'sql-help-command)
  (define-key sql-results-mode-map "\M-p" 'sql-previous-history)
  (define-key sql-results-mode-map "\M-n" 'sql-next-history)
  (define-key sql-results-mode-map "\M-m" 'sql-previous-matching-history)
  (define-key sql-results-mode-map "\M-P" 'sql-previous-global-history)
  (define-key sql-results-mode-map "\M-N" 'sql-next-global-history))

(defvar sql-results-edit-map ()
  "Keymap used while in an sql-results-mode buffer in edit mode.")
(if sql-results-edit-map
    ()
  (setq sql-results-edit-map (make-keymap))
  (and sql-lucid (set-keymap-name sql-results-edit-map 'sql-results-edit-map))
  (define-key sql-results-edit-map "\C-c\C-p" 'sql-pop-and-rename-buffer)
  (define-key sql-results-edit-map "\C-ce" 'sql-edit-toggle)
;  (define-key sql-results-edit-map "\C-ch" 'sql-insert-header)
  (define-key sql-results-edit-map "\M-b" 'scroll-right)
  (define-key sql-results-edit-map "\M-f" 'scroll-left)
  (define-key sql-results-edit-map "\C-a" 'sql-beginning-of-row)
  (define-key sql-results-edit-map "\C-e" 'sql-end-of-row)
;  (define-key sql-results-edit-map [(control l)] 'sql-recenter)
  (define-key sql-results-edit-map [(control L)] 'sql-reposition-windows)
  (define-key sql-results-edit-map "\C-l" 'sql-recenter)
  (define-key sql-results-edit-map [(control right)] 'scroll-left)
  (define-key sql-results-edit-map [(control left)] 'scroll-right)
  (define-key sql-results-edit-map [(shift right)] 'sql-forward-column)
  (define-key sql-results-edit-map [(shift left)] 'sql-backward-column)
  (define-key sql-results-edit-map [(shift button1)] 'sql-drag-display)
  (define-key sql-results-edit-map "\C-c\C-q" 'sql-exit-sql-mode)
  (define-key sql-results-edit-map "\C-c\C-e" 'sql-update-row)
  (define-key sql-results-edit-map "\M-i" 'sql-update-row)
  (define-key sql-results-edit-map "\C-ch" 'sql-help-command))

(defun sql-mode-version ()
  "Return string describing the version of SQL Mode.  When called interactively,
displays the version."
  (interactive)
  (if (interactive-p)
      (message "SQL Mode version %s" (sql-mode-version))
    sql-mode-version))

;;;###autoload
(defun sql-mode ()
  "Major mode for editing SQL code.
sql-mode Revision: 0.919.1 (beta)

To submit a bug report, enter `\\[sql-submit-bug-report]' from an
sql-mode, an sql-batch-mode, an sql-interactive-mode or an
sql-results-mode buffer.  This automatically sets up a mail buffer
with version information already added.  You just need to add a
description of the problem, including a reproducable test case
and send the message.  To send the message, enter `\\[mail-send-and-exit]'.

On entry to this mode, the hook variable `sql-mode-hook' is run with
no args, if that variable is bound and has a non-nil value.

Comments are delimited with /* ... */.

Key bindings:
\\{sql-mode-map}"
  (interactive)
  (setq major-mode 'sql-mode)
  (setq mode-name "SQL")
  (use-local-map sql-mode-map)
  (set-syntax-table sql-mode-syntax-table)
  (if sql-lucid
;      (if sql-use-big-menus
;	  (sql-turn-on-big-menus)
      (progn
	(set-buffer-menubar (copy-sequence current-menubar))
	(add-menu nil "SQL" (cdr sql-mode-menu) "Buffers"))
    (easy-menu-define sql-menu (list sql-mode-map) "SQL" sql-mode-menu))
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'sql-indent-line)
  (make-local-variable 'comment-start)
  (setq comment-start "/* ")
  (make-local-variable 'comment-end)
  (setq comment-end " */")
  (sql-font-lock)
  (and sql-abbrev-mode
       (progn
	 (sql-load-abbrevs)
	 (abbrev-mode 1)))
;  (and sql-use-toolbar (sql-turn-on-toolbar))
  (message nil)
  (run-hooks 'sql-mode-hook))

(defun sql-batch-mode (&optional server-name user-name user-password
				 the-database no-create)
  "Major mode for editing batch SQL commands.
sql-batch-mode Revision: 0.919.1 (beta)

To submit a bug report, enter `\\[sql-submit-bug-report]' from an
sql-mode, an sql-batch-mode, an sql-interactive-mode or an
sql-results-mode buffer.  This automatically sets up a mail buffer
with version information already added.  You just need to add a
description of the problem, including a reproducable test case
and send the message.  To send the message, enter `\\[mail-send-and-exit]'.

On entry to this mode, the hook variable `sql-batch-mode-hook' is run with
no args, if that variable is bound and has a non-nil value.

To evaluate the current buffer, use `\\[sql-evaluate-buffer]'

Comments are delimited with /* ... */.

Key bindings:
\\{sql-batch-mode-map}"
  (interactive)
  (setq server-name (or server-name
			(completing-read "Server Name: " sql-server-table)))
  (setq user-name (or user-name
		      (completing-read (format "User Name on Server %s: " 
					       server-name)
				       sql-user-table)))
  (setq new-password (or user-password 
			 (let ((prompt (format "Password for %s on %s: "
					       user-name server-name)))
			   (if sql-secure-passwords
			       (sql-read-password prompt)
			     (read-string prompt)))))
  (if no-create
      (progn
	(setq sql-old-contents (buffer-substring (point-min) (point-max)))
	(setq sql-old-history sql-history)
	(setq sql-matching-buffer nil)
	(kill-buffer nil)))
  (setq sql-buf (get-buffer-create (concat "+" server-name "+" user-name "+"
					   (if the-database
					       (concat the-database "+")
					     ""))))
  (set-buffer sql-buf)
  (setq major-mode 'sql-batch-mode)
  (setq mode-name "SQL Batch")
  (switch-to-buffer sql-buf)
  (if no-create
      (progn
	(insert sql-old-contents)
	(setq sql-history sql-old-history)))
  (make-variable-buffer-local 'server)
  (make-variable-buffer-local 'user)
  (make-variable-buffer-local 'password)
  (make-variable-buffer-local 'database)
  (make-variable-buffer-local 'database-name)
  (make-variable-buffer-local 'sql-history)
  (make-variable-buffer-local 'sql-history-index)
  (make-variable-buffer-local 'sql-matching-buffer)
  (make-variable-buffer-local 'sql-startup-message-displayed)
  (make-variable-buffer-local 'sql-table-list)
  (make-variable-buffer-local 'sql-database-list)
  (make-variable-buffer-local 'sql-column-list)
  (make-variable-buffer-local 'sql-stored-procedure-list)
  (make-variable-buffer-local 'screen-icon-title-format)
  (use-local-map sql-batch-mode-map)
  (setq server server-name)
  (setq user user-name)
  (setq password new-password)
  (and the-database
       (sql-set-database the-database))
  (setq screen-icon-title-format server)
  (set-syntax-table sql-mode-syntax-table)
  (if sql-lucid
      (if sql-use-big-menus
	  (sql-turn-on-big-menus)
	(set-buffer-menubar (copy-sequence current-menubar))
	(add-menu nil "SQL" (cdr sql-batch-mode-menu) nil))
    (easy-menu-define sql-batch-menu (list sql-batch-mode-map) "SQL"
		      sql-batch-mode-menu))
  (sql-font-lock)
  (if sql-abbrev-mode
      (progn
	(sql-load-abbrevs)
	(abbrev-mode 1)))
  (setq mode-line-format sql-mode-line-format)
  (message nil)
  (if (bufferp sql-matching-buffer)
      (progn
	(sql-create-results-buffer sql-matching-buffer)
	(other-window 1))
    (delete-other-windows))
  (and sql-use-toolbar (sql-turn-on-toolbar))
  (run-hooks 'sql-batch-mode-hook)
  (if (not sql-inhibit-startup-message)
      (progn
	(sql-display-startup-message)
	(if (not (input-pending-p))
	    (message nil)))))

(defun sql-interactive-mode (&optional server-name user-name user-password
				       no-create)
  "Major mode for interacting with SQL servers.
sql-interactive-mode Revision: 0.919.1 (beta)

To submit a bug report, enter `\\[sql-submit-bug-report]' from an
sql-mode, an sql-batch-mode, an sql-interactive-mode or an
sql-results-mode buffer.  This automatically sets up a mail buffer
with version information already added.  You just need to add a
description of the problem, including a reproducable test case
and send the message.  To send the message, enter `\\[mail-send-and-exit]'.

On entry to this mode, the hook variable `sql-interactive-mode-hook' is
run with no args, if that variable is bound and has a non-nil value.

To evaluate the current command, type `go' followed by RETURN.

Comments are delimited with /* ... */.

Key bindings:
\\{sql-interactive-mode-map}"
  (interactive)
  (setq server-name (or server-name
			(completing-read "Server Name: " sql-server-table)))
  (setq user-name (or user-name
			(completing-read (format "User Name on Server %s: " 
						 server-name)
					 sql-user-table)))
  (setq new-password (or user-password 
			 (let ((prompt (format "Password for %s on %s: "
					       user-name server-name)))
			   (if sql-secure-passwords
			       (sql-read-password prompt)
			     (read-string prompt)))))
  
;Usage: SQLPLUS [<option>] [<user>[/<password>] [@<host>]]
;	        [@<startfile> [<parm1>] [<parm2>] ...]
;where <option> ::= { -s | -? }
;-s for silent mode and -? to obtain version number

  (let ((new-buffer nil)
	(new-buffer-name (concat server-name "-" user-name)))
    (cond
     ((eq sql-database-type 'sybase)
      (if sql-interactive-command-switches
	  (setq new-buffer
		(make-comint new-buffer-name
			     sql-command nil
			     (concat "-w" (int-to-string sql-max-screen-width))
			     (concat "-U" user-name) 
			     (concat "-P" new-password)
			     (concat "-S" server-name)
			     sql-interactive-command-switches))
	(setq new-buffer
	      (make-comint new-buffer-name
			   sql-command nil
			   (concat "-w" (int-to-string sql-max-screen-width))
			   (concat "-U" user-name) 
			   (concat "-P" new-password)
			   (concat "-S" server-name)))))
     ((eq sql-database-type 'oracle)
      (if sql-interactive-command-switches
	  (setq new-buffer
		(make-comint new-buffer-name
			     sql-command nil
			     (concat user-name "/" new-password)
			     (concat "@" server-name)
			     sql-interactive-command-switches))
	(setq new-buffer
	      (make-comint new-buffer-name
			   sql-command nil
			   (concat user-name "/" new-password)
			   (concat "@" server-name)))))
     (t
      (error "Unrecognized database type `%s'." sql-database-type)))
    (switch-to-buffer new-buffer))
  (kill-all-local-variables)
  (make-variable-buffer-local 'server)
  (make-variable-buffer-local 'user)
  (make-variable-buffer-local 'password)
  (make-variable-buffer-local 'database)
  (make-variable-buffer-local 'database-name)
  (make-variable-buffer-local 'sql-history)
  (make-variable-buffer-local 'sql-history-index)
  (make-variable-buffer-local 'sql-command-level)
  (make-variable-buffer-local 'next-line-add-newlines)
  (make-variable-buffer-local 'screen-icon-title-format)
  (comint-mode)
  (use-local-map sql-interactive-mode-map)
  (setq comint-prompt-regexp "^.*> ")  
  (set-syntax-table sql-mode-syntax-table)
  (if sql-lucid
      (if sql-use-big-menus
	  (sql-turn-on-big-menus)
	(set-buffer-menubar (copy-sequence current-menubar))
	(add-menu nil "SQL" (cdr sql-interactive-mode-menu) nil))
    (easy-menu-define sql-interactive-menu (list sql-interactive-mode-map) "SQL"
		      sql-interactive-mode-menu))
  (setq major-mode 'sql-interactive-mode)
  (setq mode-name "SQL Interaction")
  (setq next-line-add-newlines nil)
  (make-variable-buffer-local 'isearch-mode-hook)
  (make-variable-buffer-local 'isearch-mode-end-hook)
  (add-hook 'isearch-mode-hook 'sql-isearch-begin)
  (add-hook 'isearch-mode-end-hook 'sql-isearch-end)
  (sql-font-lock)
  (if sql-abbrev-mode
      (progn
	(sql-load-abbrevs)
	(abbrev-mode 1)))
  (setq truncate-lines t)
  (setq server server-name)
  (setq user user-name)
  (setq password new-password)
  (setq mode-line-format sql-mode-line-format)
  (setq screen-icon-title-format server)
;  (and sql-use-toolbar (sql-turn-on-toolbar))
  (message nil)
  (run-hooks 'sql-interactive-mode-hook)
  (if (not sql-inhibit-startup-message)
      (progn
	(sql-display-startup-message)
	(if (not (input-pending-p))
	    (message nil)))))

(defun sql-results-mode (&optional the-server the-user)
  "Major mode for viewing SQL results.
sql-results-mode Revision: 0.919.1 (beta)

sql-results-mode is similar to view mode.  The following commands are
available to browse the results buffer.  If you want to do editing in the
results buffer, you should enter the sql-results-edit mode (see below).

If your query returns more than one batch of results, you will probably
want to turn off the header shifting.  You can accomplish this with the
`h' key.

A command summary of the keybindings that are available are as follows:

	Key Binding		Action

	SPACE			Scroll down one screenfull
	DOWN ARROW		Scroll down one screenfull
	b 			Scroll up one screenfull
	BACKSPACE		Scroll up one screenfull
	DELETE			Scroll up one screenfull
	UP ARROW		Scroll up one screenfull
	,			Scroll left one screenfull
	<			Scroll left one screenfull
	LEFT ARROW		Scroll left one screenfull
	.			Scroll right one screenfull
	>			Scroll right one screenfull
	RIGHT ARROW		Scroll right one screenfull
	RETURN			Scroll down one line
	LINEFEED		Scroll down one line
	SHIFT DOWN ARROW	Scroll down one line
	SHIFT UP ARROW		Scroll up one line
	SHIFT LEFT ARROW	Scroll left one column
	SHIFT RIGHT		Scroll right one column
	g			Goto line
	=			Display current line
	x			Exchange point and mark
	s			Forward incramental search
	r			Reverse incramental search
	p			Pop and rename buffer
	h			Toggle the shifting of headers
	e			Edit mode
	C-c e			Edit mode
	C-a			Beginning of row
	C-e			End of row
	l			Recenter
	o			Other window

	SHIFT button1		Drag display

	For backwards compatibility:

	C-v			Scroll down one screenfull
	M-v			Scroll up one screenfull
	C-b			Scroll left one screenfull
	C-f			Scroll right one screenfull
	C-L			Recenter
	
To submit a bug report, enter `\\[sql-submit-bug-report]' from an
sql-mode, an sql-batch-mode, an sql-interactive-mode or an
sql-results-mode buffer.  This automatically sets up a mail buffer
with version information already added.  You just need to add a
description of the problem, including a reproducable test case
and send the message.  To send the message, enter `\\[mail-send-and-exit]'.

On entry to this mode, the hook variable `sql-results-mode-hook' is run with
no args, if that variable is bound and has a non-nil value.

Key bindings:
\\{sql-results-mode-map}

Whie in EDIT mode:
\\{sql-results-edit-map}"
  (interactive)
  (setq major-mode 'sql-results-mode)
  (setq mode-name "SQL Results")
  (setq truncate-lines t)
  (make-variable-buffer-local 'isearch-mode-hook)
  (make-variable-buffer-local 'isearch-mode-end-hook)
  (add-hook 'isearch-mode-hook 'sql-isearch-begin)
  (add-hook 'isearch-mode-end-hook 'sql-isearch-end)
  (make-variable-buffer-local 'sql-history)
  (make-variable-buffer-local 'sql-history-index)
  (make-variable-buffer-local 'sql-matching-buffer)
  (make-variable-buffer-local 'sql-one-query)
  (make-variable-buffer-local 'sql-header-text)
  (make-variable-buffer-local 'sql-current-error-point)
  (if (and the-server the-user)
      (progn
	(make-variable-buffer-local 'server)
	(make-variable-buffer-local 'user)
	(setq server the-server)
	(setq user the-user)))
  (make-variable-buffer-local 'screen-icon-title-format)
  (make-variable-buffer-local 'sql-results-view-mode)
  (make-variable-buffer-local 'sql-results-edit-mode)
  (make-variable-buffer-local 'sql-results-mode-editing)
  (make-variable-buffer-local 'sql-linked-windows)
  (setq screen-icon-title-format server)
  (sql-results-view-mode)
  (use-local-map sql-results-mode-map)
  (set-syntax-table sql-mode-syntax-table)
  (if sql-lucid
      (progn
	(set-buffer-menubar (copy-sequence current-menubar))
	(add-menu nil "SQL" (cdr sql-results-mode-menu) nil))
    (easy-menu-define sql-results-menu (list sql-results-mode-map) "SQL"
		      sql-results-mode-menu))
  (and (> emacs-minor-version 11) sql-use-toolbar (sql-turn-on-toolbar))
  (setq mode-line-format sql-mode-line-format)
  (message nil)
  (run-hooks 'sql-results-mode-hook))

;(defun sql-insert-database-code (the-database)
;  (if the-database
;      (save-excursion
;	(goto-char (point-min))
;	(insert "use " the-database "\ngo\n"))))

;(defun sql-insert-final-go-code ()
;  (save-excursion
;    (goto-char (point-max))
;    (insert "\ngo\n")))

;(defun sql-evalueate-buffer ()
;  "Send the contents of buffer to an SQL process."
;  (interactive)
;  (sql-evaluate-region (point-min) (point-max)))

;(defun sql-evaluate-region (beginning end)
;  "Send the contents of buffer between BEGINNING and END to a SQL process."
;  (interactive "r")
;  (save-excursion
;    (let ((the-current-buffer (current-buffer))
;	  (the-matching-buffer sql-matching-buffer)
;	  (the-server server)
;	  (the-database database)
;	  (the-user user)
;	  (the-password password))
;      (copy-to-buffer sql-send-buffer beginning end)
;      (set-buffer sql-send-buffer)
;      (sql-check-for-where)
;;      (sql-check-rows-affected)
;      (if the-database
;	  (message (concat "Getting rows from " the-database " on "
;			   the-server "..."))
;	(message (concat "Getting rows from " the-server "...")))
;      (sql-insert-database-code the-database)
;      (sql-insert-final-go-code)
;      (if sql-batch-command-switches
;	  (call-process-region beginning end sql-command nil
;			       the-matching-buffer t 
;			       (concat "-w" sql-max-screen-width) 
;			       (concat "-U" the-user)
;			       (concat "-P" the-password) 
;			       (concat "-S" the-server)
;			       sql-batch-command-switches)
;	(call-process-region beginning end sql-command nil
;			     the-matching-buffer t
;			     (concat "-w" sql-max-screen-width)
;			     (concat "-U" the-user)
;			     (concat "-P" the-password) 
;			     (concat "-S" the-server)))
;      (if sql-results-in-new-screen
;	  (sql-put-results-in-new-screen)
;	(sql-create-results-buffer the-matching-buffer))
;      (set-buffer the-matching-buffer)
;      (sql-results-mode the-server the-user)
;      (if the-database
;	  (message (concat "Getting rows from " the-database " on "
;			   the-server "... done"))
;	(message (concat "Getting rows from " the-server "... done"))))))

(defun sql-results-view-mode ()
  "Minor mode to view results."
  (interactive)
  (use-local-map sql-results-mode-map)
  (setq sql-results-mode-editing nil)
  (setq sql-results-view-mode t)
  (setq sql-results-edit-mode nil)
  (overwrite-mode 0)
  (force-mode-line-update))
;  (message "Results VIEW mode."))

(defun sql-results-edit-mode ()
  "Minor mode to edit results."
  (interactive)
  (use-local-map sql-results-edit-map)
  (setq sql-results-mode-editing t)
  (setq sql-results-view-mode nil)
  (setq sql-results-edit-mode t)
  (overwrite-mode 1)
  (force-mode-line-update))
;  (message "Results EDIT mode."))

(defun sql-edit-toggle ()
  "Toggle the state of editing in the current results buffer."
  (interactive)
  (if sql-results-mode-editing
      (sql-results-view-mode)
    (sql-results-edit-mode)))

(defun sql-other-window-done ()
  "Switch to the other window and clear the results and batch buffers."
  (interactive)
  (other-window 1)
  (sql-goto-history 0))
				     
(defun sql-evaluate-buffer-asyncronous (flag &optional silent)
  "Send the contents of the buffer asyncronously to an SQL process.
With prefix ARG, send the contents of the region in the current buffer
to an SQL process.

On entry to this function, the hook variable `sql-evaluate-buffer-hook'
is run with no args, if that variable is bound and has a non-nil value."
  (interactive "P")
  (setq sql-old-point (point))
  (setq sql-screen (selected-screen))
  (if (not silent)
      (progn
	(sql-check-for-where)
	(if sql-confirm-changes
	    (if (sql-get-rows-affected flag)
		nil
	      (error "Aborted.")))))
  (if database
      (message "Getting rows from %s on %s..." database server)
    (message "Getting rows from %s..." server))
  (or silent
      (sql-add-buffer-to-history t))
  (and database
       (save-excursion
	 (goto-char (point-min))
	 (insert "use " database "\ngo\n")))
  (and sql-require-final-go
       (save-excursion
	 (goto-char (point-max))
	 (insert "\ngo\n")))
  (setq batch-buffer (current-buffer))
  (setq buffer (get-buffer-create (concat "+" server "-" user " results+")))
  (setq sql-matching-buffer buffer)
  (let ((the-server server)
	(the-user user))
    (set-buffer buffer)
    (setq sql-matching-buffer batch-buffer)
    (sql-results-mode the-server the-user)
    (sql-stop-marking-changes)
    (erase-buffer))
  (set-buffer batch-buffer)
  (run-hooks 'sql-before-evaluate-buffer-hook)
  (let* ((start (if flag (point) (point-min)))
	 (end (if flag (mark) (point-max)))
;	 (switches (concat sql-batch-command-switches
;			   (if sql-intersperse-headers
;			       (concat "-h "
;				       (- (screen-height)
;					  (sql-calculate-results-buffer-height)
;					  next-screen-context-lines
;					  5))
;			     "")))
	 (command (concat sql-command " "
			  " -w" (int-to-string sql-max-screen-width)
			  " -U" user
			  " -P" password
			  " -S" server
			  " < " "/tmp/SQL_MODE_TEMP_FILE")))
    (write-region start end "/tmp/SQL_MODE_TEMP_FILE" nil 1)
    (set-buffer batch-buffer)
    (setq sql-process (start-process-shell-command (downcase mode-name)
						   sql-matching-buffer
						   command))
    (set-process-sentinel sql-process 'sql-sentinel)
;    (set-process-filter sql-process 'sql-filter)
    (set-marker (process-mark sql-process) (point) sql-matching-buffer)
    (setq sql-query-in-progress (cons sql-process sql-query-in-progress))))

(defun sql-filter (proc string)
  "Process filter for results buffers.
Just inserts the text, but uses `insert-before-markers'."
  (save-excursion
    (set-buffer (process-buffer proc))
    (let ((buffer-read-only nil))
      (save-excursion
	(goto-char (process-mark proc))
	(insert-before-markers string)
	(set-marker (process-mark proc) (point))))))

(defun sql-sentinel (proc msg)
  "Sentinel for results buffers."
  (let ((buffer (process-buffer proc))
	(old-screen (selected-screen)))
    (if (memq (process-status proc) '(signal exit))
	(progn
	  (if (null (buffer-name buffer))
	      ;; buffer killed
	      (set-process-buffer proc nil)
	    (let ((obuf (current-buffer))
		  omax opoint)
	      ;; save-excursion isn't the right thing if
	      ;; process-buffer is current-buffer
	      (unwind-protect
		  (progn
		    ;; Write something in the results buffer
		    ;; and hack its mode line.
		    (set-buffer buffer)
;		    (let ((buffer-read-only nil))
;		      (setq omax (point-max)
;			    opoint (point))
;		      (goto-char omax)
		      ;; Record where we put the message, so we can ignore it
		      ;; later on.
;		      (insert ?\n mode-name " " msg)
;		      (forward-char -1)
;		      (insert " at " (substring (current-time-string) 0 19))
;		      (forward-char 1)
;		      (setq mode-line-process
;			    (concat ":"
;				    (symbol-name (process-status proc))))
		      ;; Since the buffer and mode line will show that the
		      ;; process is dead, we can delete it now.  Otherwise it
		      ;; will stay around until M-x list-processes.
;		      (delete-process proc)
		      ;; Force mode line redisplay soon.
;		      (set-buffer-modified-p (buffer-modified-p)))
 ;		    (if (and opoint (< opoint omax))
 ;			(goto-char opoint))
		    (goto-char (point-min))
		    (sql-goto-batch-buffer)
 ;		    (and sql-reposition-windows-when-done
 ;			 (sql-reposition-windows))
		    (sql-finish-evaluating-buffer nil)
		    (and (member 'ding sql-finished-query-options)
			 (play-sound 'sql-ready))
		    (and (member 'open sql-finished-query-options)
			 (deiconify-screen sql-screen))
		    (and (member 'raise sql-finished-query-options)
			 (raise-screen sql-screen)))
		(set-buffer obuf))))
	  (setq sql-query-in-progress (delq proc sql-query-in-progress))
	  ))
    (select-screen old-screen)))

;(defun sql-sentinel (proc msg)
;  (set-buffer (process-buffer proc))
;  (sql-goto-batch-buffer)
;  (sql-finish-evaluating-buffer nil)
;  (message msg))

(defun sql-evaluate-region ()
  "Send the contents of the current region to an SQL process.
This function simply invokes sql-evaluate-buffer with an argument to
specify a region instead of the whole buffer."
  (sql-evaluate-buffer t))

(defun sql-evaluate (string a-server a-user a-password a-switches output-buffer)
  "Evaluate STRING on SQL Server SERVER using login USER and PASSWORD.
If SWITCHES is non-nil, it is passed as a command-line argument to sql-command.
Output from the evaluation is put in OUTPUT-BUFFER."
  (let ((temp-buffer (get-buffer-create " SQL-TEMP")))
    (set-buffer temp-buffer)
    (erase-buffer)
    (insert string)
    (if a-switches
	(call-process-region (point-min) (point-max) sql-command nil
		      output-buffer t 
		      (concat "-w" (int-to-string sql-max-screen-width))
		      (concat "-U" a-user) (concat "-P" a-password) 
		      (concat "-S" a-server)
		      a-switches)
      (call-process-region (point-min) (point-max) sql-command nil
		    output-buffer t 
		    (concat "-w" (int-to-string sql-max-screen-width))
		    (concat "-U" a-user) (concat "-P" a-password) 
		    (concat "-S" a-server)))
;    (kill-buffer temp-buffer)
  ))

(defun sql-evaluate-buffer (flag &optional silent)
  "Send the contents of the buffer to an SQL process.
With prefix ARG, send the contents of the region in the current buffer
to an SQL process.

On entry to this function, the hook variable `sql-evaluate-buffer-hook'
is run with no args, if that variable is bound and has a non-nil value."
  (interactive "P")
  (setq sql-old-point (point))
  (setq sql-screen (selected-screen))
  (if (not silent)
      (progn
	(sql-check-for-where)
	(if sql-confirm-changes
	    (if (sql-get-rows-affected flag)
		nil
	      (error "Aborted.")))))
  (if database
      (message "Getting rows from %s on %s..." database server)
    (message "Getting rows from %s..." server))
  (or silent (sql-add-buffer-to-history t))
  (setq batch-buffer (current-buffer))
  (setq buffer (get-buffer-create (concat "+" server "-" user " results+")))
  (setq sql-matching-buffer buffer)
  (let ((the-server server)
	(the-user user))
    (set-buffer buffer)
    (setq sql-matching-buffer batch-buffer)
    (sql-results-mode the-server the-user)
    (sql-stop-marking-changes)
    (erase-buffer))
  (set-buffer batch-buffer)
  (run-hooks 'sql-before-evaluate-buffer-hook)
  (let* ((start (if flag (point) (point-min)))
	 (end (if flag (mark) (point-max)))
	 (switches (if (or sql-batch-command-switches sql-intersperse-headers)
		       (concat
			sql-batch-command-switches
			(if sql-intersperse-headers
			    (concat "-h "
				    (- (screen-height)
				       (sql-calculate-results-buffer-height)
				       next-screen-context-lines
				       5))
			  ""))))
	 (command (buffer-substring start end)))
    (and database
	 (setq command (concat "use " database "\ngo\n" command)))
    (and sql-require-final-go
	 (setq command (concat command "\ngo\n")))
    (sql-evaluate command server user password switches buffer))
  (sql-finish-evaluating-buffer silent))

(defun sql-finish-evaluating-buffer (silent)
  (goto-char sql-old-point)
  (if sql-results-in-new-screen
      (sql-put-results-in-new-screen)
    (sql-create-results-buffer buffer))
  (set-buffer buffer)
  (setq sql-linked-windows (selected-window))
  (setq sql-matching-buffer batch-buffer)
;  (setq sql-history sql-old-history)
;  (setq sql-history-index sql-old-history-index)
  (if (not silent)
      (progn
	(setq sql-current-error-point nil)
	(sql-add-buffer-to-history nil)))
  (goto-char (point-min))
  (if (sql-multi-headers)
      (setq sql-move-headers nil)
    (setq sql-move-headers t)
    (setq sql-header-text (buffer-substring (point-min)
					    (progn
					      (forward-line 2) (point)))))
  (if (member 'rows sql-finished-query-options)
      (message (sql-get-status))
    (if database
	(message "Getting rows from %s on %s... done" database server)
      (message "Getting rows from %s... done" server )))
  (save-excursion
    (goto-char (point-max))
    (insert "\n\n"))
  (and sql-mark-changes
      (sql-start-marking-changes))
  (sql-font-lock)
  (and sql-stay-in-batch-buffer
       (not silent)
       (progn
	 (sql-goto-batch-buffer)
	 (goto-char sql-old-point)))
  (goto-char (point-min))
  (run-hooks 'sql-evaluate-buffer-hook))

(defun sql-toggle-font-lock ()
  "Toggle the state of font-lock-mode in the current buffer."
  (interactive)
  (if font-lock-mode
      (sql-turn-off-font-lock)
    (sql-turn-on-font-lock)))

(defun sql-font-lock ()
  (if (or (eq sql-font-lock-buffers 'all)
	  (member major-mode sql-font-lock-buffers))
      (sql-turn-on-font-lock)
    (sql-turn-off-font-lock)))

(defun sql-turn-on-font-lock ()
  (font-lock-mode 1)  
  (if (eq major-mode 'sql-results-mode)
      (and sql-xemacs
	   (let ((re (make-extent (point-min) (point-max))))
	     (set-extent-face re 'sql-results-face)))))

(defun sql-turn-off-font-lock ()
  (font-lock-mode 0)
  (and (eq major-mode 'sql-results-mode)
       sql-xemacs
       (extent-at (point-min))
       (delete-extent (extent-at (point-min)))))

(defun sql-multi-headers ()
  "Return t if it looks like there is not exactly one line of headers."
  (save-excursion
    (goto-char (point-min))
    (forward-line 1)
    (if (looking-at " ---")
	(progn
	  (forward-line 1)
	  (search-forward "---" nil t))
      t)))
   
(defun sql-calculate-results-buffer-height ()
  "Calculate the number of lines to allocate for the results buffer."
  (let* ((percent (/ (* (screen-height) sql-results-buffer-percent) 100))
	 (lines (- (screen-height) percent)))
    (if sql-greedy-results-buffers
	(setq lines (max window-min-height
			 (min lines 
			      (+ 2 (count-lines (point-min) (point-max)))))))
    lines))

(defun sql-create-results-buffer (buffer)
  "Place and resize the results buffer BUFFER.
The values of sql-results-buffer-percent and sql-greedy-results-buffers
are consulted."
  (let ((old-screen (selected-screen)))
    (select-screen sql-screen)
    (delete-other-windows)
					;  (goto-char (point-min))
    (split-window nil (sql-calculate-results-buffer-height))
					;  (other-window 1)
    (switch-to-buffer-other-window buffer)
    (select-screen old-screen)))

(defun sql-mark-changed (begin end l)
  (interactive)
  (and sql-lucid
       (let* ((line-start (save-excursion (beginning-of-line) (point)))
	      (line-end (save-excursion (end-of-line) (point)))
	      (line-extent (make-extent line-start line-end))
	      (area-extent (make-extent begin end)))
	 (set-extent-face line-extent 'sql-changed-line-face)
	 (set-extent-face area-extent 'sql-changed-area-face))))

(defun sql-start-marking-changes ()
  "Start marking changed areas with highlight."
  (interactive)
  (setq sql-marking-changes t)
  (make-local-variable 'old-after-change-function)
  (make-local-variable 'after-change-function)
  (setq old-after-change-function after-change-function)
  ;; there must be a better way
  (if old-after-change-function
      (setq after-change-function 
	    (list 'lambda '(a b c)
		  '(sql-mark-changed a b c)
		  (if old-after-change-function 
		      (list old-after-change-function 'a 'b 'c))))
    (setq after-change-function 'sql-mark-changed)))

(defun sql-stop-marking-changes ()
  "Stop marking changed areas with highlight.
See help on the variable `sql-mark-changes'."
  (interactive)
  (setq sql-marking-changes nil)
  (if (boundp 'old-after-change-function)
      (setq after-change-function old-after-change-function)))

(defun sql-toggle-marking-changes ()
  "Start or stop marking changes."
  (interactive)
  (if sql-marking-changes
      (sql-stop-marking-changes)
    (sql-start-marking-changes)))

(defun sql-toggle-big-menus ()
  "Expand or contract menus depending on current state."
  (interactive)
  (if sql-use-big-menus
      (sql-turn-off-big-menus)
    (sql-turn-on-big-menus)))

(defun sql-turn-off-big-menus ()
  (setq sql-use-big-menus nil)
  (set-buffer-menubar sql-old-menu)
  (sql-add-menus)
  (add-menu nil "SQL" (cond
		       ((eq major-mode 'sql-mode)
			(cdr sql-mode-menu))
		       ((eq major-mode 'sql-batch-mode)
			(cdr sql-batch-mode-menu))
		       ((eq major-mode 'sql-results-mode)
			(cdr sql-results-mode-menu))
		       ((eq major-mode 'sql-interactive-mode)
			(cdr sql-interactive-mode-menu))
		       (t
			(error "You must be in a SQL Mode buffer.")))
	    nil)
  (add-menu '("SQL" "Options") (car (car sql-font-lock-menu))
	    (cdr (car sql-font-lock-menu))
	    "SYBASE Environment Variable...")
  (set-menubar-dirty-flag))

(defun sql-turn-on-big-menus ()
  (setq sql-use-big-menus t)
  (set-buffer-menubar sql-big-menu)
  (delete-menu-item '("Options" "Coloring"))
  (set-menubar-dirty-flag))

(defun sql-print-buffer-tiled ()
  "Format and print the current buffer, splitting pages as necessary."
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (insert "\n")
    (let ((done nil)
	  (buffer1 (get-buffer-create " SQL-PRINTER-OUTPUT-1"))
	  (text nil)
	  (contents (buffer-substring (point-min) (point-max)))
	  (end nil)
	  (chars (point-max)))
      (set-buffer buffer1)
      (insert contents)
      (while (not done)
	(goto-char (point-min))
	(if (not (re-search-forward "[a-zA-Z0-9]" nil t))
	    (setq done t)
	  (goto-char (point-max))
	  (let ((width sql-print-characters-per-line))
	    (while (> width 0)
	      (setq width (1- width))
	      (insert " ")))
	  (setq end (point))
	  (setq text (delete-extract-rectangle 1 end))
	  (set-buffer (get-buffer-create "SQL-PRINTER-OUTPUT"))
	  (while text
	    (insert (car text))
	    (insert "\n")
	    (setq text (cdr text)))
	  (let ((lpr-switches (or sql-print-switches lpr-switches))
		(enscript-switches (or sql-print-switches enscript-switches)))
	    (if (eq sql-print-command 'enscript-buffer)
		(enscript-buffer nil)
	      (funcall sql-print-command)))
	  (kill-buffer "SQL-PRINTER-OUTPUT")
	  (set-buffer buffer1)
	  (message "Spooling... (%3d%%)"
		   (/ (* 100 (- chars (point-max))) chars))))
      (kill-buffer buffer1)
      (message "Spooling... done"))))

;      (erase-buffer)
;      (let ((marking-changes sql-marking-changes))
;	(sql-stop-marking-changes)
;	(insert contents)
;	(if marking-changes
;	    (sql-start-marking-changes))))))

(defun sql-get-status ()
  "Get the status returned in a results buffer, if it is returned."
  (goto-char (point-max))
  (if (eq 0 (forward-line -1))
      (let ((msg (buffer-substring (point) (1- (point-max)))))
	(goto-char (point-min))
	msg)
    "No status returned."))

(defun sql-put-results-in-new-screen ()
  "Put the resulst buffer in it's own X screen."
  (make-screen)
  (switch-to-buffer buffer)
  (if sql-resize-results-screens
      (progn
	(set-screen-height (buffer-dedicated-screen)
			   sql-results-screen-height)
	(set-screen-width (buffer-dedicated-screen)
			  sql-results-screen-width))))

(defun sql-add-buffer-to-history (global)
  "Add the contents of the current buffer to the history list.
If GLOBAL is non-nil, add it to the global history as well."
  (if (equal (length sql-history) sql-history-length)
      (setq sql-history (reverse (cdr (reverse sql-history)))))
  (if (equal (length sql-global-history) sql-global-history-length)
      (setq sql-global-history (reverse (cdr (reverse sql-global-history)))))
  (let ((new-command (buffer-substring (point-min) (point-max))))
    (setq sql-history (cons new-command sql-history))
    (setq sql-end-history "")
    (setq sql-history-index 1)
    (if (and global
	     (not (string-equal new-command (car sql-global-history))))
	(setq sql-global-history (cons new-command sql-global-history)))
    (setq sql-global-history-index 0)))

(defun sql-previous-global-history ()
  "Copy the previous global history element into the current buffer."
  (interactive)
  (sql-goto-batch-buffer)
  (if (equal sql-global-history-index (length sql-global-history))
      (error "You have reached the beginning of the global history list."))
  (setq sql-global-history-index (1+ sql-global-history-index))
  (erase-buffer)
  (insert (nth (1- sql-global-history-index) sql-global-history))
  (if (and (bufferp sql-matching-buffer) (buffer-name sql-matching-buffer))
      (progn
	(set-buffer sql-matching-buffer)
	(erase-buffer)
	(set-buffer sql-matching-buffer)))
  (message "Global history element: %d (unlinked)" sql-global-history-index))

(defun sql-next-global-history ()
  "Copy the next global history element into the current buffer."
  (interactive)
  (sql-goto-batch-buffer)
  (if (equal sql-global-history-index 0)
      (error "You have reached the end of the global history list."))
  (setq sql-global-history-index (1- sql-global-history-index))
  (erase-buffer)
  (if (equal sql-global-history-index 0)
      ()
    (insert (nth (1- sql-global-history-index) sql-global-history)))
  (if (and (bufferp sql-matching-buffer) (buffer-name sql-matching-buffer))
      (progn
	(set-buffer sql-matching-buffer)
	(erase-buffer)
	(set-buffer sql-matching-buffer)))
  (message "Global history element: %d (unlinked)" sql-global-history-index))

(defun sql-previous-matching-history (pattern)
  "Copy the previous history element matching regexp PATTERN into the buffer."
  (interactive "sGoto history matching: ")
  (sql-goto-batch-buffer)
  (let ((history-part (nthcdr sql-history-index sql-history))
	(index 1)
	(found nil))
    (while (and history-part (not found))
      (if (string-match pattern (car history-part))
	  (setq found t)
	(setq history-part (cdr history-part))
	(setq index (1+ index))))
    (if found
	(sql-goto-history (+ index sql-history-index))
      (error "History matching '%s' not found." pattern))))

(defun sql-previous-history ()
  "Copy the previous history element into the current buffer."
  (interactive)
  (sql-goto-batch-buffer)
  (setq linked "(unlinked)")
  (if (equal sql-history-index 0)
      (setq sql-end-history (buffer-substring (point-min) (point-max))))
  (if (equal sql-history-index (length sql-history))
      (error "You have reached the beginning of the history list."))
  (setq sql-history-index (1+ sql-history-index))
  (erase-buffer)
  (insert (nth (1- sql-history-index) sql-history))
  (if (and (bufferp sql-matching-buffer) (buffer-name sql-matching-buffer))
      (let ((this-history-length (length sql-history))
	    (this-current-history sql-history-index))
	(set-buffer sql-matching-buffer)
	(if (and (equal (length sql-history) this-history-length)
		 (equal sql-history-index (1- this-current-history)))
	    (progn
	      (setq linked "(linked)")
	      (and sql-mark-changes (sql-stop-marking-changes))
	      (setq sql-history-index (1+ sql-history-index))
	      (erase-buffer)
	      (insert (nth (1- sql-history-index) sql-history))
	      (setq sql-current-error-point nil)
	      (if (sql-multi-headers)
		  (setq sql-move-headers nil)
		(setq sql-move-headers t)
		(setq sql-header-text
		      (buffer-substring (point-min)
					(save-excursion
					  (goto-char (point-min))
					  (forward-line 2) (point)))))
	      (and sql-mark-changes (sql-start-marking-changes))))
	(set-buffer sql-matching-buffer)))
  (message "History element: %d %s" sql-history-index linked))

(defun sql-next-history ()
  "Copy the next history element into the current buffer."
  (interactive)
  (sql-goto-batch-buffer)
  (setq linked "(unlinked)")
  (if (equal sql-history-index 0)
      (error "You have reached the end of the history list.")
    (if (equal sql-history-index 1)
	(progn
	  (setq sql-history-index (1- sql-history-index))
	  (erase-buffer)
	  (insert sql-end-history)
	  (if (and (bufferp sql-matching-buffer)
		   (buffer-name sql-matching-buffer))
	      (let ((this-history-length (length sql-history))
		    (this-current-history sql-history-index))
		(set-buffer sql-matching-buffer)
		(if (and (equal (length sql-history) this-history-length)
			 (equal sql-history-index (1+ this-current-history)))
		    (progn
		      (setq linked "(linked)")
		      (setq sql-history-index (1- sql-history-index))
		      (erase-buffer)))
		(set-buffer sql-matching-buffer))))
      (setq sql-history-index (1- sql-history-index))
      (erase-buffer)
      (if (not (equal sql-history-index 0))
	  (insert (nth (1- sql-history-index) sql-history)))
      (if (and (bufferp sql-matching-buffer)
	       (buffer-name sql-matching-buffer))
	  (let ((this-history-length (length sql-history))
		(this-current-history sql-history-index))
	    (set-buffer sql-matching-buffer)
	    (if (and (equal (length sql-history) this-history-length)
		     (equal sql-history-index (1+ this-current-history)))
		(progn
		  (setq linked "(linked)")
		  (and sql-mark-changes (sql-stop-marking-changes))
		  (setq sql-history-index (1- sql-history-index))
		  (erase-buffer)
		  (if (not (equal sql-history-index 0))
		      (progn
			(insert (nth (1- sql-history-index) sql-history))
			(setq sql-current-error-point nil)
			(if (sql-multi-headers)
			    (setq sql-move-headers nil)
			  (setq sql-move-headers t)
			  (setq sql-header-text
				(buffer-substring (point-min)
						  (save-excursion
						    (goto-char (point-min))
						    (forward-line 2)
						    (point)))))))
		  (and sql-mark-changes (sql-start-marking-changes))))
	    (set-buffer sql-matching-buffer))))
    (message "History element: %d %s" sql-history-index linked)))

(defun sql-goto-history (history-number)
  "Insert the history element HISTORY-NUMBER into the current buffer."
  (interactive "nHistory Number: ")
  (sql-goto-batch-buffer)
  (setq linked "(unlinked)")
;  (if (null sql-history)
;      (error "The history list is empty."))
  (if (or (< history-number 0) (> history-number (length sql-history)))
      (error "%d is out of range.  Valid numbers are 0 - %d."
	     history-number (length sql-history)))
  (setq sql-history-index history-number)
  (if (equal sql-history-index 0)
      (setq sql-end-history (buffer-substring (point-min) (point-max))))
  (erase-buffer)
  (and (> history-number 0)
       (insert (nth (1- sql-history-index) sql-history)))
  (if (and (bufferp sql-matching-buffer) (buffer-name sql-matching-buffer))
      (let ((this-history-length (length sql-history)))
	(set-buffer sql-matching-buffer)
	(if (equal (length sql-history) this-history-length)
	    (progn
	      (setq linked "(linked)")
	      (and sql-mark-changes (sql-stop-marking-changes))
	      (setq sql-history-index history-number)
	      (erase-buffer)
	      (and (> history-number 0)
		   (insert (nth (1- sql-history-index) sql-history)))
	      (setq sql-current-error-point nil)
	      (if (sql-multi-headers)
		  (setq sql-move-headers nil)
		(setq sql-move-headers t)
		(setq sql-header-text
		      (buffer-substring (point-min)
					(save-excursion
					  (goto-char (point-min))
					  (forward-line 2) (point)))))
	      (and sql-mark-changes (sql-start-marking-changes))))
	(set-buffer sql-matching-buffer)))
  (message "History element: %d %s" sql-history-index linked))

(defun sql-goto-global-history (history-number)
  "Insert the global history element HISTORY-NUMBER into the current buffer."
  (interactive "nGlobal History Number: ")
  (setq linked "(unlinked)")
  (sql-goto-batch-buffer)
  (if (null sql-global-history)
      (error "The global history list is empty."))
  (if (or (< history-number 0) (> history-number (length sql-global-history)))
      (error "%d is out of range.  Valid numbers are 0 - %d."
	     history-number (length sql-global-history)))
  (setq sql-global-history-index history-number)
  (erase-buffer)
  (and (> history-number 0)
       (insert (nth sql-global-history-index sql-global-history)))
  (if (and (bufferp sql-matching-buffer) (buffer-name sql-matching-buffer))
      (let ((this-global-history-length (length sql-global-history)))
	(set-buffer sql-matching-buffer)
	(if (equal (length sql-global-history) this-global-history-length)
	    (progn
	      (setq linked "(linked)")
	      (and sql-mark-changes (sql-stop-marking-changes))
	      (setq sql-global-history-index history-number)
	      (erase-buffer)
	      (and (> history-number 0)
		   (insert (nth sql-global-history-index sql-global-history)))
	      (setq sql-current-error-point nil)
	      (if (sql-multi-headers)
		  (setq sql-move-headers nil)
		(setq sql-move-headers t)
		(setq sql-header-text
		      (buffer-substring (point-min)
					(save-excursion
					  (goto-char (point-min))
					  (forward-line 2) (point)))))
	      (and sql-mark-changes (sql-start-marking-changes))))
	(set-buffer sql-matching-buffer)))
  (message "Global history element: %d %s" sql-global-history-index linked))

(defun sql-save-history ()
  "Save the current history to disk.
Use the file specified by `sql-history-file-name'."
  (interactive)
  (if sql-history
      (let ((buf (generate-new-buffer " history-temp"))
	    (history sql-history)
	    (old-standard-output standard-output)
	    (old-buffer (current-buffer)))
	(setq standard-output buf)
	(set-buffer buf)
	(princ "(setq sql-history\n      '")
	(prin1 history)
	(princ ")\n")
	(setq standard-output old-standard-output)
	(write-file sql-history-file-name)
	(set-buffer old-buffer)
	(kill-buffer buf))
    (error "There is no history currently available.")))

(defun sql-save-global-history ()
  "Save the current global history to disk.
Use the file specified by `sql-global-history-file-name'."
  (interactive)
  (if sql-global-history
      (let ((buf (generate-new-buffer " global-history-temp"))
	    (history sql-global-history)
	    (old-standard-output standard-output)
	    (old-buffer (current-buffer)))
	(setq standard-output buf)
	(set-buffer buf)
	(princ "(setq sql-global-history\n      '")
	(prin1 history)
	(princ ")\n")
	(setq standard-output old-standard-output)
	(write-file sql-global-history-file-name)
	(set-buffer old-buffer)
	(kill-buffer buf))
    (error "There is no global history currently available.")))

(defun sql-save-top-ten ()
  "Save the current top ten list to disk.
Use the file specified by `sql-top-ten-file-name'."
  (interactive)
  (if sql-top-ten
      (let ((buf (generate-new-buffer " top-ten-temp"))
	    (top-ten sql-top-ten)
	    (old-standard-output standard-output)
	    (old-buffer (current-buffer)))
	(setq standard-output buf)
	(set-buffer buf)
	(princ "(setq sql-top-ten\n      '")
	(prin1 top-ten)
	(princ ")\n")
	(setq standard-output old-standard-output)
	(write-file sql-top-ten-file-name)
	(set-buffer old-buffer)
	(kill-buffer buf))
    (error "There is no top ten list currently available.")))

(defun sql-load-history ()
  "Load the history file $HOME/.sql-history"
  (interactive)
  (if (file-readable-p sql-history-file-name)
      (progn
	(load-file sql-history-file-name)
	(setq sql-history-index 0))
    (error "Problems reading file %s" sql-history-file-name)))

(defun sql-load-global-history ()
  "Load the history file $HOME/.sql-global-history"
  (if (file-readable-p sql-global-history-file-name)
      (progn
	(load-file sql-global-history-file-name)
	(setq sql-global-history-index 0))
    (error "Problems reading file %s" sql-global-history-file-name)))
  
(defun sql-load-top-ten ()
  "Load the top-ten file $HOME/.sql-top-ten"
  (interactive)
  (if (file-readable-p sql-top-ten-file-name)
      (load-file sql-top-ten-file-name)
    (and (interactive-p)
	 (error "Problems reading file %s" sql-top-ten-file-name))))

(defun sql-add-top-ten (index)
  "Add the current buffer to the top ten list."
  (interactive "nTop ten index (0-9): ")
  (if (or (> index 9) (< index 0))
      (error "%d is not in the range 0-9." index)
    (aset sql-top-ten index (buffer-substring (point-min) (point-max)))
    (sql-save-top-ten)))

(defun sql-insert-top-ten-0 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?0))

(defun sql-insert-top-ten-1 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?1))

(defun sql-insert-top-ten-2 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?2))

(defun sql-insert-top-ten-3 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?3))

(defun sql-insert-top-ten-4 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?4))

(defun sql-insert-top-ten-5 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?5))

(defun sql-insert-top-ten-6 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?6))

(defun sql-insert-top-ten-7 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?7))

(defun sql-insert-top-ten-8 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?8))

(defun sql-insert-top-ten-9 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?9))

(defun sql-run-top-ten-0 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?0)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-1 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?1)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-2 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?2)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-3 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?3)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-4 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?4)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-5 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?5)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-6 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?6)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-7 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?7)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-8 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?8)
  (sql-evaluate-buffer nil))

(defun sql-run-top-ten-9 ()
  "Insert a commonly used query into the buffer."
  (interactive)
  (sql-insert-top-ten ?9)
  (sql-evaluate-buffer nil))

(defun sql-insert-top-ten (index)
  (interactive "cTop ten index: ")
  (setq index (string-to-int (char-to-string index)))
  (let ((query (aref sql-top-ten index))
	(this-buffer (current-buffer)))
    (if (not query)
	(error "Top ten #%d is empty." index)
      (erase-buffer)
      (insert query)
      (if (sql-goto-matching-buffer t)
	  (erase-buffer))
      (set-buffer this-buffer)
      (message "Top ten #%d." index))))

(defun sql-check-for-where ()
  "Signal an error if no `where' clause is found in the current buffer.
Check for the occurance of `sql-require-where-regexp' and signal error
if there is no `where' clause."
  (and sql-require-where
       (sql-search-for-regexp sql-require-where-regexp nil)
       (not (sql-search-for-regexp "[\t\n ]where[\t\n ]" t))
       (not (sql-popup-dialog "WARNING: There is no `where' clause in this statement.  Execute anyway?


(See the help on the variable `sql-require-where' to supress this warning)"))
       (error "Aborted.")))

(defun sql-popup-dialog (prompt)
  (if sql-lucid
      (sql-popup-dialog-return (list prompt ["YES" t t] nil ["NO" 'no t]))
    (x-popup-dialog t (cons prompt '(("YES" . t) ("NO" . nil))))))

(defun sql-popup-dialog-return (dbox-desc)
  "Ask user a question with a popup dialog box.
Takes one argument, which is the dialog box description (see the function
popup-dialog-box).

Returns the callback specified by DBOX-DESC."
  (let ((echo-keystrokes 0)
	event)	 
    (popup-dialog-box dbox-desc)
    (let ((result (catch 'dialog-done
		    (while t
		      (setq event (next-command-event event))
		      (cond ((and (menu-event-p event)
				  (or (eq (event-object event) 'abort)
				      (eq (event-object event)
					  'menu-no-selection-hook)))
			     (signal 'quit nil))
			    ((menu-event-p event)
			     (throw 'dialog-done (event-object event)))
			    ((button-release-event-p event) ;; don't beep twice
			     nil)
			    (t
			     (beep)
			     (message "Please answer the dialog box")))))))
      (if (equal result '(quote no))
	  nil
	result))))

(defun sql-get-rows-affected (flag)
  "Check how many rows would be affected if current buffer was evaluated."
  (let ((rows 0))
    (if (sql-search-for-regexp sql-confirm-changes-regexp nil)
	(let ((mode-buffer (current-buffer)))
	  (goto-char (point-min))
	  (insert "begin tran\n")
	  (goto-char (point-max))
	  (insert "\nrollback tran\n")
	  (save-excursion 
	    (sql-evaluate-buffer flag t)
	    (setq rows (buffer-substring (point-min) (- (point-max) 2))))
	  (and (> (length rows) 500)
	       (setq rows (substring rows 0 500)))
	  (pop-to-buffer mode-buffer)
	  (goto-char (point-min))
	  (delete-char 11)
	  (goto-char (point-max))
	  (backward-delete-char 15)
	  (sql-popup-dialog
	   (concat "WARNING:\n\n" rows
		   "\n\nDo you wish to commit?


(See the help on the variable `sql-confirm-changes' to supress this warning)")))
    t)))

(defun sql-search-for-regexp (regexp check-syntax)
  "Search for REGEXP in non-commented text in current buffer.
Search for REGEXP in the current buffer, ignoring it if it is within
a comment block and CHECK-SYNTAX is non-nil."
  (save-excursion
    (goto-char (point-min))
    (let ((found nil))
      (while (re-search-forward regexp nil t)
	(if (and sql-lucid
		 (or check-syntax sql-risky-searches)
		 (or (eq (buffer-syntactic-context) 'comment)
		     (eq (buffer-syntactic-context) 'block-comment)))
	    nil
	  (setq found t)))
      found)))

(defun sql-set-server ()
  "Change the server, user, and password in the current sql-mode buffer."
  (interactive)
  (let* ((new-server (completing-read "Server Name: " sql-server-table))
	 (new-user (completing-read (format "User Name on Server %s: "
					    new-server)
				    sql-user-table))
	 (new-password (let ((prompt (format "Password for %s on %s: " 
					     new-user new-server)))
			 (if sql-secure-passwords
			     (sql-read-password prompt)
			   (read-string prompt)))))
    (sql-batch-mode new-server new-user new-password nil t)))

(defun sql-set-user ()
  "Change the user and password in the current sql-mode buffer."
  (interactive)
  (let* ((new-user (completing-read "User Name: " sql-user-table))
	 (new-password (let ((prompt (format "Password for %s on %s: " 
					     new-user server)))
			 (if sql-secure-passwords
			     (sql-read-password prompt)
			   (read-string prompt)))))
    (sql-batch-mode server new-user new-password nil t)))

(defun sql-set-password ()
  "Change the password in the current sql-mode buffer."
  (interactive)
  (let ((new-password (let ((prompt (format "Password for %s on %s: " 
					    user server)))
			(if sql-secure-passwords
			    (sql-read-password prompt)
			  (read-string prompt)))))
    (sql-batch-mode server user new-password nil t)))

(defun sql-set-bcp-user (user)
  "Change the name of the bcp user."
  (interactive (list (read-from-minibuffer (format "New BCP user (was %s): "
						   (or sql-bcp-user "nil")))))
  (if (string-equal user "")
      (setq sql-bcp-user nil)
    (setq sql-bcp-user user)))

(defun sql-add-association (add-mnemonic 
			    add-server 
			    add-user 
			    &optional add-password
			    add-database)
  "Add the association referenced by MNEMONIC.
Additions are made to the variable `sql-association-alist.'"
  (interactive "sMnemonic: 
sServer Name: 
sUser Name: ")
  (if (sql-get-association add-mnemonic sql-association-alist)
      (if (interactive-p)
	  (error "There already is an association for mnemonic: %s" 
		 add-mnemonic))
    (if (null add-password)
	(progn
	  (setq new-password (let ((prompt "Password: "))
			       (if sql-secure-passwords
				   (sql-read-password prompt)
				 (read-string prompt))))
	  (sit-for 0)))
    (setq sql-association-alist
	  (cons (list add-mnemonic (list add-server add-user
					 add-password add-database))
		sql-association-alist))
    (setq sql-server-table (cons (cons add-server "1") sql-server-table))
    (setq sql-user-table (cons (cons add-user "1") sql-user-table))))

(defun sql-get-association (mnemonic alist)
  "Return the association referenced by MNEMONIC."
  (if (string-equal mnemonic "-")
      nil
    (if (null alist) 
	nil
      (if (string-equal mnemonic (car (car alist)))
	  (car (cdr (car alist)))
	(sql-get-association mnemonic (cdr alist))))))

(defun sql-set-tables ()
  "Set the sql-server-table and sql-user-table variables."
  (let ((the-list sql-association-alist))
    (while the-list
      (if (string-equal (car (car the-list)) "-")
	  ()
	(setq the-server (car (car (cdr (car the-list)))))
	(setq the-user (car (cdr (car (cdr (car the-list))))))
	(setq sql-server-table (cons (cons the-server 1) sql-server-table))
	(setq sql-user-table (cons (cons the-user 1) sql-user-table)))
      (setq the-list (cdr the-list)))))

(defun sql-load-customizations ()
  "Load the file $HOME/.sql-mode"
  (let ((sql-file-name (concat (getenv "HOME") "/.sql-mode")))
    (if (file-readable-p sql-file-name)
	(progn
	  (load-file sql-file-name)
	  (setq sql-loaded t)
	  (sql-set-tables)))))

(defun sql-remove-dashes (elt)
  (if (string-equal (car elt) "-")
      nil
    elt))
      
(defun sql-association-mode (mnemonic &optional no-create interactive)
  "Invoke an sql-batch-mode buffer with information specified by MNEMONIC.
The server, user, and password are determined by referencing MNEMONIC in
`sql-association-alist'.  See sql-add-association for more detail on
mnemonics.  Invoke an sql-interactive-mode buffer if optional INTERACTIVE
is non-nil."
  (interactive (list (completing-read "Association mnemonic: "
				      (delete nil
					      (mapcar
					       'sql-remove-dashes
					       sql-association-alist)))))
  (if (and no-create
	   (not (eq major-mode 'sql-batch-mode))
	   (not (eq major-mode 'sql-interactive-mode)))
      (setq no-create nil))
  (let ((association (sql-get-association mnemonic sql-association-alist)))
    (if association
	(if interactive
	    (sql-interactive-mode (nth 0 association) 
				  (nth 1 association) 
				  (nth 2 association))
	  (sql-batch-mode (nth 0 association) 
			  (nth 1 association) 
			  (nth 2 association)
			  (nth 3 association)
			  no-create))
      (error "There is no association for mnemonic %s" mnemonic))))

(defun sql-make-association-menu (assoc-alist mode)
  "Return a list of all server/login-id pairs in menu format."
  (if (null assoc-alist)
      nil
    (let* ((head (car assoc-alist))
	  (tail (cdr assoc-alist))
	  (popup-item (if (string-equal (nth 0 head) "-")
			  (nth 0 (car (cdr head)))
			(vector (concat (nth 0 head) "  "
					(nth 0 (car (cdr head))) "  "
					(nth 1 (car (cdr head))) "  "
					(nth 3 (car (cdr head))))
				(list 'sql-association-mode 
				      (nth 0 head)
				      sql-association-mode-no-create
				      (if (eq mode 'sql-interactive-mode)
					  t
					nil))
				't))))
      (cons popup-item (sql-make-association-menu tail mode)))))

(defun sql-make-popup-menu (mode)
  "Return a menu of all defined associations."
  (cond
   ((eq mode 'sql-batch-mode)
    (cons "SQL Batch Associations"
	  (sql-make-association-menu sql-association-alist mode)))
   ((eq mode 'sql-interactive-mode)
    (cons (concat (capitalize sql-command) " Interactive Associations" )
	  (sql-make-association-menu sql-association-alist mode)))
   (t
    nil)))

(defun sql-popup-association-menu ()
  "Pop up a menu of all defined associations.
Associations are stored in the variable `sql-association-alist'."
  (interactive)
  (if (null sql-association-alist)
      nil
    (cond 
     ((eq major-mode 'sql-batch-mode)
      (popup-menu (sql-make-popup-menu 'sql-batch-mode)))
     ((eq major-mode 'sql-interactive-mode)
      (popup-menu (sql-make-popup-menu 'sql-interactive-mode)))
     (t
      (error "You must be in an sql-batch-mode or an sql-interactive-mode buffer.")))))

(defun sql-replace-word (string)
  "Replace the current word with STRING."
  (interactive)
  (or (char-equal (preceding-char) ? )
      (backward-kill-word 1))
  (or (char-equal (following-char) ? )
      (kill-word 1))
  (insert string)
  (if (looking-at " ")
      (forward-char 1)
    (insert " ")))

(defun sql-split (list n)
  (let ((remain list)
        (result '())
        (sublist '())
        (i 0))
    (while remain
      (or (string-equal (car (car remain)) "
")
	  (setq sublist (cons (car remain) sublist)))
      (setq remain (cdr remain))
      (setq i (1+ i))
      (and (= i n)
           ;; We have finished a sublist
           (progn (setq result (cons sublist result))
                  (setq i 0)
                  (setq sublist '()))))
    ;; There might be a sublist (if the length of LIST mod n is != 0)
    ;; that has to be added to the result list.
    (and sublist
         (setq result (cons sublist result)))
    result))

(defun sql-index-sublist-1 (sublist ix limit)
  (let ((s1 (substring (car (car sublist)) 0 (min limit ix)))
        (s2 (substring
             (car (nth (1- (length sublist)) sublist))
             0 (min (length (car (nth (1- (length sublist)) sublist))) ix))))
    (cons s1 s2)))

(defun sql-index-sublist (sublist &rest count)
  (let* ((cmplength 100)
         (limit (length (car (car sublist))))
         (result (sql-index-sublist-1 sublist cmplength limit))
         (str1 (car result))
         (str2 (cdr result)))
    (while (and (string-equal str1 str2) (< cmplength limit))
      (setq cmplength (1+ cmplength)
            result (sql-index-sublist-1 sublist cmplength limit)
            str1 (car result)
            str2 (cdr result)))
    (cond ((not (string-equal str1 str2))
           (format "%s ... %s" str1 str2))
          ((< cmplength limit)
           (format "%s" str1))
          (t
           (format "%s ..." str1)))))

(defun sql-popup-continuation-menu (menu title)
  "Pop up a menu with more... entries if overflow."
  (interactive)
  (let* ((count 0)
	 (split-menu
	  (mapcar
	   (function
	    (lambda (sublist)
	      (setq count (1+ count))
	      (cons (format "%s" (sql-index-sublist sublist count))
		    (mapcar
		     (function
		      (lambda (menu)
			(vector (format "%s" (car menu))
				(list 'sql-replace-word
				      (car menu))
				t)))
		     sublist))))
	   (sql-split menu 20))))
    (popup-menu (cons title split-menu))))

(defun sql-popup-table-list ()
  "Pop up a menu displaying the tables to choose from."
  (interactive)
  (or sql-table-list
      (sql-get-tables))
  (sql-popup-continuation-menu sql-table-list
			       (concat "Tables" (or database ""))))

(defun sql-popup-column-list ()
  "Pop up a menu displaying the columns to choose from."
  (interactive)
  (let ((table-name (sql-get-table-name)))
    (or (assoc table-name sql-column-list)
	(sql-get-columns))
    (sql-popup-continuation-menu (cdr (assoc table-name sql-column-list))
				 (concat "Columns for " table-name))))
	  
(defun sql-popup-stored-procedure-list ()
  "Pop up a menu displaying the stored-procedures to choose from."
  (interactive)
  (or sql-stored-procedure-list
      (sql-get-stored-procedures))
  (sql-popup-continuation-menu sql-stored-procedure-list "Stored Procedures"))

(defun sql-popup-keyword-list ()
  "Pop up a menu displaying the stored-procedures to choose from."
  (interactive)
  (or sql-keyword-list
      (sql-get-keywords))
  (sql-popup-continuation-menu sql-keyword-list "Keywords"))

(defun sql-dynamic-popup-menu (event)
  "Pop up a menu depending on the context of point.
Possibilities include associations, or completion lists of tables, column,
stored procedures or keywords."
  (interactive "@e")
  (let ((pos (event-point event))
	(context))
    (save-excursion
      (goto-char (or pos (point-max)))
      (setq context (and pos (sql-get-completion-context)))
      (cond
       ((eq context 'table)
	(sql-popup-table-list))
       ((eq context 'column)
	(sql-popup-column-list))
       ((eq context 'stored-procedure)
	(sql-popup-stored-procedure-list))
       ((eq context 'keyword)
	(sql-popup-keyword-list))
       (t
	(sql-popup-association-menu))))
    (and pos (goto-char pos))))

(defun sql-load-abbrevs ()
  "Load any user-defined abbrevs for sql-mode."
  (let ((sql-abbrevs-file-name (concat (getenv "HOME") "/.sql-abbrevs")))
    (and (file-readable-p sql-abbrevs-file-name)
	 (read-abbrev-file sql-abbrevs-file-name))
    (setq local-abbrev-table sql-mode-abbrev-table)))

(defun sql-read-password (prompt &optional default)
  "Read a password from the user. Echos a * for each character typed.
End with RET, LFD, or ESC. DEL or C-h rubs out.  ^U kills line.
Optional DEFAULT is password to start with."
  (let ((pass (if default default ""))
	(c 0)
	(echo-keystrokes 0)
	(cursor-in-echo-area t))
    (while (and (/= c ?\r) (/= c ?\n) (/= c ?\e))
      (message "%s%s"
	       prompt
	       (make-string (length pass) ?*))
      (setq c (read-char))
      (if (= c ?\C-u)
	  (setq pass "")
	(if (and (/= c ?\b) (/= c ?\177))
	    (setq pass (concat pass (char-to-string c)))
	  (if (> (length pass) 0)
	      (setq pass (substring pass 0 -1))))))
    (message nil)
    (sit-for 0)
    (substring pass 0 -1)))

(setq sql-tmp-keymap (make-sparse-keymap))
(define-key sql-tmp-keymap "\C-m" 'exit-minibuffer)

; this function is going to be needed if sql-mode.el is ever ported to FSFmacs
;
;(defun sql-repaint-minibuffer ()
;  "Gross hack to set minibuf_message = 0, so that the contents of the
;minibuffer will show."
;  (if (eq (selected-window) (minibuffer-window))
;      (if (string-match "Lucid" emacs-version)
;	  (message nil)
;	;; v18 GNU Emacs
;	(let ((unread-command-char ?\C-m)
;	      (enable-recursive-minibuffers t))
;	  (read-from-minibuffer "" nil sql-tmp-keymap nil)))))

(defun sql-comment-line ()
  "Comment out one line of SQL code.
Insert sql-comment-start-string at the beginning of the line, 
and a sql-comment-end-string at the end."
  (save-excursion
    (back-to-indentation)
    (if (and (not (looking-at sql-comment-start-regexp))
	     (looking-at "."))
	(progn
	  (insert sql-comment-start-string)
	  (end-of-line)
	  (insert sql-comment-end-string)))))

(defun sql-uncomment-line ()
  "Uncomment out one line of SQL code.
Remove sql-comment-start-string and sql-comment-end-string from the line."
  (save-excursion
    (back-to-indentation)
    (if (looking-at sql-commented-line-regexp)
	(progn
	  (delete-char 3)
	  (end-of-line)
	  (backward-delete-char 3)))))
  
(defun sql-comment-line-toggle ()
  "Comment out a line of SQL code, or un-comment it if it is commented."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (if (looking-at sql-commented-line-regexp)
	(sql-uncomment-line)
      (sql-comment-line))))

(defun sql-comment-buffer ()
  "Comment out each line of SQL code in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line sql-comment-buffer-ignore-lines)
    (sql-comment-line)
    (while (eq 0 (forward-line 1))
      (sql-comment-line))))

(defun sql-uncomment-buffer ()
  "Remove comment from each line of SQL code in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line sql-comment-buffer-ignore-lines)
    (sql-uncomment-line)
    (while (eq 0 (forward-line 1))
      (sql-uncomment-line))))

(defun sql-comment-buffer-toggle ()
  "Toggle the comment state of each line in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line sql-comment-buffer-ignore-lines)
    (sql-comment-line-toggle)
    (while (eq 0 (forward-line 1))
      (sql-comment-line-toggle)
      (end-of-line))))

(defun sql-find-beginning ()
  "Find the location of the first character on the current line."
  (if (> (point) (mark))
      (exchange-point-and-mark))
  (beginning-of-line)
  (point))

(defun sql-find-end ()
  "Find the location of the last character on the current line."
  (if (< (point) (mark))
      (exchange-point-and-mark))
  (end-of-line)
  (point))

(defun sql-comment-region ()
  "Comment out each line of SQL code in the current region."
  (interactive)
  (save-excursion
    (if sql-comment-regions-by-line
	(progn
	  (let ((beginning (sql-find-beginning))
		(end (sql-find-end)))
	    (narrow-to-region beginning end)
	    (goto-char (point-min))
	    (sql-comment-line)
	    (while (eq 0 (forward-line 1))
	      (sql-comment-line))
	    (widen)))
      (narrow-to-region (point) (mark))
      (goto-char (point-min))
      (if (looking-at sql-comment-start-regexp)
	  ()
	(insert sql-comment-start-string)
	(goto-char (point-max))
	(insert sql-comment-end-string))
      (widen)))
  (if sql-deactivate-region
      (zmacs-deactivate-region)))
		   
(defun sql-uncomment-region ()
  "Uncomment each line of SQL code in the current region."
  (interactive)
  (save-excursion
    (if sql-comment-regions-by-line
	(progn
	  (let ((beginning (sql-find-beginning))
		(end (sql-find-end)))
	    (narrow-to-region beginning end)
	    (goto-char (point-min))
	    (sql-uncomment-line)
	    (while (eq 0 (forward-line 1))
	      (sql-uncomment-line))
	    (widen)))
      (narrow-to-region (point) (mark))
      (goto-char (point-min))
      (if (not (looking-at sql-comment-start-regexp))
	  ()
	(delete-char 3)
	(goto-char (point-max))
	(backward-delete-char 3))
      (widen)))
  (if sql-deactivate-region
      (zmacs-deactivate-region)))

(defun sql-comment-region-toggle ()
  "Toggle comment state of each line in the current region."
  (interactive)
  (save-excursion
    (if sql-comment-regions-by-line
	(progn
	  (let ((beginning (sql-find-beginning))
		(end (sql-find-end)))
	    (narrow-to-region beginning end)
	    (goto-char (point-min))
	    (sql-comment-line-toggle)
	    (while (eq 0 (forward-line 1))
	      (sql-comment-line-toggle))
	    (widen)
	    (if sql-deactivate-region
		(zmacs-deactivate-region))))
      (error "This function is disabled when sql-comment-regions-by-line's value is nil."))))

(defun sql-forward-column ()
  "Scroll the buffer one column to the left."
  (interactive)
  (scroll-left 1))

(defun sql-backward-column ()
  "Scroll the buffer one column to the right."
  (interactive)
  (scroll-right 1))

(defun sql-first-row ()
  "Warp point to the second line in the buffer (the first row)."
  (interactive)
  (setq zmacs-region-stays t)
  (goto-char (point-min))
  (forward-line 2))

(defun sql-last-row ()
  "Warp point to the last row in the buffer."
  (interactive)
  (setq zmacs-region-stays t)
  (goto-char (point-max))
  (forward-line -1))

(defun sql-beginning-of-row ()
  "Move point to beginning of current row."
  (interactive)
  (setq zmacs-region-stays t)
  (scroll-right sql-max-screen-width)
  (beginning-of-line))

(defun sql-end-of-row ()
  "Move point to end of current row."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((end (progn (end-of-line) (current-column))))
    (sql-beginning-of-row)
    (scroll-left (- end (- (screen-width) sql-scroll-overlap)))
    (end-of-line)))

(defun sql-horizontal-recenter ()
  "Scroll the window as necessary horizontally so that point is centered."
  (interactive)
  (sql-recenter t))

(defun sql-reposition-windows ()
  "Resize the results buffer and display it."
  (interactive)
  (sql-goto-batch-buffer)
  (if (bufferp sql-matching-buffer)
      (progn
	(sql-create-results-buffer sql-matching-buffer)
	(sql-goto-batch-buffer))
    (delete-other-windows)))

(defun sql-recenter (&optional horizontal-only)
  "Scroll the window as necessary so that point is centered.
Only scroll horizontally if optional HORIZONTAL-ONLY is non-nil."
  (interactive)
  (if (or (eq major-mode 'sql-results-mode)
	  (eq major-mode 'sql-interactive-mode))
      (let ((the-point (point)))
	(save-excursion
	  (let ((position (current-column))
		(half-screen (/ (screen-width) 2)))
	    (sql-beginning-of-row)
	    (scroll-left (- position half-screen))
	    (if (not horizontal-only)
		(progn
		  (sql-remove-header)
		  (recenter (1- (/ (window-height) 2)))
		  (sql-insert-header (window-start))))))
	(goto-char the-point))
    (recenter)))

(defun sql-toggle-results-in-new-screen ()
  "Toggle the value of sql-results-in-new-screen."
  (interactive)
  (setq sql-results-in-new-screen (not sql-results-in-new-screen)))

(defun sql-toggle-save-all-results ()
  "Toggle the value of sql-save-all-results."
  (interactive)
  (setq sql-save-all-results (not sql-save-all-results)))

(defun sql-pop-and-rename-buffer ()
  "Pop the current buffer to a new window, and give it a unique name."
  (interactive)
  (or (eq major-mode 'sql-results-mode)
      (error "Buffer is not an sql-results buffer."))
  (let* ((buf-name (buffer-name))
	 (contents (buffer-substring (point-min) (point-max)))
	 (new-buffer (generate-new-buffer (concat buf-name "<saved>")))
	 (the-server server)
	 (the-user user))
    (switch-to-buffer-other-screen new-buffer)
    (insert contents)
    (sql-results-mode the-server the-user)
    (if sql-resize-results-screens
	(progn
	  (set-screen-height (selected-screen) sql-results-screen-height)
	  (set-screen-width (selected-screen) sql-results-screen-width)))))

(defun sql-drag-display (event)
  "Drag the current buffer under mouse."
  (interactive "@e")
  (let ((down t)
        (start-x (event-x event))
        (start-y (event-y event))
;        (p-shape x-pointer-shape)
;        (nt-p-shape x-nontext-pointer-shape)
;        (m-p-shape x-mode-pointer-shape)
        new-x
        new-y)
    (while down
      (next-event event)
      (if (or (button-press-event-p event)
              (button-release-event-p event))
          (setq down nil))
      (dispatch-event event)
      (if (motion-event-p event)
	(progn
	  (setq new-x (event-x event)
		new-y (event-y event))
	  (condition-case the-error
	      (progn
		(sql-scroll-down (- new-y start-y))
		(scroll-left (- start-x new-x))
		(setq start-x new-x
		      start-y new-y))
	    (error "")))))))

(defun sql-set-sql-command (new-command)
  "Set the value of the variable sql-command."
  (interactive "sEnter the new sql-command: ")
  (if (not (eq 'sql-batch-mode major-mode))
      (error "You must be in an sql-batch-mode buffer to set `sql-command'")
    (if new-command
	(progn
	  (setq sql-command new-command)
	  (sql-batch-mode server user password nil t)))))

(defun sql-back-to-nonblank-line ()
  "Move up lines until a line with something other than whitespace is found.
Return number of lines moved."
  (let ((count 0)
	(done nil))
    (while (and (not done)
		(equal 0 (forward-line -1)))
      (setq count (1+ count))
      (back-to-indentation)
      (if (looking-at ".")
	  (setq done t)))
    (if done
	count
      0)))

;(defun sql-calculate-indent ()
;  "Return appropriate indentation for current line of SQL code.
;In usual case returns an integer: the column to indent to.
;Returns nil if line starts inside a string, t if in a comment."
;  (save-excursion
;    (if (equal 0 (sql-back-to-nonblank-line))
;	0
;      (back-to-indentation)
;      (cond ((looking-at "begin\\>")
;	     (+ sql-basic-offset (current-column)))
;	    ((looking-at "if[ \t]")
;	     (+ sql-basic-offset (current-column)))
;	    ((looking-at "else[ \t]")
;	     (+ sql-basic-offset (current-column)))
;	    (t
;	     (current-column))))))

(defun sql-previous-bol-indent (regexp)
  (save-excursion
    (let ((count 0)
	  (done nil))
      (while (and (not done)
		  (equal 0 (forward-line -1)))
	(setq count (1+ count))
	(back-to-indentation)
	(if (looking-at regexp)
	    (setq done t)))
      (if (not done)
	  0
	(current-column)))))

(defun sql-previous-indent (regexp &optional check-for-if)
  (let ((previous-bol (sql-previous-bol-indent regexp))
	(offset 0))
    (and check-for-if
	 (save-excursion
	   (beginning-of-line)
	   (and (re-search-backward (concat "^[ \t]*" sql-bos-regexps) nil t)
		(not (looking-at "[ \t]*\\(if\\|else\\)"))
		(re-search-backward (concat "^[ \t]*" sql-bos-regexps) nil t)
		(looking-at "[ \t]*\\(if\\|else\\)")
		(setq offset (- sql-basic-offset)))))
    (+ previous-bol offset)))

(defun sql-previous-indent-of (regexp)
  (save-excursion
    (if (re-search-backward regexp nil t)
	(current-column)
      0)))

(defun sql-previous-matching-indent (begin-regexp end-regexp)
  (save-excursion
    (let ((level 1))
      (while (and (> level 0)
		  (equal 0 (forward-line -1)))
	(back-to-indentation)
	(cond ((looking-at begin-regexp)
	       (setq level (1- level)))
	      ((looking-at end-regexp)
	       (setq level (1+ level)))))
      (if (> level 0)
	  0
	(current-column)))))

(defun sql-previous-command-info ()
  (interactive)
  (let ((done nil))
    (save-excursion
      (while (and (not done)
		  (equal 0 (forward-line -1)))
	(back-to-indentation)
	(if (looking-at sql-bos-regexps)
	    (setq done t)))
      (if done
	  (cons (current-column) (buffer-substring (match-beginning 0) 
						   (match-end 0)))
	(cons 0 "")))))

(defun sql-calculate-offset ()
  (interactive)
  (let* ((info (sql-previous-command-info))
	 (offset 0)
	 (command-type (cdr info)))
    (cond ((string-equal command-type "begin")
	   (setq offset sql-basic-offset))
	  ((string-equal command-type "(")
	   (setq offset sql-basic-offset))
	  ((string-equal command-type "{")
	   (setq offset sql-basic-offset))
	  ((string-equal command-type "if")
	   (setq offset sql-basic-offset))
	  ((string-equal command-type "else")
	   (setq offset sql-basic-offset))
;	  ((string-equal command-type "select")
;	   (setq offset 7))
;	  ((string-equal command-type "update")
;	   (setq offset 7))
	  (t
	   nil))
    offset))

(defun sql-show-syntactic-information ()
  "Show syntactic information for current line."
  (interactive)
  (message "syntactic analysis: %s" (sql-guess-basic-syntax)))
  
(defun sql-indent-line ()
  "Indent the current line as SQL code.

Not fully implementd (yet)"
  (interactive)
  (let ((offset (sql-calculate-offset))
	(indent (current-column)))
    (save-excursion
      (back-to-indentation)
      (cond 
       ((looking-at "where\\>")
	(setq indent (sql-previous-indent-of "select\\|update")))
       ((looking-at "and\\>")
	(setq indent (sql-previous-indent sql-keyword-regexps)))
       ((looking-at "else\\>")
	(setq indent (sql-previous-matching-indent "if\\>" "else\\>")))
       ((looking-at "end\\>")
	(setq indent (sql-previous-matching-indent "begin\\>" "end\\>")))
       ((looking-at "#")
	(setq indent 0))
       ((looking-at "prodedure\\>")
	(setq indent 0))
       ((looking-at sql-bos-regexps)
	(setq indent (+ offset (sql-previous-indent sql-bos-regexps t))))
       ((looking-at sql-keyword-regexps)
	(setq indent (+ offset (sql-previous-indent sql-keyword-regexps))))
       ((looking-at "(\n")
	(setq indent (+ sql-basic-offset
			(sql-previous-indent sql-keyword-regexps))))
       ((looking-at ")")
	(setq indent (sql-previous-matching-indent "(\n" ")\n")))
       ((looking-at "{\n")
	(setq indent (+ sql-basic-offset
			(sql-previous-indent sql-keyword-regexps))))
       ((looking-at "}")
	(setq indent (sql-previous-matching-indent "}\n" "}\n")))
       ((not (looking-at "."))
	(setq indent (+ offset (sql-previous-indent sql-keyword-regexps))))
       (t
	(setq indent (+ offset
			(if (eq offset 0)
			    sql-continued-statement-offset
			  0)
			(sql-previous-indent sql-keyword-regexps)))))
      (delete-region (point) (progn (beginning-of-line) (point)))
      (indent-to indent))
    (if (< (current-column) indent)
	(skip-chars-forward " \t"))))

(defmacro sql-add-syntax (symbol &optional relpos)
  ;; a simple macro to append the syntax in symbol to the syntax list.
  ;; try to increase performance by using this macro
  (` (setq sql-syntax (cons (cons (, symbol) (, relpos)) sql-syntax))))

(defun sql-in-literal (&optional lim)
  ;; Determine if point is in a C++ literal
  (save-excursion
    (let* ((lim (or lim (sql-point 'bod)))
	   (here (point))
	   (state (parse-partial-sexp lim (point))))
      (cond
       ((nth 3 state) 'string)
       ((nth 4 state) 'comment)
       ((progn
	  (goto-char here)
	  (beginning-of-line)
	  (looking-at "[ \t]*#"))
	'pound)
       (t nil)))))

(defun sql-beginning-of-statement (&optional count lim)
  "Go to the beginning of the innermost SQL statement.
With prefix arg, go back N - 1 statements.  If already at the
beginning of a statement then go to the beginning of the preceding
one.  If within a string or comment, or next to a comment (only
whitespace between), move by sentences instead of statements.

When called from a program, this function takes 2 optional args: the
prefix arg, and a buffer position limit which is the farthest back to
search."
  (interactive "p")
  (let ((here (point))
	(count (or count 1))
	(lim (or lim (sql-point 'bod)))
	state)
    (save-excursion
      (goto-char lim)
      (setq state (parse-partial-sexp (point) here nil nil)))
    (if (and (interactive-p)
	     (or (nth 3 state)
		 (nth 4 state)
		 (looking-at (concat "[ \t]*" comment-start-skip))
		 (save-excursion
		   (skip-chars-backward " \t")
		   (goto-char (- (point) 2))
		   (looking-at "\\*/"))))
	(forward-sentence (- count))
      (while (> count 0)
	(re-search-backward sql-keyword-regexps nil t)
	(setq count (1- count)))
;      (while (< count 0)
;	(c-end-of-statement-1)
;	(setq count (1+ count))))
      )
    ;; its possible we've been left up-buf of lim
    (goto-char (max (point) lim))
    ))
;  (c-keep-region-active))

(defun sql-guess-basic-syntax ()
  "Guess the syntactic description of the current line of SQL code.

This function does not currently work (at all)."
  (save-excursion
    (save-restriction
      (beginning-of-line)
      (let* ((indent-point (point))
	     (case-fold-search nil)
	     (state (c-parse-state))
	     literal containing-sexp char-before-ip char-after-ip lim
	     sql-syntax placeholder
	     )

	;; get the buffer position of the most nested opening brace,
	;; if there is one, and it hasn't been narrowed out
	(save-excursion
	  (goto-char indent-point)
	  (skip-chars-forward " \t}")
	  (skip-chars-backward " \t")
	  (while (and state
		      (not containing-sexp))
	    (setq containing-sexp (car state)
		  state (cdr state))
	    (if (consp containing-sexp)
		;; if cdr == point, then containing sexp is the brace
		;; that opens the sexp we close
		(if (= (cdr containing-sexp) (point))
		    (setq containing-sexp (car containing-sexp))
		  ;; otherwise, ignore this element
		  (setq containing-sexp nil))
	      ;; ignore the bufpos if its been narrowed out by the
	      ;; containing class
	      (if (<= containing-sexp (point-min))
		  (setq containing-sexp nil)))))

	;; set the limit on the farthest back we need to search
	(setq lim (or containing-sexp (point-min)))

;	(message "%d" containing-sexp) (sit-for 1)

	;; cache char before and after indent point, and move point to
	;; the most likely position to perform the majority of tests
	(goto-char indent-point)
	(skip-chars-forward " \t")
	(setq char-after-ip (following-char))
	(c-backward-syntactic-ws lim)
	(setq char-before-ip (preceding-char))
	(goto-char indent-point)
	(skip-chars-forward " \t")

	;; are we in a literal?
	(setq literal (sql-in-literal lim))

	;; now figure out syntactic qualities of the current line
	(cond
	 ;; CASE 1: in a string.
	 ((memq literal '(string))
	  (sql-add-syntax 'string (sql-point 'bopl)))
	 ;; CASE 2: in a C or C++ style comment.
	 ((memq literal '(comment))
	  ;; we need to catch multi-paragraph C comments
	  (while (and (zerop (forward-line -1))
		      (looking-at "^[ \t]*$")))
	  (sql-add-syntax literal (sql-point 'bol)))
	 ;; CASE 3: in a cpp preprocessor directive
	 ((eq literal 'pound)
	  (back-to-indentation)
	  (sql-add-syntax 'cpp-macro (sql-point 'boi)))
	 ;; CASE 4: in an objective-c method intro
	 ;; CASE 5: Line is at top level.
	 ((null containing-sexp)
	  (cond
	   ;; CASE 5Z: we are looking at "go"
	   ((save-excursion
	      (goto-char indent-point)
	      (skip-chars-forward " \t{")
	      (looking-at "go\\>"))
	    (sql-add-syntax 'go))

	   ;; CASE 5A: we are looking at a defun, class, or
	   ;; inline-inclass method opening brace
	   ((= char-after-ip ?{)
	    (cond
	     ;; CASE 5A.1: we are looking at a class opening brace
	     ((save-excursion
		(goto-char indent-point)
		(skip-chars-forward " \t{")
		(let ((decl (c-search-uplist-for-classkey (c-parse-state))))
		  (and decl
		       (setq placeholder (aref decl 0)))
		  ))
	      (sql-add-syntax 'class-open placeholder))
	     ;; CASE 5A.2: brace list open
	     ((save-excursion
		(sql-beginning-of-statement nil lim)
		;; c-b-o-s could have left us at point-min
		(and (bobp)
		     (c-forward-syntactic-ws indent-point))
		(setq placeholder (point))
		(and (or (looking-at "enum[ \t\n]+")
			 (= char-before-ip ?=))
		     (save-excursion
		       (skip-chars-forward "^;" indent-point)
		       (/= (following-char) ?\;))))
	      (sql-add-syntax 'brace-list-open placeholder))
	     ;; CASE 5A.3: inline defun open
	     ;; CASE 5A.4: ordinary defun open
	     (t
	      (goto-char placeholder)
	      (sql-add-syntax 'defun-open (sql-point 'bol))
	      )))
	   ;; CASE 5B: first K&R arg decl or member init
	   ((c-just-after-func-arglist-p)
	    (cond
	     ;; CASE 5B.1: a member init
	     ((or (= char-before-ip ?:)
		  (= char-after-ip ?:))
	      ;; this line should be indented relative to the beginning
	      ;; of indentation for the topmost-intro line that contains
	      ;; the prototype's open paren
	      ;; TBD: is the following redundant?
	      (if (= char-before-ip ?:)
		  (forward-char -1))
	      (c-backward-syntactic-ws lim)
	      ;; TBD: is the preceding redundant?
	      (if (= (preceding-char) ?:)
		  (progn (forward-char -1)
			 (c-backward-syntactic-ws lim)))
	      (if (= (preceding-char) ?\))
		  (backward-sexp 1))
	      (sql-add-syntax 'member-init-intro (sql-point 'boi))
	      ;; we don't need to add any class offset since this
	      ;; should be relative to the ctor's indentation
	      )
	     ;; CASE 5B.2: nether region after a C++ func decl
	     ;; CASE 5B.3: K&R arg decl intro
	     (t
	      (sql-add-syntax 'knr-argdecl-intro (sql-point 'boi)))
	     ))
	   ;; CASE 5C: inheritance line. could be first inheritance
	   ;; line, or continuation of a multiple inheritance
	   ((looking-at c-baseclass-key)
	    (cond
	     ;; CASE 5C.1: non-hanging colon on an inher intro
	     ((= char-after-ip ?:)
	      (c-backward-syntactic-ws lim)
	      (sql-add-syntax 'inher-intro (sql-point 'boi))
	      ;; don't add inclass symbol since relative point already
	      ;; contains any class offset
	      )
	     ;; CASE 5C.2: hanging colon on an inher intro
	     ((= char-before-ip ?:)
	      (sql-add-syntax 'inher-intro (sql-point 'boi)))
	     ;; CASE 5C.3: a continued inheritance line
	     (t
	      (c-beginning-of-inheritance-list lim)
	      (sql-add-syntax 'inher-cont (point))
	      ;; don't add inclass symbol since relative point already
	      ;; contains any class offset
	      )))
	   ;; CASE 5D: this could be a top-level compound statement or a
	   ;; member init list continuation
	   ((= char-before-ip ?,)
	    (goto-char indent-point)
	    (c-backward-syntactic-ws lim)
	    (while (and (< lim (point))
			(= (preceding-char) ?,))
	      ;; this will catch member inits with multiple
	      ;; line arglists
	      (forward-char -1)
	      (c-backward-syntactic-ws (sql-point 'bol))
	      (if (= (preceding-char) ?\))
		  (backward-sexp 1))
	      ;; now continue checking
	      (beginning-of-line)
	      (c-backward-syntactic-ws lim))
	    (cond
	     ;; CASE 5D.1: hanging member init colon
	     ((= (preceding-char) ?:)
	      (goto-char indent-point)
	      (c-backward-syntactic-ws lim)
	      (c-safe (backward-sexp 1))
	      (sql-add-syntax 'member-init-cont (sql-point 'boi))
	      ;; we do not need to add class offset since relative
	      ;; point is the member init above us
	      )
	     ;; CASE 5D.2: non-hanging member init colon
	     ((progn
		(c-forward-syntactic-ws indent-point)
		(= (following-char) ?:))
	      (skip-chars-forward " \t:")
	      (sql-add-syntax 'member-init-cont (point)))
	     ;; CASE 5D.3: perhaps a multiple inheritance line?
	     ((looking-at c-inher-key)
	      (sql-add-syntax 'inher-cont-1 (sql-point 'boi)))
	     ;; CASE 5D.4: perhaps a template list continuation?
	     ((save-excursion
		(skip-chars-backward "^<" lim)
		(= (preceding-char) ?<))
	      ;; we can probably indent it just like and arglist-cont
	      (sql-add-syntax 'arglist-cont (point)))
	     ;; CASE 5D.5: perhaps a top-level statement-cont
	     (t
	      (sql-beginning-of-statement nil lim)
	      (sql-add-syntax 'statement-cont (sql-point 'boi)))
	     ))
	   ;; CASE 5E: we are looking at a access specifier
	   ;; CASE 5F: we are looking at the brace which closes the
	   ;; enclosing nested class decl
	   ;; CASE 5H: we are at the topmost level, make sure we skip
	   ;; back past any access specifiers
	   ((progn
	      (c-backward-syntactic-ws lim)
	      (or (bobp)
		  (memq (preceding-char) '(?\; ?\}))))
	    (sql-add-syntax 'topmost-intro (sql-point 'bol)))
	   ;; CASE 5I: we are at a method definition continuation line
	   ;; CASE 5J: we are at a topmost continuation line
	   (t
	    (sql-beginning-of-statement 1 lim)
	    (sql-add-syntax 'topmost-intro-cont (sql-point 'boi)))
	   ))				; end CASE 5
	 ;; CASE 6: line is an expression, not a statement.  Most
	 ;; likely we are either in a function prototype or a function
	 ;; call argument list
	 ((/= (char-after containing-sexp) ?{)
	  (c-backward-syntactic-ws containing-sexp)
	  (cond
	   ;; CASE 6A: we are looking at the first argument in an empty
	   ;; argument list
	   ((memq char-before-ip '(?\( ?\[))
	    (goto-char containing-sexp)
	    (sql-add-syntax 'arglist-intro (sql-point 'boi)))
	   ;; CASE 6B: we are looking at the arglist closing paren
	   ((and (/= char-before-ip ?,)
		 (memq char-after-ip '(?\) ?\])))
	    (goto-char containing-sexp)
	    (sql-add-syntax 'arglist-close (sql-point 'boi)))
	   ;; CASE 6C: we are inside a conditional test clause. treat
	   ;; these things as statements
	   ((save-excursion
	     (goto-char containing-sexp)
	     (and (c-safe (progn (forward-sexp -1) t))
		  (looking-at "\\<for\\>")))
	    (sql-beginning-of-statement 1 containing-sexp)
	    (if (= char-before-ip ?\;)
		(sql-add-syntax 'statement (point))
	      (sql-add-syntax 'statement-cont (point))
	      ))
	   ;; CASE 6D: maybe a continued method call. This is the case
	   ;; when we are inside a [] bracketed exp, and what precede
	   ;; the opening bracket is not an identifier.
	   ((and (eq major-mode 'objc-mode)
		 (= (char-after containing-sexp) ?\[)
		 (save-excursion
		   (goto-char (1- containing-sexp))
		   (c-backward-syntactic-ws (sql-point 'bod))
		   (if (not (looking-at c-symbol-key))
		       (sql-add-syntax 'objc-method-call-cont containing-sexp))
		   )))
	   ;; CASE 6E: we are looking at an arglist continuation line,
	   ;; but the preceding argument is on the same line as the
	   ;; opening paren.  This case includes multi-line
	   ;; mathematical paren groupings, but we could be on a
	   ;; for-list continuation line
	   ((and (save-excursion
		   (goto-char (1+ containing-sexp))
		   (skip-chars-forward " \t")
		   (not (eolp)))
		 (save-excursion
		   (sql-beginning-of-statement)
		   (skip-chars-backward " \t([")
		   (<= (point) containing-sexp)))
	    (goto-char containing-sexp)
	    (sql-add-syntax 'arglist-cont-nonempty (sql-point 'boi)))
	   ;; CASE 6F: we are looking at just a normal arglist
	   ;; continuation line
	   (t (sql-beginning-of-statement 1 containing-sexp)
	      (c-forward-syntactic-ws indent-point)
	      (sql-add-syntax 'arglist-cont (sql-point 'boi)))
	   ))
	 (t
	  (sql-add-syntax 'default-statement (sql-point 'boi))))
	  
	(goto-char indent-point)
	(skip-chars-forward " \t")
	(if (looking-at sql-comment-start-regexp)
	    ;; we are looking at a comment. if the comment is at or to
	    ;; the right of comment-column, then all we want on the
	    ;; syntax list is comment-intro, otherwise, the
	    ;; indentation of the comment is relative to where a
	    ;; normal statement would indent
	    (if (< (current-column) comment-column)
		(sql-add-syntax 'comment-intro)
	      ;; reset syntax kludge
	      (setq sql-syntax nil)
	      (sql-add-syntax 'comment-intro)))
	;; return the syntax
	sql-syntax))))

;  (save-excursion
;    (save-restriction
;      (setq sql-syntax nil)
;      (and (buffer-syntactic-context)
;	   (sql-add-syntax (buffer-syntactic-context) (sql-point 'bopl)))
;      (back-to-indentation)
;      (and (looking-at sql-bos-regexps)
;	   (sql-add-syntax 'statement (sql-point 'boi)))
;      (and (looking-at "where")
;	   (sql-add-syntax 'where-clause (sql-point 'boi)))
;      sql-syntax)))

(defun sql-get-offset (langelem)
  ;; Get offset from LANGELEM which is a cons cell of the form:
  ;; (SYMBOL . RELPOS).  The symbol is matched against
  ;; c-offsets-alist and the offset found there is either returned,
  ;; or added to the indentation at RELPOS.  If RELPOS is nil, then
  ;; the offset is simply returned.
  (let* ((symbol (car langelem))
	 (relpos (cdr langelem))
	 (match  (assq symbol sql-offsets-alist))
	 (offset (cdr-safe match)))
    ;; offset can be a number, a function, a variable, or one of the
    ;; symbols + or -
    (cond
     ((not match)
      (if sql-strict-syntax-p
	  (error "don't know how to indent a %s" symbol)
	(setq offset 0
	      relpos 0)))
     ((eq offset '+) (setq offset sql-basic-offset))
     ((eq offset '-) (setq offset (- sql-basic-offset)))
     ((and (not (numberp offset))
	   (fboundp offset))
      (setq offset (funcall offset langelem)))
     ((not (numberp offset))
      (setq offset (eval offset)))
     )
    (+ (if (and relpos
		(< relpos (sql-point 'bol)))
	   (save-excursion
	     (goto-char relpos)
	     (current-column))
	 0)
       offset)))

(defun sql-indent-line-2 (&optional syntax)
  ;; indent the current line as SQL code. Optional SYNTAX is the
  ;; syntactic information for the current line. Returns the amount of
  ;; indentation change
  (interactive)
  (let* ((sql-syntactic-context (sql-guess-basic-syntax))
	 (pos (- (point-max) (point)))
	 (indent (apply '+ (mapcar 'sql-get-offset sql-syntactic-context)))
	 (shift-amt  (- (current-indentation) indent)))
    (and sql-echo-syntactic-information-p
	 (message "syntax: %s, indent = %d" sql-syntactic-context indent))
    (if (zerop shift-amt)
	nil
      (delete-region (sql-point 'bol) (sql-point 'boi))
      (beginning-of-line)
      (indent-to indent))
    (if (< (point) (sql-point 'boi))
	(back-to-indentation)
      ;; If initial point was within line's indentation, position after
      ;; the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	  (goto-char (- (point-max) pos)))
      )
    (run-hooks 'sql-special-indent-hook)
    shift-amt))

(defmacro sql-point (position)
  ;; Returns the value of point at certain commonly referenced POSITIONs.
  ;; POSITION can be one of the following symbols:
  ;; 
  ;; bol  -- beginning of line
  ;; eol  -- end of line
  ;; bod  -- beginning of defun
  ;; boi  -- back to indentation
  ;; ionl -- indentation of next line
  ;; iopl -- indentation of previous line
  ;; bonl -- beginning of next line
  ;; bopl -- beginning of previous line
  ;; 
  ;; This function does not modify point or mark.
  (or (and (eq 'quote (car-safe position))
	   (null (cdr (cdr position))))
      (error "bad buffer position requested: %s" position))
  (setq position (nth 1 position))
  (` (let ((here (point)))
       (,@ (cond
	    ((eq position 'bol)  '((beginning-of-line)))
	    ((eq position 'eol)  '((end-of-line)))
	    ((eq position 'bod)
	     '((beginning-of-defun)
	       ;; if defun-prompt-regexp is non-nil, b-o-d won't leave
	       ;; us at the open brace.
	       (and (boundp 'defun-prompt-regexp)
		    defun-prompt-regexp
		    (looking-at defun-prompt-regexp)
		    (goto-char (match-end 0)))
	       ))
	    ((eq position 'boi)  '((back-to-indentation)))
	    ((eq position 'bonl) '((forward-line 1)))
	    ((eq position 'bopl) '((forward-line -1)))
	    ((eq position 'iopl)
	     '((forward-line -1)
	       (back-to-indentation)))
	    ((eq position 'ionl)
	     '((forward-line 1)
	       (back-to-indentation)))
	    (t (error "unknown buffer position requested: %s" position))
	    ))
       (prog1
	   (point)
	 (goto-char here))
       ;; workaround for an Emacs18 bug -- blech! Well, at least it
       ;; doesn't hurt for v19
       (,@ nil)
       )))

;(defun sql-indent-line-2 ()
;  (let* ((context-info (sql-get-sysntactic-context-info))
;	 (context (car context-info))
;	 (indent (cdr context-info))
;	 (offset 0))
;    (save-excursion
;      (back-to-indentation)
;      (cond ((looking-at "end\\>")
;	     (if (eq context 'begin)
;		 ))))))

(defun sql-display-startup-message ()
  (interactive)
  (if (sit-for 5)
      (let ((lines sql-startup-message-lines))
	(message "SQL Mode Version %s, Copyright © 1994, 1995 Peter D. Pezaris"
		 sql-mode-version)
	(while (and (sit-for 4) lines)
	  (message (substitute-command-keys (car lines)))
	  (setq lines (cdr lines)))))
  (message ""))

(defun sql-interactive-prompt ()
  "Return a string to use as the prompt."
  (concat sql-command " [" sql-command-level "] -->"))

(defun sql-beginning-of-command-line ()
  "Goto the beginning of the current interactive line."
  (interactive)
  (beginning-of-line)
  (let* ((begin-point (point))
	 (end-point (progn (end-of-line) (point)))
	 (limit (if (> (- end-point begin-point) 6)
		    (min (progn (beginning-of-line) (forward-char 6) (point))
			 end-point)
		  end-point)))
    (beginning-of-line)
    (search-forward "> " limit t))
  (scroll-right sql-max-screen-width))

(defun sql-newline-maybe-indent ()
  "Insert a newline, and if sql-indent-after-newline is non-nil, indent."
  (interactive)
  (if (not sql-indent-after-newline)
      (newline)
    (sql-indent-line)
    (newline)
    (sql-indent-line)))

(defun sql-toggle-auto-indent ()
  "Toggle the state of the variable sql-indent-after-newline."
  (interactive)
  (if sql-indent-after-newline
      (setq sql-indent-after-newline nil)
    (setq sql-indent-after-newline t)))

(defun sql-backward-delete-char ()
  "Delete characters backward, stopping at prompt."
  (interactive)
  (let ((the-point (point)))
    (save-excursion
      (beginning-of-line)
      (if (and (looking-at "[0-9][0-9]*> ")
	       (search-forward "> " nil t))
	  (progn
	    (if (equal the-point (point))
		(beep)
	      (goto-char the-point)
	      (backward-delete-char-untabify 1)))
	(goto-char the-point)
	(backward-delete-char-untabify 1)))))

(defun sql-in-string ()
  "Return t if in a string, nil otherwise."
  (and sql-lucid (eq (buffer-syntactic-context) 'string)))

(defun sql-electric-delete (arg)
  "Deletes preceding character or whitespace.
If `sql-hungry-delete-key' is non-nil, then all preceding whitespace is
consumed.  If however an ARG is supplied, or `sql-hungry-delete-key' is
nil, or point is inside a string then the function in the variable
`sql-delete-function' is called."
  (interactive "P")
  (if (or (not sql-hungry-delete-key)
	  arg
	  (sql-in-string))
      (funcall sql-delete-function (prefix-numeric-value arg))
    (let ((here (point)))
      (skip-chars-backward " \t\n")
      (if (/= (point) here)
	  (delete-region (point) here)
	(funcall sql-delete-function 1)))))

(defun sql-previous-keyword ()
  "Return the previous keyword as a string.
See the variable `sql-keywords' for a list of keywords.
The search is bounded to the current line."
  (interactive)
  (save-excursion
    (let ((begin (save-excursion (beginning-of-line) (point))))
      (if (re-search-backward sql-keyword-regexps begin t)
	  (current-word)
	nil))))

(defun sql-previous-word (&optional count)
  "Return the word before the word at point as a string.
The search is bounded to the current line.
Optional argument COUNT specifies how many words to go backwards."
  (interactive "p")
  (save-excursion
    (let ((begin (save-excursion (beginning-of-line) (point))))
      (cond
       ((char-equal (preceding-char) ?,)
	",")
       ((char-equal (preceding-char) ?=)
	"=")
       (t
	(search-backward " " begin t)
	(cond
	 ((char-equal (preceding-char) ?,)
	  ",")
	 ((char-equal (preceding-char) ?=)
	  "=")
	 (t
	  (if (forward-word (- (or count 1)))
	      (if (< (point) begin)
		  nil
		(current-word))
	    nil))))))))

(defun sql-display-completion-context ()
  "Display the completion context at point."
  (interactive)
  (message (symbol-name (sql-get-completion-context))))
  
(defun sql-get-completion-context (&optional location)
  "Get the completion context at point, or at optional LOCATION."
  (save-excursion
    (and location
	 (goto-char location))
    (let ((previous (sql-previous-word)))
      (and previous
	   (cond
	    ((or (string-equal (downcase previous) "into")
		 (string-equal (downcase previous) "from")
		 (string-equal (downcase previous) "update")
		 (string-equal (downcase previous) "delete"))
	     'table)
	    ((or (string-equal (downcase previous) "where")
		 (string-equal (downcase previous) "set"))
	     'column)
	    ((and (string-equal (downcase previous) "by")
		  (string-equal (downcase (sql-previous-word 2)) "order"))
	     'column)
	    ((or (string-equal (downcase previous) "sp_helptext")
		 (string-equal (downcase previous) "exec"))
	     'stored-procedure)
	    ((string-equal (downcase previous) "use")
	     'database)
	    ((or (string-equal (downcase previous) "and")
		 (string-equal (downcase previous) "or"))
	     (save-excursion
	       (re-search-backward sql-keyword-regexps nil t 2)
	       (forward-word 1)
	       (forward-char 1)
	       (sql-get-completion-context)))
	    ((string-equal (downcase previous) ",")
	     (save-excursion
	       (re-search-backward sql-keyword-regexps nil t 1)
	       (forward-word 2)
	       (sql-get-completion-context)))
	    ((string-equal (downcase previous) "=")
	     'comparator)
	    ((null previous)
	     'keyword)
	    (t
	     (if sql-lucid
		 (or (buffer-syntactic-context) 'keyword)
	       'keyword)))))))

(defun sql-complete-word-maybe (arg)
  "Complete the word at point, or insert a tab.
If there is only whitespace between the beginning of the line and
point, insert a tab character (or whatever key this function is mapped
to), otherwise complete the word."
  (interactive "P")
  (let ((complete-it nil)
	(first-point (point)))
    (save-excursion
      (back-to-indentation)
      (if (< (point) first-point)
	  (setq complete-it t)))
    (if complete-it
	(let ((context (sql-get-completion-context)))
	  (cond
	   ((eq context 'keyword)
	    (if (not sql-keyword-list)
		(sql-get-keywords))
	    (sql-complete sql-keyword-list))
	   ((eq context 'table)
	    (if (not sql-table-list)
		(sql-get-tables))
	    (sql-complete sql-table-list))
	   ((eq context 'column)
	    (let ((table-name (sql-get-table-name)))
	      (if (not (assoc table-name sql-column-list))
		  (sql-get-columns))
	      (sql-complete (cdr (assoc table-name sql-column-list)))))
	   ((eq context 'stored-procedure)
	    (if (not sql-stored-procedure-list)
		(sql-get-stored-procedures))
	    (sql-complete sql-stored-procedure-list))
	   ((eq context 'database)
	    (if (not sql-database-list)
		(sql-get-databases))
	    (sql-complete sql-database-list))
	   ((eq context 'comparator)
	    (message "Unable to complete (comparator)."))
;	    (let ((column-name (sql-get-column-name)))
;	      (if (not (assoc column-name sql-comparator-list))
;		  (sql-get-comparators))
;	      (sql-complete (cdr (assoc column-name sql-comparator-list)))))
	   (t
	    (message "Unknown context."))))
      ; insert a tab
      (self-insert-command (prefix-numeric-value arg)))))

(defun sql-complete (completion-table)
  "Complete the word at point based on COMPLETION-TABLE."
  (let* ((end (point))
	 (begin (save-excursion (search-backward " " nil t) (+ 1 (point))))
;	 (partial (current-word))
	 (partial (if (or (eq (preceding-char) ?,)
			  (eq (preceding-char) ?=))
		      ""
		    (buffer-substring begin end)))
	 (complete (try-completion partial completion-table))
	 (all-complete (all-completions partial completion-table)))
    (cond
     ((eq complete t)
      (insert " ")
      (message "Sole completion."))
     ((eq complete nil)
      (message "No match.")
      (and sql-noisy
	   sql-xemacs
	   (assoc 'no-completion sound-alist)
	   (play-sound 'no-completion)))
     (t
      (if (string-equal complete partial)
	  (sql-dynamic-list-completions all-complete)
;	(delete-region begin end)
	(backward-kill-word 1)
	(insert complete)
	(if (equal 1 (length all-complete))
	    (progn
	      (insert " ")
	      (message "Sole completion."))
	  (if (assoc complete completion-table)
	      (message "Complete, but not unique.")
	    (message "Partial Completion."))))))))

(defun sql-dynamic-list-completions (completions)
  "List in help buffer sorted COMPLETIONS.
Typing SPC flushes the help buffer."
  (let ((conf (current-window-configuration)))
    (with-output-to-temp-buffer " *Completions*"
      (display-completion-list (sort completions 'string-lessp)))
    (set-buffer " *Completions*")
    (goto-char (point-min))
    (set-syntax-table sql-mode-syntax-table)
    (forward-line 1)
    (skip-chars-forward "[ \t\n]")
    (and sql-xemacs
	 (let ((start (point)))
	   (while (forward-word 1)
	     (let ((e (make-extent start (point))))
	       (set-extent-property e 'highlight t)
	       (skip-chars-forward "[ \t\n]")
	       (setq start (point))))))
    (sql-restore-window-config conf)))

(defun sql-restore-window-config (conf &optional message)
  (message "%s" (or message
		    "Press `s' to save completions, anything else to flush."))
  (sit-for 0)
  (setq sql-temp-string nil)
  (if (if (fboundp 'next-command-event)
          ;; lemacs
          (let ((ch (next-command-event)))
            (if (eq (event-to-character ch) ?s)
                t
	      (progn (if (and (button-event-p ch) (eq (event-button ch) 2))
			 (setq sql-temp-string (save-excursion
						 (mouse-set-point ch)
						 (current-word)))
		       (setq unread-command-event ch))
		     nil)))
	;; v19 FSFmacs
	(let ((ch (read-event)))
	  (if (eq ch ?s)
	      t
	    (progn (setq unread-command-events (list ch))
		   nil))))
      (message nil)
    (set-window-configuration conf)
    (and sql-temp-string
	 (progn
	   (or (eq (preceding-char) ? )
	       (eq (preceding-char) ?,)
	       (eq (preceding-char) ?=)
	       (backward-kill-word 1))
	   (insert sql-temp-string " ")))
    (message nil)))

(defun sql-split-window-horizontally ()
  "Split the window horizontally at the current column."
  (interactive)
  (let* ((window (split-window-horizontally (+ 3 (- (current-column)
						    (window-hscroll))))))
    (setq sql-linked-windows (cons window sql-linked-windows))
    (other-window 1)
    (set-window-hscroll (selected-window) (current-column))))

(defun sql-unsplit-window-horizontally ()
  "Unsplit the window horizontally."
  (interactive)
  (let ((window (selected-window)))
    (if (member window sql-linked-windows)
	(setq sql-linked-windows (delete window sql-linked-windows))))
  (delete-window))

(defun sql-grow-window-horizontally ()
  (interactive)
  (shrink-window-horizontally -1))

(defun sql-get-tables ()
  "Set the variable `sql-table-list' to the tables in the current database."
  (interactive)
  (let* ((u user)
	 (s server)
	 (p password)
	 (d database)
	 (old-buffer (current-buffer))
	 (buffer (generate-new-buffer " SQL-TEMP")))
    (message "Creating table completion list... (querying database...)")
    (set-buffer buffer)
    (if d (insert "use " d "\ngo\n"))
    (insert "select name from sysobjects where type in (\"U\", \"S\") "
	    "order by name\ngo\n/*ENDENDEND*/\n")
    (if sql-batch-command-switches
	(call-process-region (point-min) (point-max) sql-command nil buffer nil
			     (concat "-w" (int-to-string sql-max-screen-width))
			     (concat "-U" u) (concat "-P" p)
			     (concat "-S" s)
			     sql-batch-command-switches)
      (call-process-region (point-min) (point-max) sql-command nil buffer t 
			   (concat "-w" (int-to-string sql-max-screen-width))
			   (concat "-U" u) (concat "-P" p)
			   (concat "-S" s)))
    (message "Creating table completion list... (parsing results...)")
    (goto-char (point-min))
    (delete-region (point-min) (save-excursion (search-forward "/*ENDENDEND*/")
					       (point)))
    (kill-line 3) ; was 4
    (and (looking-at sql-error-regexp)
	 (progn
	   (kill-buffer buffer)
	   (error "Error parsing tables.")))
    (goto-char (point-max))
    (forward-line -1)
    (kill-line 1)
    (goto-char (point-min))
    (while (search-forward " " nil t)
      (replace-match "" nil t))
    (goto-char (point-min))
    (let ((new-table-list nil))
      (while (not (eobp))
	(setq new-table-list
	      (cons (cons (buffer-substring (point) (save-excursion
						      (end-of-line)
						      (point)))
			  "1")
		    new-table-list))
	(kill-line 1))
      (kill-buffer buffer)
      (set-buffer old-buffer)
      (setq sql-table-list (cdr new-table-list)))
    (message "Creating table completion list... done")))

(defun sql-get-databases ()
  "Set the variable `sql-database-list' to the databases on the current server."
  (interactive)
  (let* ((u user)
	 (s server)
	 (p password)
	 (d database)
	 (old-buffer (current-buffer))
	 (buffer (generate-new-buffer " SQL-TEMP")))
    (message "Creating database completion list... (querying database...)")
    (set-buffer buffer)
    (if d (insert "use " d "\ngo\n"))
    (insert "sp_helpdb\ngo\n/*ENDENDEND*/\n")
    (if sql-batch-command-switches
	(call-process-region (point-min) (point-max) sql-command nil buffer nil
			     (concat "-w" (int-to-string sql-max-screen-width))
			     (concat "-U" u) (concat "-P" p)
			     (concat "-S" s)
			     sql-batch-command-switches)
      (call-process-region (point-min) (point-max) sql-command nil buffer t 
			   (concat "-w" (int-to-string sql-max-screen-width))
			   (concat "-U" u) (concat "-P" p)
			   (concat "-S" s)))
    (message "Creating database completion list... (parsing results...)")
    (goto-char (point-min))
    (delete-region (point-min) (save-excursion (search-forward "/*ENDENDEND*/")
					       (point)))
    (kill-line 3) ; was 4
    (and (looking-at sql-error-regexp)
	 (progn
	   (kill-buffer buffer)
	   (error "Error parsing databases.")))
    (goto-char (point-max))
    (forward-line -1)
    (kill-line 1)
    (goto-char (point-min))
;    (while (search-forward " " nil t)
;      (replace-match "" nil t))
;    (goto-char (point-min))
    (let ((new-database-list nil))
      (while (not (eobp))
	(setq new-database-list (cons (cons (current-word) "1") new-database-list))
	(kill-line 1))
      (kill-buffer buffer)
      (set-buffer old-buffer)
      (setq sql-database-list (cdr new-database-list)))
    (message "Creating database completion list... done")))

(defun sql-get-stored-procedures ()
  "Set the variable `sql-stored-procedure-list' to the stored procedures
in the current database."
  (interactive)
  (let* ((u user)
	 (s server)
	 (p password)
	 (d database)
	 (old-buffer (current-buffer))
	 (buffer (generate-new-buffer " SQL-TEMP")))
    (message "Creating stored procedure completion list... (querying database...)")
    (set-buffer buffer)
    (if d (insert "use " d "\ngo\n"))
    (insert "select name from sysobjects where type = \"P\" order by name\ngo\n/*ENDENDEND*/\n")
    (if sql-batch-command-switches
	(call-process-region (point-min) (point-max) sql-command nil buffer nil
			     (concat "-w" (int-to-string sql-max-screen-width))
			     (concat "-U" u) (concat "-P" p)
			     (concat "-S" s)
			     sql-batch-command-switches)
      (call-process-region (point-min) (point-max) sql-command nil buffer t
			   (concat "-w" (int-to-string sql-max-screen-width))
			   (concat "-U" u) (concat "-P" p)
			   (concat "-S" s)))
    (message "Creating stored procedure completion list... (parsing results...)")
    (goto-char (point-min))
    (delete-region (point-min) (save-excursion (search-forward "/*ENDENDEND*/")
					       (point)))
    (kill-line 1) ; was 4
    (and (looking-at sql-error-regexp)
	 (progn
	   (kill-buffer buffer)
	   (error "Error parsing stored procedures.")))
;    (kill-line 4)
    (goto-char (point-max))
    (forward-line -2)
    (kill-line 2)
    (goto-char (point-min))
    (while (search-forward " " nil t)
      (replace-match "" nil t))
    (goto-char (point-min))
    (let ((new-stored-procedure-list nil))
      (while (not (eobp))
	(setq new-stored-procedure-list
	      (cons (cons (buffer-substring (point) 
					    (save-excursion
					      (end-of-line)
					      (point)))
			  "1")
		    new-stored-procedure-list))
	(kill-line 1))
      (kill-buffer buffer)
      (set-buffer old-buffer)
      (setq sql-stored-procedure-list (cdr new-stored-procedure-list)))
    (message "Creating stored procedure completion list... done")))

(defun sql-get-table-name ()
  "Get the name of the table to do the completion."
  (save-excursion
    (re-search-backward sql-table-prefix-regexp nil t)
    (forward-word 2)
    (current-word)))

(defun sql-get-columns (&optional table)
  "Set the variable `sql-column-list' to the columns in the current database.

If optional TABLE is non-nill, use that string as the table to get the columns
from.  Otherwise, scan backwards looking for something that looks like a table
name."
  (interactive)
  (let* ((u user)
	 (s server)
	 (p password)
	 (d database)
	 (old-buffer (current-buffer))
	 (buffer (generate-new-buffer " SQL-TEMP"))
	 (table-name (or table (sql-get-table-name))))
    (message "Creating column completion list... (querying database...)")
    (set-buffer buffer)
    (if d (insert "use " d "\ngo\n"))
    (insert "select name, type from syscolumns where id = object_id(\""
	    table-name
	    "\")\ngo\n/*ENDENDEND*/")
    (if sql-batch-command-switches
	(call-process-region (point-min) (point-max) sql-command nil buffer nil
			     (concat "-w" (int-to-string sql-max-screen-width))
			     (concat "-U" u) (concat "-P" p)
			     (concat "-S" s)
			     sql-batch-command-switches)
      (call-process-region (point-min) (point-max) sql-command nil buffer t 
			   (concat "-w" (int-to-string sql-max-screen-width))
			   (concat "-U" u) (concat "-P" p) 
			   (concat "-S" s)))
    (message "Creating column completion list... (parsing results...)")
    (goto-char (point-min))
    (delete-region (point-min) (save-excursion (search-forward "/*ENDENDEND*/")
					       (point)))
    (kill-line 2)
    (and (looking-at sql-error-regexp)
	 (progn
	   (kill-buffer buffer)
	   (error "Error parsing columns.")))
    (goto-char (point-min))
    (set-syntax-table sql-mode-syntax-table)
    (let ((new-column-list nil))
      (while (not (looking-at "\n"))
	(let* ((column (current-word))
	       (type (save-excursion (forward-word 2)
				     (current-word))))
	  (setq new-column-list
		(cons (cons column (cond
				    ((member type sql-string-column-types)
					1)
				    ((member type sql-ignore-column-types)
					2)
				    (t
				      0)))
		       new-column-list))
	   (forward-line 1)
	   (beginning-of-line)))
	(kill-buffer buffer)
	(set-buffer old-buffer)
	(setq sql-column-list (cons (cons table-name new-column-list)
				    sql-column-list)))
      (message "Creating column completion list... done")))

;	       (end (progn (search-forward " " nil t) (- (point) 1))))
;	  (setq new-column-list (cons (cons (buffer-substring beginning end)
;					    "1")
;				      new-column-list))))
;      (kill-buffer buffer)
;      (set-buffer old-buffer)
;      (setq sql-column-list (cons (cons table-name new-column-list)
;				  sql-column-list)))

(defun sql-clear-cached-data ()
  "Clear the value of the variable `sql-table-list', `sql-column-list' and
`sql-stored-procedure-list'."
  (interactive)
  (setq sql-table-list nil)
  (setq sql-column-list nil)
  (setq sql-stored-procedure-list nil))

(defun sql-get-keywords ()
  "Set the variable `sql-keyword-list' to current sql keywords."
  (let ((keys sql-keywords))
    (while keys
      (setq sql-keyword-list (cons (cons (car keys) "1") sql-keyword-list))
      (setq keys (cdr keys)))))

(defun sql-set-database (new-database)
  "Set the database to use in the current buffer."
  (interactive (list (progn
		       (or sql-database-list (sql-get-databases))
		       (completing-read "Database: " sql-database-list))))
  (if (string-equal new-database "")
      (sql-reset-database)
    (sql-clear-cached-data)
    (setq database new-database)
    (setq database-name (concat "   " new-database))))

(defun sql-reset-database ()
  "Set the database to use in the current buffer to nil."
  (interactive)
  (sql-clear-cached-data)
  (setq database nil)
  (setq database-name nil))

(defun sql-abort ()
  "Abort the current query."
  (interactive)
  (and sql-process (kill-process sql-process))
  (call-interactively 'keyboard-quit))

(defun sql-goto-batch-buffer ()
  (interactive)
  (if (not (eq major-mode 'sql-batch-mode))
      (let ((m-buffer sql-matching-buffer))
	(set-buffer m-buffer)
	(pop-to-buffer m-buffer nil sql-screen)
	(if (not (eq major-mode 'sql-batch-mode))
	    (error "Can't find matching batch buffer.")))))

(defun sql-goto-results-buffer ()
  (interactive)
  (if (not (eq major-mode 'sql-results-mode))
      (let ((m-buffer sql-matching-buffer))
	(set-buffer m-buffer)
	(pop-to-buffer m-buffer nil sql-screen)
	(if (not (eq major-mode 'sql-results-mode))
	    (error "Can't find matching results buffer.")))))

(defun sql-go ()
  (interactive)
  (sql-goto-batch-buffer)
  (cond
   ((eq sql-preferred-evaluation-method 'foreground)
	(sql-evaluate-buffer nil))
   ((eq sql-preferred-evaluation-method 'background)
	(sql-evaluate-buffer-asyncronous nil))))

(defun sql-toolbar-previous-history ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-previous-history))

(defun sql-toolbar-next-history ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-next-history))

(defun sql-toolbar-previous-global-history ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-previous-global-history))

(defun sql-toolbar-next-global-history ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-next-global-history))

(defun sql-sp-lock ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-goto-history 0)
  (insert "sp_lock\n")
  (sql-evaluate-buffer nil))

(defun sql-sp-who ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-goto-history 0)
  (insert "sp_who\n")
  (sql-evaluate-buffer nil))

(defun sql-sp-what ()
  (interactive)
  (sql-goto-batch-buffer)
  (sql-goto-history 0)
  (insert "sp_what\n")
  (sql-evaluate-buffer nil))

(defun sql-print-buffer ()
  "Print the current buffer, using `sql-print-buffer-tiled' if appropriate."
  (interactive)
  (cond
   ((eq major-mode 'sql-interactive-mode)
    (sql-print-buffer-tiled))
   ((eq major-mode 'sql-results-mode)
    (sql-print-buffer-tiled))
   (t
    (let ((lpr-switches (or sql-print-switches lpr-switches))
	  (enscript-switches (or sql-print-switches enscript-switches)))
      (if (eq sql-print-command 'enscript-buffer)
	  (enscript-buffer nil)
	(funcall sql-print-command))))))

(defun sql-insert-sp (&optional bypass-cpp)
  "Insert a stored procedure from a file into the current buffer.
The file is run throught the C preprocessor, and then ` ;' strings are
replaced with newlines.

With prefix arg bypass the C preprocessor step.  If the variable
`sql-bypass-cpp' is non-nil, bypass the C preprocessor step.

The file is then inserted into the current sql-batch-mode buffer."
  (interactive "P")
  (let ((sql-holdup-stored-procedure t)
	(sql-bypass-cpp bypass-cpp))
    (call-interactively 'sql-load-sp)))

(defun sql-load-sp (filename &optional bypass-cpp)
  "Load a stored procedure from a file.
The file is run throught the C preprocessor, and then ` ;' strings are
replaced with newlines.

With prefix arg bypass the C preprocessor step.  If the variable
`sql-bypass-cpp' is non-nil, bypass the C preprocessor step.

The file is then loaded into the current sql-batch-mode buffer, and
sql-evaluate-buffer is called to load the stored procedure.

If sql-holdup-stored-procedure is non-nil, the buffer is not evaluated."
  (interactive "fStored Procedure file name: 
P")
  (if (not (file-readable-p filename))
      (error "Could not read file %s." filename)
    (sql-goto-batch-buffer)
    (setq filename (expand-file-name filename))
    (if (or bypass-cpp sql-bypass-cpp)
	(insert-file filename)
      (let* ((original-buffer (current-buffer))
	     (temp-buffer (get-buffer-create " SQL-TEMP"))
	     (prompt (concat "cpp "
			     (or sql-default-cpp-switches
				 "-B -C -DSQL -P ")))
	     (cpp-switches (read-shell-command
			    "Run the C preprocessor like this: "
			    prompt))
	     (default-directory (file-name-directory filename)))
	(call-process shell-file-name nil temp-buffer nil
		      "-c" (concat cpp-switches filename))
	(set-buffer temp-buffer)
;	(sql-insert-newlines)
	(let ((contents (buffer-string)))
	  (set-buffer original-buffer)
	  (kill-buffer temp-buffer)
	  (sql-goto-history 0)
	  (insert contents))))
    (goto-char (point-min))
    (or sql-holdup-stored-procedure
	(let ((sql-confirm-changes nil))
	  (sql-evaluate-buffer nil)))))

(defun sql-new-query ()
  "Clear the batch buffer and results buffer contents."
  (interactive)
  (sql-goto-batch-buffer)
  (sql-goto-history 0))

(defun sql-insert-file ()
  "Insert the contents of a file into the batch buffer."
  (interactive)
  (sql-goto-batch-buffer)
  (sql-goto-history 0)
  (call-interactively 'insert-file))

;(defun sql-in-results-buffer (body)
;  "Switch to results buffer, eval body, then switch back."
;  (let ((this-buffer (current-buffer))
;	(matching-buffer sql-matching-buffer))
;    (if (eq major-mode 'sql-batch-mode)
;	(progn
;	  (set-buffer matching-buffer)
;	  (eval body)
;	  (set-buffer this-buffer))
;      (eval body))))

;(defun sql-dynamic-scroll-up (event)
;  "Scroll up by a line, a screen, or to top.
;Click and hold to scroll a line at a time.
;Single click to scroll by a screen.
;Double click to scroll to top."
;  (interactive "e")
;  (let* ((this-time (event-timestamp event))
;	 (difference (- this-time sql-last-scroll-time)))
;    (message "Difference %d" difference)
;    (sit-for 3)
;    (sql-in-results-buffer
;     (if (> 300 difference)
;	 (sql-end-of-buffer)
;       (sql-scroll-up)))
;    (setq sql-last-scroll-time (event-timestamp event))))

;(defun sql-dynamic-scroll-down (event)
;  "Scroll down by a line, a screen, or to top.
;Click and hold to scroll a line at a time.
;Single click to scroll by a screen.
;Double click to scroll to top."
;  (interactive "e")
;  (let* ((this-time (event-timestamp event))
;	 (difference (- this-time sql-last-scroll-time)))
;    (sql-in-results-buffer
;     (if (> 300 difference)
;	 (sql-beginning-of-buffer)
;       (sql-scroll-down)))
;    (setq sql-last-scroll-time (event-timestamp event))))

(defun sql-toggle-font-lock (mode)
  "Toggle the state of font-locking for MODE."
  (interactive)
  (if (eq sql-font-lock-buffers 'all)
      (setq sql-font-lock-buffers (list 'sql-mode 
					'sql-batch-mode
					'sql-interactive-mode
					'sql-results-mode)))
  (if (member mode sql-font-lock-buffers)
      (setq sql-font-lock-buffers (delete mode sql-font-lock-buffers))
    (setq sql-font-lock-buffers (cons mode sql-font-lock-buffers))))

(defun sql-beginning-of-buffer ()
  "Move point to beginning of buffer, keeping header text at top of window."
  (interactive)
  (push-mark)
  (sql-remove-header)
  (goto-char (point-min))
  (sql-beginning-of-row)
  (sql-insert-header))

(defun sql-end-of-buffer ()
  "Move point to end of buffer, keeping header text at top of window."
  (interactive)
  (push-mark)
  (goto-char (point-max))
  (sql-beginning-of-row)
  (sql-recenter))

(defun sql-scroll-down-one-line ()
  "Scroll the text of the current window downward one line."
  (interactive)
  (let ((previous scroll-previous-lines))
    (sql-scroll-down 1)
    (setq scroll-previous-lines previous)))
   
(defun sql-scroll-up-one-line ()
  "Scroll the text of the current window upward one line."
  (interactive)
  (let ((previous scroll-previous-lines))
    (sql-scroll-up 1)
    (setq scroll-previous-lines previous)))
   
(defun sql-scroll-up (&optional lines)
  "Scroll up."
  (interactive)
  (if (equal (point-max) (window-end))
      (error "End of buffer")
    (sql-remove-header)
    (scroll-up-in-place lines)
    (sql-insert-header (window-start))))

(defun sql-scroll-down (&optional lines)
  (interactive)
  (if (equal 1 (window-start))
      (message "Beginning of buffer")
    (sql-remove-header)
    (scroll-down-in-place lines)
    (sql-insert-header (window-start))))

(defun sql-move-header-toggle ()
  "Toggle the moving of headers withing the results buffers."
  (interactive)
  (if sql-move-headers
      (message "Move headers: inactive.")
    (message "Move headers: active."))
  (setq sql-move-headers (not sql-move-headers)))

(defun sql-remove-header ()
  "Remove the header of the results buffer from the top of the window."
  (interactive)
  (and sql-global-move-headers
       sql-move-headers
       sql-header-text
       (save-excursion
	 (let ((marking-changes sql-marking-changes))
	   (sql-stop-marking-changes)
	   (goto-char (point-min))
	   (while (search-forward sql-header-text nil t)
	     (replace-match "" nil t))
	   (if marking-changes
	       (sql-start-marking-changes))
	   (match-beginning 0)))))
  
(defun sql-insert-header (&optional location)
  "Insert the header of the results buffer at point, or at optional LOCATION."
  (interactive)
  (and sql-global-move-headers
       sql-move-headers
       sql-header-text
       (save-excursion
	 (let ((current-point (or location (point)))
	       (marking-changes sql-marking-changes))
	   (sql-stop-marking-changes)
	   (goto-char current-point)
	   (beginning-of-line)
	   (insert sql-header-text)
	   (if marking-changes
	       (sql-start-marking-changes))))))

(defun sql-insert-gos ()
  "Inserts `go' statements between each apparent block of SQL code.
Good for making a SQL script program out of plain SQL."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (forward-line 1)
      (if (and (looking-at "[a-z]") (not (looking-at "go")))
	  (insert "go\n")))
    (insert "go\n")))

(defun sql-insert-semi-colons ()
  "Inserts `;'s between each apparent block of SQL code.
Good for making a SQL script program out of plain SQL."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (forward-line 1)
      (if (and (looking-at "[a-z]") (save-excursion
				      (forward-char -2)
				      (not (looking-at ";"))))
	  (progn
	    (forward-char -1)	    
	    (insert ";")
	    (forward-char 1))))
    (forward-char -1)
    (insert ";")))

(defun sql-set-interfaces-file-name ()
  "Determine where the interfaces file is, if possible."
  (let ((sybase (getenv "SYBASE"))
	(sybase-home (expand-file-name "~sybase"))
	(interfaces "/interfaces"))
    (cond ((file-readable-p (concat sybase interfaces))
	   (setq sql-interfaces-file-name (concat sybase interfaces)))
	  ((file-readable-p (concat sybase-home interfaces))
	   (setq sql-interfaces-file-name (concat sybase-home interfaces)))
	  (t (setq sql-interfaces-file-name nil))))
  sql-interfaces-file-name)

(defun sql-read-interfaces-file (&optional error-message)
  "Read and parse the interfaces file specifiled by `sql-interfaces-file-name'."
  (if (and (not sql-interfaces-file-name)
	   (not (sql-set-interfaces-file-name)))
      (if error-message
	  (error "Could not find the interfaces file.")
	(message "Could not find the interfaces file.")
	(sit-for 2))
    (message "Reading interfaces file %s..." sql-interfaces-file-name)
    (let ((interfaces-buffer (find-file-noselect sql-interfaces-file-name t)))
      (set-buffer interfaces-buffer)
      ; process the lines one at a time
      (while (not (eobp))
	(back-to-indentation)
	(cond ((looking-at "query ")
	       nil) ;(add-to-hosts))
	      ((looking-at "master ")
	       nil)
	      ((looking-at "console ")
	       nil)
	      ((looking-at "debug ")
	       nil)
	      ((looking-at "trace ")
	       nil)
	      ((looking-at "#")
	       nil)
	      ((looking-at "\n")
	       nil)
	      ((equal (current-column) 0)
	       (if (not (member (cons (current-word) 1) sql-server-table))
		   (setq sql-server-table
			 (cons (cons (current-word) 1) sql-server-table))))
	      (t
	       (message "Unable to parse line %d in interfaces file"
			(count-lines (point-min) (point)))
	       (sit-for 1)))
	(forward-line 1))
      (kill-buffer interfaces-buffer))
    (message "Reading interfaces file %s... done" sql-interfaces-file-name)))

(defun skip-whitespace ()
  "Search forward for the first character that isn't a SPACE, TAB or NEWLINE."
  (interactive)
  (while (looking-at "[ \t\n]")
    (forward-char 1)))

(defun sql-set-sybase ()
  "Set the value of the SYBASE environment variable.
The value is read from the minibuffer."
  (interactive)
  (let* ((old-sybase (getenv "SYBASE"))
	 (prompt "Value for SYBASE environment variable")
	 (prompt2 (if old-sybase
		      (format " (old value = '%s'): " old-sybase)
		    ": ")))
    (setenv "SYBASE" (read-from-minibuffer (concat prompt prompt2)))
    (sql-read-interfaces-file)))

(defun sql-set-variable (variable &optional number-only)
  "Set the value of a sql variable."
  (interactive)
  (if (symbolp variable)
      (let* ((prompt (format "New value for %s (currently %s): "
			     (symbol-name variable)
			     (symbol-value variable)))
	     (response (read-from-minibuffer prompt nil))
	     (new-value (if number-only
			    (string-to-int response)
			  response)))
	(if response
	    (set variable new-value)))))
  
(defun sql-save-current-options ()
  "Saves the current settings of the `Options' menu to your `.sql-mode' file."
  (interactive)
  (message "Saving current options to ~/.sql-mode...")
  (let ((output-buffer (find-file-noselect
			(expand-file-name
			 (concat "~" init-file-user "/.sql-mode"))))
	output-marker)
    (save-excursion
      (set-buffer output-buffer)

      ;; Find and delete the previously saved data, and position to write.

      (goto-char (point-min))
      (if (re-search-forward "^;*\n;; SQL Options Menu Settings ;;\n"
			     nil 'move)
	  (let ((p (match-beginning 0)))
	    (goto-char p)
	    (or (re-search-forward
		 "^;; END Options Menu Settings ;;\n;*\n"
		 nil t)
		(error "can't find END of saved state in .sql-mode"))
	    (delete-region p (match-end 0)))
	(goto-char (point-max))
	(insert "\n"))
      (setq output-marker (point-marker))

    ;; run with current-buffer unchanged so that variables are evaluated in
    ;; the current context, instead of in the context of the ".sql-mode"
    ;; buffer.

    (let ((print-readably t)
	  (print-escape-newlines t)
	  (standard-output output-marker))
      (princ ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n")
      (princ ";; SQL Options Menu Settings ;;\n") 
      (princ ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n")
      (princ "(cond\n")
      (princ " ((and (string-match \"Lucid\" emacs-version)\n")
      (princ "       (boundp 'emacs-major-version)\n")
      (princ "       (= emacs-major-version 19)\n")
      (princ "       (>= emacs-minor-version 10))\n")
      (mapcar #'(lambda (var)
;      (mapcar '(lambda (var)
		  (princ "  ")
		  (if (symbolp var)
		      (prin1 (list 'setq var
				   (let ((val (symbol-value var)))
				     (if (or (memq val '(t nil))
					     (and (not (symbolp val))
						  (not (listp val))))
					 val
				       (list 'quote val)))))
		    (setq var (eval var))
		    (cond ((eq (car-safe var) 'progn)
			   (while (setq var (cdr var))
			     (prin1 (car var))
			     (princ "\n")
			     (if (cdr var) (princ "  "))))
			  (var
			   (prin1 var))))
		  (if var (princ "\n")))
	      sql-options-menu-saved-forms)
      (princ "  ))\n")
      (princ ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n")
      (princ ";; END Options Menu Settings ;;\n") 
      (princ ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n"))
    (set-marker output-marker nil)
    (save-excursion
      (set-buffer output-buffer)
      (save-buffer)))
  (popup-dialog-box
   '("
I have added some lines to the file ~/.sql-mode in order
to save the options you have selected.

Some changes may not take affect until you re-start emacs.
"
     ["OK"	'sql-no-op	t]))
  (message "Saving current options to ~/.sql-mode... done")))

(defun sql-determine-video-type ()
  "Guess at a value for the variable `sql-video-type'.

This function does much better under XEmacs as opposed to FSF emacs."
  (let ((color (if sql-lucid (x-color-display-p)
		 (x-display-color-p))))
    (setq sql-video-type
	  (if (not color)
	      'monochrome
	    (cond
	     ((and sql-lucid
		   (<= emacs-major-version 19)
		   (< emacs-minor-version 12))
	      ;; `pixel-name' is `color-name' in modern XEmacsen.
	      (if (string-equal (pixel-name (face-background 'default))
				"black")
		  'inverse
		'regular))
	     (sql-lucid
	      'inverse)
	     (t
	      'regular))))))

(defun sql-setup-font-lock ()
  "Set up faces etc. for font-lock-mode."
  (if (not sql-font-lock-buffers)
      ()
    (require 'font-lock)
    (or sql-video-type (sql-determine-video-type))
    (copy-face 'default 'sql-query-face)
    (copy-face 'default 'sql-set-face)
    (copy-face 'default 'sql-special-face)
    (copy-face 'default 'sql-conjunction-face)
    (copy-face 'default 'sql-sysadm-face)
    (copy-face 'default 'sql-aggregate-face)
    (copy-face 'default 'sql-prompt-face)
    (make-face-bold 'sql-prompt-face)
    (copy-face 'default 'sql-results-face)
    (copy-face 'default 'sql-changed-area-face)
    (copy-face 'default 'sql-changed-line-face)
    (cond
     ((eq sql-video-type 'regular)
      (set-face-foreground 'sql-query-face "indianred")
      (set-face-foreground 'sql-set-face "mediumseagreen")
      (set-face-foreground 'sql-special-face "magenta")
      (set-face-foreground 'sql-conjunction-face "blue")
      (set-face-foreground 'sql-sysadm-face "red")
      (set-face-foreground 'sql-aggregate-face "forestgreen")
      (set-face-foreground 'sql-prompt-face "darkgreen")
      (set-face-foreground 'sql-results-face "blue")
      (set-face-foreground 'sql-changed-area-face "green")
      (set-face-background 'sql-changed-area-face "grey75")
      (set-face-foreground 'sql-changed-line-face "blue")
      (set-face-background 'sql-changed-line-face "grey75"))
	 
     ((eq sql-video-type 'inverse)
      (set-face-foreground 'sql-query-face "#00ffff")
      (set-face-foreground 'sql-set-face "yellow")
      (set-face-foreground 'sql-special-face "green")
      (set-face-foreground 'sql-conjunction-face "magenta")
      (set-face-foreground 'sql-sysadm-face "red")
      (set-face-foreground 'sql-aggregate-face "orange")
      (set-face-foreground 'sql-prompt-face "tan")
      (set-face-foreground 'sql-results-face "yellow")
      (set-face-foreground 'sql-changed-area-face "green")
      (set-face-background 'sql-changed-area-face "grey35")
      (set-face-foreground 'sql-changed-line-face "yellow")
      (set-face-background 'sql-changed-line-face "grey35"))

     ((eq sql-video-type 'monochrome)
      (make-face-italic 'sql-query-face)
      (make-face-bold-italic 'sql-set-face)
      (set-face-underline-p 'sql-special-face t)
      (make-face-italic 'sql-conjunction-face)
      (make-face-bold 'sql-sysadm-face)
;	  (set-face-foreground 'sql-aggregate-face "orange")
;	  (set-face-foreground 'sql-prompt-face "tan")
;	  (set-face-foreground 'sql-results-face "yellow")
      (set-face-underline-p 'sql-changed-area-face t)
      (make-face-italic 'sql-changed-area-face t)
      (set-face-underline-p 'sql-changed-line-face t)))

    (make-face-bold 'sql-prompt-face)

    (defvar sql-mode-font-lock-keywords
      '(("\\<\\(select\\|from\\|where\\|tran\\|transaction\\|commit\\|group\\|exec\\|execute\\|readtext\\|rollback\\|compute\\|union\\|by\\|order\\|having\\|SELECT\\|FROM\\|WHERE\\|TRAN\\|TRANSACTION\\|COMMIT\\|GROUP\\|EXEC\\|EXECUTE\\|READTEXT\\|ROLLBACK\\|COMPUTE\\|UNION\\|BY\\|ORDER\\|HAVING\\)\\>" 1 sql-query-face)
	("\\<\\(set\\|update\\|delete\\|insert\\|into\\|writetext\\|values\\|SET\\|UPDATE\\|DELETE\\|INSERT\\|INTO\\|WRITETEXT\\|VALUES\\)\\>" 1 sql-set-face)
	("\\<\\(go\\|use\\|null\\|GO\\|USE\\|NULL\\)\\>" 1 sql-special-face)
	("\\<\\(begin\\|end\\|else\\|if\\|goto\\|break\\|continue\\|raiserror\\|waitfor\\|and\\|or\\|not\\|in\\|is\\|declare\\|print\\|return\\|exists\\|like\\|BEGIN\\|END\\|ELSE\\|IF\\|GOTO\\|BREAK\\|CONTINUE\\|RAISERROR\\|WAITFOR\\|AND\\|OR\\|NOT\\|IN\\|IS\\|DECLARE\\|PRINT\\|RETURN\\|EXISTS\\|LIKE\\)\\>" 1 sql-conjunction-face)
	("\\<\\(sum\\|avg\\|count\\|max\\|min\\|all\\|distinct\\|SUM\\|AVG\\|COUNT\\|MAX\\|MIN\\|ALL\\|DISTINCT\\)\\>" 1 sql-aggregate-face)
	("\\<\\(alter\\|table\\|database\\|create\\|disk\\|nonclustered\\|reconfigure\\|revoke\\|override\\|procedure\\|proc\\|checkpoint\\|dump\\|drop\\|index\\|fillfactor\\|rule\\|shutdown\\|tape\\|view\\|truncate\\|kill\\|load\\|clustered\\|dbcc\\|grant\\|as\\|with\\|nowait\\|no_log\\|refit\\|reinit\\|init\\|mirror\\|unmirror\\|remirror\\|default\\|sp_[a-zA-Z]*\\|statistics\\|ALTER\\|TABLE\\|DATABASE\\|CREATE\\|DISK\\|NONCLUSTERED\\|RECONFIGURE\\|REVOKE\\|OVERRIDE\\|PROCEDURE\\|PROC\\|CHECKPOINT\\|DUMP\\|DROP\\|INDEX\\|FILLFACTOR\\|RULE\\|SHUTDOWN\\|TAPE\\|VIEW\\|TRUNCATE\\|KILL\\|LOAD\\|CLUSTERED\\|DBCC\\|GRANT\\|AS\\|WITH\\|NOWAIT\\|NO_LOG\\|REFIT\\|REINIT\\|INIT\\|MIRROR\\|UNMIRROR\\|REMIRROR\\|DEFAULT\\|SP_[a-zA-Z]*\\|STATISTICS\\)\\>" 1 sql-sysadm-face)))
	
    (defvar sql-interactive-mode-font-lock-keywords
      '(("^[0-9][0-9]*> " 0 sql-prompt-face)
	("fsql-[0-9]*) " 0 sql-prompt-face)))

    (defun sql-mode-font-lock-hook ()
      (cond ((or (eq major-mode 'sql-mode)
		 (eq major-mode 'sql-batch-mode))
	     (setq font-lock-keywords sql-mode-font-lock-keywords))
	    ((eq major-mode 'sql-interactive-mode)
	     (setq font-lock-keywords
		   (append sql-mode-font-lock-keywords
			   sql-interactive-mode-font-lock-keywords)))
	    (t
	     nil)))
	
    (or (member 'sql-mode-font-lock-hook font-lock-mode-hook)
	(add-hook 'font-lock-mode-hook 'sql-mode-font-lock-hook))))

(defun sql-display-info ()
  "Insert info about the current buffer."
  (cond
   ((eq major-mode 'sql-mode)
    (princ (format "Info on SQL Mode buffer %s\n\n"
		   (buffer-name (current-buffer))))
    (princ "This is the info\n"))
   ((eq major-mode 'sql-batch-mode)
    (princ (format "Info on SQL Batch Mode buffer %s\n\n"
		   (buffer-name (current-buffer))))
    (princ (format "Server:         %s\n" server))
    (princ (format "User:           %s\n" user))
    (if (null sql-secure-passwords)
	      (princ (format "Password:       %s\n" password)))
    (if database
	(princ (format "Database:       %s\n" database)))
    (princ (format "History:        %d\n" (length sql-history)))
    (princ (format "Global History: %d\n" (length sql-global-history))))
   ((eq major-mode 'sql-interactive-mode)
    (princ (format "Info on SQL Interactive Mode buffer %s\n\n"
		   (buffer-name (current-buffer))))
    (princ (format "Server:         %s\n" server))
    (princ (format "User:           %s\n" user))
    (if (null sql-secure-passwords)
	      (princ (format "Password:       %s\n" password))))
   ((eq major-mode 'sql-results-mode)
    (princ (format "Info on SQL Results Mode buffer %s\n\n"
		   (buffer-name (current-buffer))))
    (princ (format "Server:         %s\n" server))
    (princ (format "User:           %s\n\n" user))
    (princ (format "History:        %d\n" (length sql-history)))
    (princ (format "Global History: %d\n" (length sql-global-history))))
   (t nil)))
	
(defun sql-current-buffer-info ()
  "Display info about the current buffer in a temporary buffer."
  (interactive)
  (let ((conf (current-window-configuration)))
    (with-output-to-temp-buffer "*Info*"
      (sql-display-info))
    (sql-restore-window-config
     conf
     "Press `s' to save buffer information, anything else to flush")))

(defun sql-exit-sql-mode ()
  "Exit the sql-mode buffer, and the matching buffer if it exists."
  (interactive)
  (let ((matching-buffer sql-matching-buffer))
    (kill-buffer nil)
    (delete-other-windows)
    (if (and (bufferp matching-buffer) (buffer-name matching-buffer))
	(kill-buffer matching-buffer))))

(defun sql-about-sql-mode ()
  "Display a popup dialog box displaying information on sql-mode.el"
  (interactive)
  (let ((prompt "
SQL Mode version 0.919.1 (beta)
Copyright (c) 1994, 1995 Peter D. Pezaris


    SQL Mode comes with ABSOLUTELY NO WARRANTY.
    Type M-x describe-no-warranty for details.

    SQL Mode is beta release software.  Feel free         
    to distribute it, but USE AT YOUR OWN RISK.

    Type C-c h for general help on SQL Mode.
    Type C-h m for help on the current mode.
"))
    (if sql-lucid
	(popup-dialog-box (list prompt ["OK" 'sql-no-op t]))
      (x-popup-dialog t (cons prompt '(("OK" . t)))))))

(defun sql-no-op ()
  (interactive)
  nil)

(defun sql-y-or-n-p-maybe-dialog-box (prompt)
  (if sql-lucid
      (y-or-n-p-maybe-dialog-box prompt)
    (x-popup-dialog t (cons prompt '(("YES" . t) ("NO" . nil))))))

(defun sql-request-latest-version ()
  "Submit via mail a request for the latest version of sql-mode."
  (interactive)
  (require 'reporter)
  (and
   (sql-y-or-n-p-maybe-dialog-box 
    "Do you want to request the latest version of sql-mode? ")
   (reporter-submit-bug-report
    sql-mode-help-address
    (concat "sql-mode version " sql-mode-version)
    (list 'major-mode)
    nil
    nil
    "Please send me the latest version of sql-mode.el.")))

(defun sql-submit-enhancement-request ()
  "Submit via mail an enhancement request for sql-mode."
  (interactive)
  (require 'reporter)
  (if (or (eq major-mode 'sql-mode)
	  (eq major-mode 'sql-batch-mode)
	  (eq major-mode 'sql-interactive-mode)
	  (eq major-mode 'sql-results-mode))
      (and
       (sql-y-or-n-p-maybe-dialog-box 
	"Do you want to submit an enhancement request for sql-mode? ")
       (reporter-submit-bug-report
	sql-mode-help-address
	(concat "sql-mode version " sql-mode-version)
	(list 'major-mode)
	nil
	nil
	"Wouldn't it be nice if..."))
    (error
     "You must be in an sql related mode to submit an enhancement request")))

(defun sql-submit-bug-report ()
  "Submit via mail a bug report on sql-mode."
  (interactive)
  (require 'reporter)
  (if (or (eq major-mode 'sql-mode)
	  (eq major-mode 'sql-batch-mode)
	  (eq major-mode 'sql-interactive-mode)
	  (eq major-mode 'sql-results-mode))
      (and
       (sql-y-or-n-p-maybe-dialog-box 
	"Do you want to submit a bug report on sql-mode? ")
       (reporter-submit-bug-report
	sql-mode-help-address
	(concat "sql-mode version " sql-mode-version)
	(list
	 'major-mode
	 'sql-command
	 'sql-batch-command-switches
	 'sql-interactive-command-switches
	 'sql-require-final-go
	 'sql-secure-passwords
	 'sql-abbrev-mode
	 'sql-video-type
;	 'sql-minibuffer-status
;	 'sql-comment-start-regexp
;	 'sql-comment-start-string
;	 'sql-comment-end-regexp
;	 'sql-comment-end-string
	 'sql-resize-results-screens
	 'sql-results-screen-width
	 'sql-results-screen-height
	 'sql-max-screen-width
	 'sql-scroll-overlap
	 'sql-save-all-results
	 'sql-results-in-new-screen
	 'sql-comment-regions-by-line
;	 'sql-comment-buffer-ignore-lines
	 'sql-font-lock-buffers
	 'sql-mark-changes
	 'sql-association-mode-no-create
	 'sql-require-where
	 'sql-require-where-regexp 
	 'sql-confirm-changes
	 'sql-confirm-changes-regexp
	 'sql-history-length
	 'sql-global-history-length
	 'sql-deactivate-region
;	 'sql-basic-offset
;	 'sql-continued-statement-offset
	 'sql-indent-after-newline
	 'sql-inhibit-startup-message
	 'sql-add-to-menu-bar
	 'sql-intersperse-headers
	 'sql-use-toolbar
	 'sql-use-big-menus
	 'sql-stay-in-batch-buffer)))
    (error "You must be in an sql related mode to submit a bug report.")))

(defun sql-add-menus ()
  "Add menu items under the menu `sql-parent-menu'."
  (if (and sql-add-to-menu-bar
	   (boundp 'sql-association-alist)
	   sql-association-alist)
      (progn
	(setq sql-batch-menu
	  (and (boundp 'sql-association-alist)
	       sql-association-alist
	       (list
		(append
		 (list "Batch")
		 (sql-make-association-menu sql-association-alist
						 'sql-batch-mode)))))

	(setq sql-interactive-menu
	      (and (boundp 'sql-association-alist)
		   sql-association-alist
		   (list
		    (append
		     (list "Interactive")
		     (sql-make-association-menu sql-association-alist
						'sql-interactive-mode)))))

	(setq sql-big-menu
	      (append sql-actions-menu
		      sql-execute-menu
		      sql-history-menu
		      sql-batch-menu
		      sql-interactive-menu
		      sql-settings-menu
		      sql-options-menu
		      sql-font-lock-menu
		      (if (< emacs-minor-version 12)
			  (list (list "Buffers"))
			(list
			 '("Buffers"
			  :filter buffers-menu-filter
			  ["List All Buffers" list-buffers t]
			  "--!here"	; anything after this will be nuked
			  )))
		      (list nil)
		      sql-help-menu))

	(if sql-lucid
	    (progn
	      (and (car (find-menu-item current-menubar sql-parent-menu))
		   (add-menu-item sql-parent-menu "------------" nil nil))
	      (add-menu-item sql-parent-menu "SQL Batch Mode" 'sql-batch-mode t)
	      (add-menu sql-parent-menu "Use Association" 
			(cdr (sql-make-popup-menu 'sql-batch-mode)))
	      (add-menu-item sql-parent-menu "-----------" nil nil)
	      (add-menu-item sql-parent-menu "SQL Interactive Mode" 
			     'sql-interactive-mode t)
	      (add-menu sql-parent-menu 
			"Use Association " 
			(cdr (sql-make-popup-menu 'sql-interactive-mode))))
	  (easy-menu-define
	   sql-utilities-menu (list global-map) "SQL"
	   (cons "SQL-assoc"
		 (list
		  ["SQL Batch Mode" 'sql-batch-mode t]
		  (cons "Use Association"
			(cdr (sql-make-popup-menu 'sql-batch-mode)))
		  "----"
		  ["SQL Interactive Mode" 'sql-interactive-mode t]
		  (cons "Use Association "
			(cdr (sql-make-popup-menu 'sql-interactive-mode))))))))
    nil))

(defun sql-add-minor-modes ()
  "Add some minor modes to the variable `minor-mode-alist'."
  (or (assq 'sql-query-in-progress minor-mode-alist)
      (setq minor-mode-alist (cons '(sql-query-in-progress " Querying")
				   minor-mode-alist)))
  (or (assq 'sql-results-view-mode minor-mode-alist)
      (setq minor-mode-alist (cons '(sql-results-view-mode " View")
				   minor-mode-alist)))
  (or (assq 'sql-results-edit-mode minor-mode-alist)
      (setq minor-mode-alist (cons '(sql-results-edit-mode " Edit")
				   minor-mode-alist))))

(defun sql-display-getting-comments-info (the-file the-directory)
  "Display information on how to properly set up the comments file.
THE-FILE is the file that needs to be moved, and THE-DIRECTORY is where
it needs to be moved to."
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ (format "The file %s has not been properly set up\n" the-file))
    (princ "to display appropriate help information.\n\n")
    (princ "In order to get the help system to work, you should copy\n\n")
    (princ (format "            the file: %s\n" the-file))
    (princ (format "  into the directory: %s\n\n" the-directory))
    (princ "And then re-invoke this help command.\n\n")
    (princ (format "You should have received the file %s\n" the-file))
    (princ "with the sql-mode distribution.  If you did not, you can\n")
    (princ "request it by invoking the command:\n\n")
    (princ "  M-x sql-request-latest-version")))

(defun sql-display-comments ()
  "Display the sql-mode.el file in a temporary buffer."
  (interactive)
  (setq sql-old-window-configuration (current-window-configuration))
  (let ((file-name (expand-file-name "SQL-MODE-README" data-directory)))
    (if (not (file-readable-p file-name))
	(progn
	  (sql-display-getting-comments-info "SQL-MODE-README" data-directory)
	  (error "Could not find %s" file-name))
      (bury-buffer (get-buffer "*Help*"))
      (find-file file-name)
      (view-mode)
      (delete-other-windows)
      (goto-char (point-min))
      (toggle-read-only 0)
      (local-set-key "q" 'sql-quit-reading-comments)
      (message "Type SPACE to scroll, q to quit."))))

(defun sql-quit-reading-comments ()
  "Kill the current buffer and resotre the old winodow configuration."
  (interactive)
  (kill-buffer nil)
  (set-window-configuration sql-old-window-configuration))

(defun sql-cleanup-info ()
  "Clean up the display of information."
  (kill-line)
  (delete-region (point) (point-min))
  (forward-line 1)
  (delete-char 3)
  (forward-line 1)
  (kill-line)
  (search-forward ";;;;;")
  (beginning-of-line)
  (delete-region (point) (point-max))
  (goto-char (point-min))
  (forward-line 1)
  (center-line)
  (while (eq 0 (forward-line 1))
    (and (looking-at ";;") (delete-char 2)))
  (goto-char (point-min)))

(defun sql-advanced-usage-info ()
  "Display the information on advanced usage of SQL Mode."
  (interactive)
  (sql-display-comments)
  (re-search-forward "Advanced Usage:")
  (beginning-of-line)
  (forward-line -1)
  (set-window-start nil (point))
  (sql-cleanup-info)
  (toggle-read-only 1)
  (set-buffer-modified-p nil))

(defun sql-basic-usage-info ()
  "Display the information on basic usage of SQL Mode."
  (interactive)
  (sql-display-comments)
  (re-search-forward "Basic Usage:")
  (beginning-of-line)
  (forward-line -1)
  (set-window-start nil (point))
  (sql-cleanup-info)
  (toggle-read-only 1)
  (set-buffer-modified-p nil))
      
(defun sql-customization-info ()
  "Display the information on customizing SQL Mode."
  (interactive)
  (sql-display-comments)
  (re-search-forward "Customization:")
  (beginning-of-line)
  (forward-line -1)
  (set-window-start nil (point))
  (sql-cleanup-info)
  (toggle-read-only 1)
  (set-buffer-modified-p nil))

(defun sql-goto-matching-buffer (&optional no-error)
  "Go to the matching buffer of the current one, if it exists."
  (if (and (bufferp sql-matching-buffer) (buffer-name sql-matching-buffer))
      (set-buffer sql-matching-buffer)
    (if (not no-error)
	(error "There is no matching buffer for current buffer.")
      nil)))

(defun sql-find-next-error-line (&optional number)
  "Parse the current results buffer, searching for the next error.
Return the line number on which the error occurs."
  (let* ((times (or number 1))
	 (success (if (< times 0)
		      (re-search-backward sql-error-regexp nil t (1+ (- times)))
		    (re-search-forward sql-error-regexp nil t times))))
    (if (not success)
	(error "No more errors.")
      (goto-char (match-end 0))
      (let ((line (string-to-int (current-word))))
	(set-window-start (get-buffer-window (current-buffer))
			  (match-beginning 0))
	(setq sql-current-error-point (match-end 0))
	(message "Error found on line %d." line)
	line))))

(defun sql-next-error (&optional number)
  "Visit next evaluation error message and corresponding line of SQL code.
This operates on the output from the \\[sql-evaluate-buffer] command."
  (interactive)
  (if (eq major-mode 'sql-batch-mode)
      (sql-goto-matching-buffer))
  (goto-char (or sql-current-error-point (point-min)))
  (let ((this-error-line (sql-find-next-error-line number)))
    (sql-goto-matching-buffer)
    (goto-line this-error-line)))

(defun sql-previous-error ()
  "Visit previous evaluation error message and corresponding line of SQL code.
This operates on the output from the \\[sql-evaluate-buffer] command."
  (interactive)
  (sql-next-error -1))

(defun sql-describe-keybindings ()
  "Display the current SQL-specific keybindings that are in effect."
  (interactive)
  (let ((prefix (vector '(control c))))
    (with-output-to-temp-buffer (gettext "*Help*")
      (princ (gettext "Key bindings starting with "))
      (princ (key-description prefix))
      (princ ":\n\n")
      (describe-bindings-1 prefix nil))))

(defun sql-masthead-info ()
  "Display the masthead information of SQL Mode."
  (interactive)
  (sql-display-comments)
  (goto-char (point-min)))

(defun sql-bug-report-info ()
  "Display the information on how to submit a bug report for SQL Mode."
  (interactive)
  (sql-display-comments)
  (re-search-forward "Bug Reports:")
  (beginning-of-line)
  (forward-line -1)
  (set-window-start nil (point))
  (sql-cleanup-info)
  (toggle-read-only 1)
  (set-buffer-modified-p nil))

(defun sql-help-quit ()
  (interactive)
  nil)

(define-function 'sql-help 'sql-help-for-help)

(defun sql-help-for-help ()
  "You have typed \\[sql-help], the SQL Help character.  Type a Help option:
\(Type \\<sql-help-map>\\[sql-help-quit] to exit the Help command.)

a  sql-advanced-usage-info     Show information on advanced usage concepts.
b  sql-basic-usage-info        Show information on basic usage concepts.
c  sql-customization-info      Show information on customization.
i  sql-current-buffer-info     Show the current buffer's information.
k  sql-describe-keybindings    Show the SQL-specific keybindings in effect.
m  sql-masthead-info           Show the author and maintainer information.
n  sql-next-error              Go to the next line which contains an error.
p  sql-previous-error          Go to the previous line which contains an error.
r  sql-bug-report-info         Show information on how to report bugs.
s  sql-about-sql-mode          Show the version and other data about SQL Mode."
  (interactive)
  (let ((help-key (copy-event last-command-event))
	event char)
    (message "A B C I K M N P R S.  Type h or ? again for more help: ")
    (setq event (next-command-event)
	  char (or (event-to-character event) event))
    (if (or (equal char help-key) (equal char ?h)
	    (equal char ??) (button-event-p event))
	(save-window-excursion
	  (switch-to-buffer (gettext "*Help*"))
	  (delete-other-windows)
	  (erase-buffer)
	  (insert (documentation 'sql-help))
	  (goto-char (point-min))
	  (while (or (equal char help-key)
		     (memq char '(?h ?? ?\C-v ?\ ?\177 ?\M-v))
		     (eventp char))
	    (if (memq char '(?\C-v ?\ ))
		(scroll-up))
	    (if (memq char '(?\177 ?\M-v))
		(scroll-down))
	    (message (if (pos-visible-in-window-p (point-max))
			 "A B C I K M N P R S: "
		       "A B C I K M N P R S or Space to scroll: "))
	    (let ((cursor-in-echo-area t))
	      (setq event (next-command-event event)
		    char (or (event-to-character event) event))))))
    (let ((defn (or (lookup-key sql-help-map (vector event))
		    (and (numberp char)
			 (lookup-key sql-help-map
				     (make-string 1 (downcase char)))))))
      (message nil)
      (if defn
	  (call-interactively defn)
	(ding)))))

(defun sql-isearch-end ()
  "Function to run when isearch terminates."
  (remove-hook 'post-command-hook 'sql-horizontal-recenter)
  (sql-horizontal-recenter))

(defun sql-isearch-begin ()
  "Function to run when isearch begins."
  (sql-horizontal-recenter)
  (add-hook 'post-command-hook 'sql-horizontal-recenter))

;(defun sql-magic-update ()
;  "Mouse-based update of a table."
;  (interactive)
;  (let ((table (sql-get-table-name)))
;    (erase-buffer)
;    (insert "update " table " set ")
;    (setq sql-magic-update-in-progress t)
;    (message "Click on columns to change")))

(defun sql-magic-yank-under-point (event)
  (interactive "e")
  (let ((old-point (point))
	(the-word nil))
    (save-window-excursion
      (mouse-set-point event)
      (setq the-word (current-word)))
;    (sql-goto-batch-buffer)
    (cond
	; sitting at empty command line
     ((eq (current-column) 0)
      (insert "select "))
       ; on same line as SELECT or ORDER BY, but other words already inserted
     ((save-excursion (re-search-backward "select .+\\|order by .+\\|update .+" 
					  (save-excursion (beginning-of-line)
							  (point)) t))
      (and (eq (preceding-char) ? )
	   (backward-delete-char 1))
      (insert ", "))
       ; Otherwise
     (t
      (or (eq (preceding-char) ? )	; if preceding character = space
	  (insert " "))))
    (insert the-word " ")))

;(defun sql-magic-yank-under-point-2 (event)
;  (interactive "@e")
;  (mouse-set-point event)
;  (let ((the-word (current-word))
;	(next-line-dash (save-excursion
;			  (forward-line 1)
;			  (beginning-of-line)
;			  (looking-at " *-*")))
;	(insert-word nil))
;    (if next-line-dash
;	(sql-do-some-stuff)
;      (

(defun sql-string-is-numberp (string)
  (cond
   ((eq 0 (length string))
    nil)
   ((eq 1 (length string))
    (or (string-equal string "0") (not (eq (string-to-int string) 0))))
   (t
    (let ((char (substring string 0 1)))
      (and (or (string-equal char "0") (not (eq (string-to-int char) 0)))
	   (sql-string-is-numberp (substring string 1)))))))

;(defun sql-yank-under-point (event)
;  (interactive "@e")
;  (mouse-set-point event)
;  (let ((the-word (current-word)))
;    (sql-goto-batch-buffer)
;    (insert the-word)))

(defun sql-yank-under-point (event)
  (interactive "e")
  (let ((old-point (point))
	(the-word nil))
    (save-window-excursion
      (mouse-set-point event)
      (setq the-word (current-word)))
    (goto-char old-point)
    (insert the-word)))

(defun sql-insert-row (&optional update-interactively)
  "Insert a row into the current database.

If optional UPDATE-INTERACTIVELY is non-nil, update the buffer as values
are entered."
  (interactive)
  (or sql-table-list (sql-get-tables))
  (let ((table (completing-read "Insert into table: " sql-table-list))
	(insert-string nil))
    (erase-buffer)
    (if update-interactively
	(insert "insert into " table " values (")
      (setq insert-string (concat "insert into " table " values (")))
    (or (assoc table sql-column-list)
	(sql-get-columns table))
    (let ((columns (reverse (cdr (assoc table sql-column-list)))))
      (while columns
	(let* ((value (read-from-minibuffer (concat "Insert into " table ": "
						    (car (car columns)) " = ")))
	       (value-string (if (or (eq (cdr (car columns)) 0)
				     (string-match "\(.*\)" value)
				     (string-equal value "NULL"))
				 value
			       (concat "\"" value "\""))))
	  (if update-interactively
	      (insert (if (numberp value-string)
			  (int-to-string value-string)
			value-string)
		      ", ")
	    (setq insert-string (concat insert-string value-string ", ")))
	  (setq columns (cdr columns))))
      (if update-interactively
	  (progn
	    (backward-delete-char 2)
	    (insert ")\n"))
	(setq insert-string
	      (substring insert-string 0 (- (length insert-string) 2)))
	(setq insert-string (concat insert-string ")\n"))
	(insert insert-string)
	(sql-evaluate-buffer nil)))))

(defun sql-bcp-out-menu (table file)
  "Invoke bcp to copy TABLE out of the current database into FILE.

Display any exit status in a dialog box"
  (interactive (list (progn
		       (or sql-table-list (sql-get-tables))
		       (completing-read "Copy out of table: " sql-table-list))
		     (expand-file-name (read-file-name "Into file: "))))
  (let ((temp-buffer (get-buffer-create " SQL-TEMP"))
	(original-buffer (current-buffer))
	(table-arg (sql-create-table-arg-for-bcp table)))
    (if sql-bcp-command-switches
	(call-process sql-bcp-command nil temp-buffer nil table-arg "out" file
		      (concat "-S" server)
		      (concat "-U" user)
		      (concat "-P" password)
		      sql-bcp-command-switches)
      (call-process sql-bcp-command nil temp-buffer nil table-arg "out" file
		    (concat "-S" server)
		    (concat "-U" user)
		    (concat "-P" password)
		    "-c" "-t|" "-r'\n'"))
    (set-buffer temp-buffer)
    (and (looking-at ".*DB-LIBRARY error") (ding))
    (sql-popup-dialog-return
     (list (buffer-substring (point-min) (point-max))
	   ["OK" 'no t]))
    (kill-buffer temp-buffer)
    (set-buffer original-buffer)))

(defun sql-bcp-out (table file)
  "Invoke bcp to copy TABLE out of the current database into FILE.

Display any exit status in the echo area."
  (interactive (list (progn
		       (or sql-table-list (sql-get-tables))
		       (completing-read "Copy out of table: " sql-table-list))
		     (expand-file-name (read-file-name "Into file: "))))
  (let ((temp-buffer (get-buffer-create " SQL-TEMP"))
	(original-buffer (current-buffer))
	(table-arg (sql-create-table-arg-for-bcp table)))
    (if sql-bcp-command-switches
	(call-process sql-bcp-command nil temp-buffer nil table-arg "out" file
		      (concat "-S" server)
		      (concat "-U" user)
		      (concat "-P" password)
		      sql-bcp-command-switches)
      (call-process sql-bcp-command nil temp-buffer nil table-arg "out" file
		    (concat "-S" server)
		    (concat "-U" user)
		    (concat "-P" password)
		    "-c" "-t|" "-r'\n'"))
    (set-buffer temp-buffer)
    (goto-char (point-min))
    (replace-string "
" " ")
    (goto-char (point-min))
    (replace-string " Starting copy...  " "")
    (replace-string "   " " ")
    (and (looking-at ".*DB-LIBRARY error") (ding))
    (message (buffer-substring (point-min) (point-max)))
    (kill-buffer temp-buffer)
    (set-buffer original-buffer)))

(defun sql-bcp-in-menu (table file)
  "Invoke bcp to copy TABLE into the current database from FILE.

Display any exit status in a dialog box"
  (interactive (list (progn
		       (or sql-table-list (sql-get-tables))
		       (completing-read "Copy into table: " sql-table-list))
		     (expand-file-name (read-file-name "From file: "))))
  (let ((temp-buffer (get-buffer-create " SQL-TEMP"))
	(original-buffer (current-buffer))
	(table-arg (sql-create-table-arg-for-bcp table)))
    (if sql-bcp-command-switches
	(call-process sql-bcp-command nil temp-buffer nil table-arg "in" file
		      (concat "-S" server)
		      (concat "-U" user)
		      (concat "-P" password)
		      sql-bcp-command-switches)
      (call-process sql-bcp-command nil temp-buffer nil table-arg "in" file
		    (concat "-S" server)
		    (concat "-U" user)
		    (concat "-P" password)
		    "-c" "-t|" "-r'\n'"))
    (set-buffer temp-buffer)
    (and (looking-at ".*DB-LIBRARY error") (ding))
    (sql-popup-dialog-return
     (list (buffer-substring (point-min) (point-max))
	   ["OK" 'no t]))
    (kill-buffer temp-buffer)
    (set-buffer original-buffer)))

(defun sql-bcp-in (table file)
  "Invoke bcp to copy TABLE into the current database from FILE.

Display any exit status in the echo area."
  (interactive (list (progn
		       (or sql-table-list (sql-get-tables))
		       (completing-read "Copy into table: " sql-table-list))
		     (expand-file-name (read-file-name "From file: "
						       nil nil t))))
  (let ((temp-buffer (get-buffer-create " SQL-TEMP"))
	(original-buffer (current-buffer))
	(table-arg (sql-create-table-arg-for-bcp table)))
    (if sql-bcp-command-switches
	(call-process sql-bcp-command nil temp-buffer nil table-arg "in" file
		      (concat "-S" server)
		      (concat "-U" user)
		      (concat "-P" password)
		      sql-bcp-command-switches)
      (call-process sql-bcp-command nil temp-buffer nil table-arg "in" file
		    (concat "-S" server)
		    (concat "-U" user)
		    (concat "-P" password)
		    "-c" "-t|" "-r'\n'"))
    (set-buffer temp-buffer)
    (goto-char (point-min))
    (replace-string "
" " ")
    (goto-char (point-min))
    (replace-string " Starting copy...  " "")
    (replace-string "   " " ")
    (and (looking-at ".*DB-LIBRARY error:") (ding))
    (message (buffer-substring (point-min) (point-max)))
    (kill-buffer temp-buffer)
    (set-buffer original-buffer)))

(defun sql-create-table-arg-for-bcp (table)
  (if (and (null database) (null sql-bcp-user))
      table
    (concat database "." sql-bcp-user "." table)))

(defun sql-edit-row ()
  "Edit the current row at point.  Simply make the change to the current
row by typing, and hit \\[sql-update-row] to perform the update.

While editing the current row, overwrite-mode is in effect to preserve
column alignment.  If the alignment is off, then the update will be
innacurate."
  (interactive)
  (sql-results-edit-mode)
  (message "Building column pairings...")
  (let* ((column-names (sql-build-column-names))
	 (column-widths (sql-build-column-widths)))
    (setq sql-update-virgin-column-pairs
	  (sql-build-column-pairs column-names column-widths))
    (setq sql-update-virgin-line (current-line)))
  (message (substitute-command-keys
	    "Type to change the row, then to update, type \\[sql-update-row].")))

(defun sql-update-row ()
  (interactive)
  "Update the row at point.  This function should be invoked after
\\[sql-edit-row] and after the row has been edited.

This will create a SQL statement which will have the effect of updating
the current row to reflect the manual editing that was performed."
  (or sql-update-virgin-column-pairs
      (error "Not ready for an update.  First you must edit the row."))
  (or (eq (current-line) sql-update-virgin-line)
      (progn
	(message "%d " (current-line) sql-update-virgin-line) (sit-for 2)
	(setq sql-update-virgin-column-pairs nil)
	(setq sql-update-virgin-line nil)
	(sql-results-view-mode)
	(error "You are on a different line.  Please restart the update.")))
  (sql-goto-batch-buffer)
  (let* ((default-table (sql-get-table-name))
	 (table (completing-read (format "Update in table (default %s): "
					 default-table)
				 sql-table-list)))
    (and (string-equal table "") (setq table default-table))
    (and (string-equal table "") (error "Invalid table selection."))
    (or (assoc table sql-column-list)
	(sql-get-columns table))
    (sql-goto-results-buffer)
    (let* ((column-names (sql-build-column-names))
	   (column-widths (sql-build-column-widths))
	   (column-pairs (sql-build-column-pairs column-names column-widths))
	   (virgin-pairs sql-update-virgin-column-pairs))
      (and (equal column-pairs virgin-pairs)
	   (error "Nothing to update!"))
      (sql-goto-batch-buffer)
      (let ((differences (sql-remove-common column-pairs virgin-pairs))
	    (column-list (cdr (assoc table sql-column-list))))
	(erase-buffer)
	(insert "update " table "\nset ")
	(while differences
	  (let* ((column (car (car differences)))
		 (value (cdr (car differences)))
		 (no-quotes (or (string-equal "NULL" value)
				(string-match "\(.*\)" value)
				(eq 0 (cdr (assoc column column-list))))))
	    (or (eq 2 (cdr (assoc column column-list)))
		(insert column " = "
			(if no-quotes "" "\"")
			value
			(if no-quotes "" "\"")
			",\n    "))
	    (setq differences (cdr differences))))
	(backward-delete-char 6)
	(insert "\nwhere ")
	(while virgin-pairs
	  (let* ((column (car (car virgin-pairs)))
		 (value (cdr (car virgin-pairs)))
		 (no-quotes (or (string-equal "NULL" value)
				(string-match "\(.*\)" value)
				(eq 0 (cdr (assoc column column-list))))))
	    (or (eq 2 (cdr (assoc column column-list)))
		(insert column " = "
			(if no-quotes "" "\"")
			value
			(if no-quotes "" "\"")
			"\n  and "))
	    (setq virgin-pairs (cdr virgin-pairs))))
	(backward-delete-char 6)))
    (goto-char (point-min))
    (setq sql-update-virgin-column-pairs nil)
    (sql-goto-results-buffer)
    (sql-results-view-mode)
    (sql-goto-batch-buffer))
  (message (substitute-command-keys
	    "Type \\[sql-evalutate-buffer] to perform the update.")))

(defun sql-remove-common (list1 list2)
  "Remove all elements in list1 that appear in list2."
  (let ((condensed-list nil))
    (while list1
      (or (member (car list1) list2)
	  (setq condensed-list (cons (car list1) condensed-list)))
      (setq list1 (cdr list1)))
    (reverse condensed-list)))

(defun current-line ()
  "Return the current line as an integer."
  (interactive)
  (+ (count-lines (point-min) (point))
     (if (eq (current-column) 0)
	 1
       0)))

(defun goto-column (column)
  "Goto column COLUMN on the current line."
  (interactive "nColumn: ")
  (beginning-of-line)
  (forward-char column))

(defun sql-build-column-widths ()
  (save-excursion
    (goto-char (point-min))
    (forward-line 1)
    (search-forward " ")
    (let ((column-widths nil)
	  (eol (save-excursion (end-of-line) (point))))
      (while (< (point) eol)
	(let* ((column-start (current-column))
	       (column-end (progn (search-forward " ") (current-column))))
	  (setq column-widths (cons (- column-end column-start)
				    column-widths))))
      (reverse column-widths))))

(defun sql-build-column-names ()
  (save-excursion
    (goto-char (point-min))
    (skip-chars-forward " ")
    (let ((column-names nil)
	  (eol (save-excursion (end-of-line) (point))))
      (while (< (point) eol)
	(let* ((column-name (current-word)))
	  (setq column-names (cons column-name column-names))
	  (forward-word 1)
	  (skip-chars-forward " \t")))
      (reverse column-names))))

(defun sql-iconify-frame ()
  (interactive)
  (iconify-frame))

(defun sql-build-column-pairs (names widths)
  (or (eq (length names) (length widths))
      (error "Error building column pairs."))
  (save-excursion
    (beginning-of-line)
    (forward-char 1)
    (let ((column-pairs nil))
      (while names
	(let* ((name (car names))
	       (start (point))
	       (word-start (point))
	       (width (car widths))
	       (offset (if (and (< width 5) (string-equal (current-word)
							  "NULL"))
			   (- 5 width)
			 0))
	       (end (+ start width offset))
	       (value nil))
	  (skip-chars-forward " \t")
	  (setq word-start (point))
	  (goto-char end)
	  (skip-chars-backward " \t")
	  (setq end (point))
	  (setq value (if (> end word-start)
			  (buffer-substring word-start end)
			""))
	  (setq names (cdr names))
	  (setq widths (cdr widths))
	  (goto-char start)
	  (forward-char (+ width offset))
	  (setq column-pairs (cons (cons name value) column-pairs))))
      (reverse column-pairs))))

(defun sql-display-new-users-guide ()
  (and sql-noisy (ding))
  (let ((prompt "

  SQL Mode Version 0.919.1 (beta)

  You do not have an association list defined in your $HOME/.sql-mode
  file.  Having such associations defined makes interaction with SQL
  Mode much easier.  To find out how to set this up, you may refer to
  the comments at the top of the sql-mode.el file, or you may invoke
  the SQL Mode help system via C-c h (in an SQL buffer).

  In the absence of associations, the only way to enter sql-batch-mode
  and sql-interactive mode is to manually enter the server, user and
  password on each invocation.  Type M-x sql-batch-mode to try it out.        

"))
    (and (if sql-xemacs
	     (sql-popup-dialog-return
	      (list prompt
		    ["OK\n Warn me next time" 'no t]
		    nil
		    ["OK\n Don't warn me again" t t]))
	   (x-popup-dialog t (cons prompt
				   '(("OK\n Warn me next time" . nil)
				     ("OK\n Don't warn me again" . t)))))
	 (sql-no-warn))))

(defun sql-no-warn ()
  "Make it so that we don't warn the user about not having an association list.
This file appends to the end of the user's $HOME/.sql-mode file."
  (interactive)
  (write-region "\n(setq sql-dont-warn t)\n" nil
		(concat (getenv "HOME") "/.sql-mode") t 1))

(defun sql-initialize ()
  "Initialize sql related modes."
  (interactive)
  (sql-load-customizations)
  (and sql-sybase (setenv "SYBASE" sql-sybase))
  (if (and (null sql-server-table) (eq sql-database-type 'sybase))
      (sql-read-interfaces-file))
  (sql-load-top-ten)
  (sql-setup-font-lock)
  (sql-add-minor-modes)
  (sql-add-menus)
  (autoload 'sql-toolbar "sql-toolbar.el" "Use a toolbar in SQL Mode" t)
  (autoload 'sql-turn-on-toolbar "sql-toolbar.el" "Use a toolbar in SQL Mode" t)
  (or sql-association-alist
      sql-dont-warn
      (sql-display-new-users-guide))
  (setq sql-initialized t)
  (run-hooks 'sql-load-hook))

;(sql-initialize)

(provide 'sql-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sql-mode.el ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
