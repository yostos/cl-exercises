;;;; src/hello.lisp --- コマンドライン引数で受け取った名前に挨拶する

(defpackage #:hello
  (:use #:cl)
  (:export #:main)
  (:documentation "名前を引数に取り、挨拶を表示するコマンド"))
(in-package #:hello)

;;; コマンド処理

(defun handler (cmd)
  "CMDの位置引数の先頭を名前として挨拶を表示する。
引数がなければ使い方を標準エラーに出し、終了コード 1で終了する"
  (let ((args (clingon:command-arguments cmd)))
    (when (null args)
      (clingon:print-usage cmd *error-output*)
      (uiop:quit 1))
    (format t "Hello, ~A!~%" (first args))))

;;; コマンド定義

(defun command ()
  "hello コマンドを定義したclingonのコマンドオブジェクトを返す"
  (clingon:make-command
   :name "hello"
   :description "名前に挨拶する"
   :version "0.1.0"
   :usage "NAME"
   :handler #'handler))

;;; エントリポイント

(defun main ()
  "コマンドライン引数を解析してhelloコマンドを実行する"
  (clingon:run (command)))
