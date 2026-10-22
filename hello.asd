;;;; hello.asd --- hello のシステム定義

(defsystem "hello"
    :description "コマンドライン引数で受け取った名前に挨拶する"
    :author "Toshiyuki Yoshida"
    :license "MIT"
    :version "0.1.0"
    :depends-on ("clingon")
    :components ((:module "src"
			  :components ((:file "hello"))))
    :build-operation "program-op"
    :build-pathname "bin/hello"
    :entry-point "hello:main"
    :in-order-to ((test-op (test-op "hello/tests"))))

(defsystem "hello/tests"
    :description "helloのテスト"
    :depends-on ("hello" "fiveam")
    :components ((:module "tests"
			  :components ((:file "hello"))))
    :perform (test-op (o c)
		      (unless (symbol-call :fiveam :run! (find-symbol* :hello :hello/tests))
			(error "テストが失敗しました"))))

;;; 実行ファイルを圧縮する（SBCL が圧縮に対応している場合のみ）
#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c (eql(asdf:find-system "hello"))))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))
