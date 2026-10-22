;;;; tests/hello.lisp --- helloのテスト

(defpackage #:hello/tests
  (:use #:cl #:fiveam)
  (:documentation "helloのテスト"))
(in-package #:hello/tests)

(def-suite hello
    :description "helloのテストスイート")
(in-suite hello)

(defun run-hello (args)
  "ARGSをコマンドライン引数としてhelloのハンドラを実行し、標準出力の内容を返す"
  (let ((cmd (clingon:parse-command-line (hello::command) args)))
    (with-output-to-string (*standard-output*)
      (hello::handler cmd))))

(test greets-given-name
      "引数で渡した名前に挨拶する"
      (is (string= (format nil "Hello, World!~%") (run-hello '("World")))))

(test uses-first-argument
      "引数が複数あるときは先頭だけを使う"
      (is (string= (format nil "Hello, Lisp!~%") (run-hello '("Lisp" "etxra")))))

(test parses-positional-arguments
      "位置引数がそのまま取り出せる"
      (is (equal '("World")
		 (clingon:command-arguments
		  (clingon:parse-command-line (hello::command) '("World"))))))
