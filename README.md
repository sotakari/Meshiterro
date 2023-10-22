# Meshiterro

## 0章 Meshiterroについて

#### ・機能一覧
画像投稿の一覧表示<br>
画像投稿の詳細表示<br>
画像投稿の削除機能<br>
コメント機能<br>
いいね機能<br>
ユーザ登録機能/ログイン機能<br>
ユーザーのマイページ(ユーザの詳細表示)<br>
ユーザーのプロフィール編集機能

#### ・作成手順
1.機能の制作<br>
2.重複した機能の共通化(部分テンプレート)<br>
3.レイアウトの調整

## 1章 アプリケーションを作成・準備

・アプリケーションMeshiterro作成<br>
・homesコントローラー作成<br>
・ActiveStorageのインストール<br>
・画像サイズの変更を行うGemを導入<br>
・エラー回避のために設定を加える config.active_job.queue_adapter = :inline

## 2章 データベースの設計方法

#### データベース設計とは
アプリケーションを開発する際「どのデータをどのように保存するか<br>」
を事前に考えておかないこと複雑なデータ処理になる。<br>
開発前に必要なデータを明らかにさせて、どのような形で保存するかを検討して組み立てることが重要<br>
事前にデータベースの詳細モデルを設計することを、「データベース設計（database design）」という

#### 手順
1.ワイヤーフレームを描く<br>
2.必要なデータ項目を表にまとめる<br>
3.カラム名を決める<br>
4.「列の繰り返し項目」を削除する<br>
5.「行の繰り返し項目」を削除する<br>
6.テーブルにIDカラムを追加する<br>
7.共通利用のデータをテーブル化する

## 3章 ユーザー認証機能(1) ユーザー認証とは

#### ユーザー認証とは
操作している個人を特定したり操作できる人を制限する機能。<br>
誰がどのような情報を投稿したかわかるようにするために必要。

#### イメージ
1.ユーザーがどの投稿をしたか特定するために、投稿データにユーザーごとに与えられたIDを持たせる。<br>
2.1の情報は、ユーザーが投稿を行なったときのみ、データに持たせる。

## 4章 ユーザー認証機能(2) Gemとは

Gem とは他の誰かが既に作ったパッケージ、つまりコードの塊。<br>
コードはパッケージによって違い、画像加工、フォロー機能、認証機能など数多くある。<br>
認証を一から作成する必要があるがGemを使用することで比較的簡単にクオリティの高いものが制作できる。

#### deviseとは
Database Authenticable: ユーザがサインインするための認証パスワードを暗号化しDBに保存<br>
Omniauthable: OmniAuthをサポート<br>
Confirmable: 確認フロー中にメールを送付し、サインインの際にアカウントが確認済みか否かをチェック<br>
Recoverable: パスワードのリセットをし、リセット方法をメールで送付<br>
Registerable: 登録プロセスを通してユーザのサインアップを行い、ユーザ情報の編集や削除機能を有する<br>
Rememberable: ユーザ情報をクッキーに保存するため、トークンを生成・削除<br>
Trackable: サインイン回数、サインイン時間、IPアドレスを保存<br>
Timeoutable: 特定の時間でセッションの有効期限を切ることができる<br>
Validatable: emailとパスワードのバリデーションが可能。これはオプションであり、カスタマイズ可能であるため、独自バリデーション機能を定義できる<br>
Lockable: サインインに特定の回数失敗したのち、アカウントをロック。メールもしくは特定の時間ののちアンロック可能<br>

#### bundle install とは？
”Gemfile”に記述した Gem を、Rails アプリケーション内で使用できるようにインストールするためのコマンド。

## 5章 ユーザー認証機能(3) deviseを使った実装(1)

#### Model
deviseの場合Geｍをインストールした後に改めてインストールの手順が必要。<br>
deviseを利用するとユーザーテーブルを自動的に作成してくれる。<br>
記述が変わるので注意、rails g deviseモデル名記述はdevise独自のルール。<br>
作成に成功すると「User」という名のモデルと、users テーブル用のマイグレーションファイルが作成される。<br>
・User モデル（ユーザ情報を操作する）<br>
・users テーブルのマイグレーションファイル（ユーザ情報を保存する）<br>
Meshiterroではユーザ登録の際に名前の登録をしてもらうが名前を保存するカラムがないため追加する。

#### Routing
devise のモデルを作成したことで、config フォルダの routes.rb ファイルには、ルーティングが自動的に追加される。

## 6章 ユーザー認証機能(4) deviseを使った実装(2)

deviceでモデルを作成した時点で基本的な準備は整っているためサインアップやログインの画面は表示できる<br>

#### 会員登録やログインに必要な情報を編集するための手順

・View:deviseのコマンドを使用してViewファイルを作成。<br>
rails g devise:views<br>
・Controller:初期状態ではサインアップ、サインイン時に「email」と「パスワード」しか受け取ることを許可されていない。<br>
deviceのコントローラーは直接修正できないため全てのコントローラに対する処理を行える権限を持つ、ApplicationControllerに
記述する必要がある。<br>

#### ログアウト
deviseにより機能は作成済のため、ログアウト用のリンクを記述。<br>
HTTPメソッドはDELETEであることに注意。

#### ヘッダー
<% if user_signed_in? %><br>
これはdevise側で用意しているヘルパーメソッド。<br>
deviseの機能を使用してログインしている、ログインしていないかを判断し、どちらかによりブラウザに表示する内容を変更することができる。

## 7章 ユーザー認証機能(5) deviseを使った実装(3)

サインイン、サインアウト後にルートページに遷移してしまうため解決する。

#### Aboutページ作成
・after_sign_in_path_for/after_sign_out_path_for
<br>Deviseが用意しているメソッドで、サインイン、サインアウト後にどこに遷移するかを設定しているメソッド。

## 8章 投稿機能の作成(1) モデルを準備しよう(1)

「PostImage」という命名でモデルを作成し、ActiveStorageの機能を使って画像をアップロードできるようにする。

## 9章 投稿機能の作成(2) モデルを準備しよう(2)

#### モデル同士の関連付け(アソシエーション)

アソシエーションでは、1:N の関係を意識する。<br>
1:N の「1」側にあたるモデルに、has_many を記載する。<br>
1:N の「N」側にあたるモデルに、belongs_to を記載する<br>
dependent: :destroy は、1:N の「1」側にあたるデータが消えた時に、まとめて N 側のデータが消えるという設定である。<br>
resources を使うことで、まとめてルーティングを設定することができる<br>

## 10章 投稿機能の作成(3) 投稿できるようにしよう

#### current_user
current_userはログイン中のユーザー情報を取得することができ<br>
current_user.idと記述することでログインユーザーのidを取得することができる。<br>
※deviseのヘルパーメソッドであるため導入しないと使用不可。

## 11章 投稿機能の作成(4) 投稿一覧を見れるようにしよう
投稿したPostImageを一覧表示する画面を作成。

## 12章 投稿機能の作成(5) 投稿ごとの画面を作ろう
投稿画像の詳細ページを設定。<br>
'%Y/%m/%d'の記述で、年/月/日のフォーマットへ変換できる。

## 13章 投稿機能の作成(6) 投稿を削除できるようにしよう
投稿削除機能を実装、投稿したユーザー以外が投稿を削除できないようにする。

## 14章 ユーザーに関する機能(1) 準備編
・ユーザーごとのプロフィール画像を保存できないためModelに<br>
has_one_attached :profile_imageと記述しActiveStorageでプロフィール画像を保存できるように設定する。<br>
・users Controllerを準備し、resourcesでルーティングを書きかえする。