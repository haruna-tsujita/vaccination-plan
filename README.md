# ワクチンプラン
### お子さんの予防接種の予定を自動で計算します

https://vaccination-plan.herokuapp.com/

## サービスについて
このサービスは乳幼児期のお子さんを育てている保護者を対象とした、予防接種の予定管理サービスです。
子どもの予防接種の計画を立てるのが大変という問題を解決したく、このサービスを考えました。

子どもの生年月日と前回の予防接種の記録を行うことで、他の予防接種との兼ね合いを考慮しながら、次の予防接種日を自動で教えます。

接種規定については日本小児科学会の推奨のデータを参考に作っています。
https://www.jpeds.or.jp/uploads/files/vaccine_schedule.pdf

## 使い方
トップページ


<img width="150" alt="スクリーンショット 2022-05-13 15 24 02" src="https://user-images.githubusercontent.com/82350582/168247237-d5e05f7a-3219-4f46-b5fc-ea72c7642bff.png">

ユーザーとなる保護者の方にはアカウント登録をしていただきます。
登録後、確認メールが届きますので、メールの認証ボタンからログインに進んでください。
ログイン後はすぐにお子さんの登録ページに進みます。
<img width="500" alt="image" src="https://user-images.githubusercontent.com/82350582/168247984-dd76c2bb-77aa-415d-b5fd-83f8a2287ca8.png">


お子さんの登録がお済みになりましたら、接種済みのワクチンの登録をお願いします。
画面下部の`予定`のボタンから、お子さんのワクチンの予定を見ることができます。

<img width="500" alt="image" src="https://user-images.githubusercontent.com/82350582/168248736-0f259328-db21-4df5-9deb-9c14fadf527a.png">

ご兄弟がいらっしゃる場合には、ご兄弟やご姉妹の追加を行なっていただくと、登録された兄弟姉妹全員の予定を確認することができます。

<img width="150" alt="スクリーンショット 2022-05-13 17 46 18" src="https://user-images.githubusercontent.com/82350582/168249293-f1c47961-9a53-4d77-a4d6-7350761c7187.png">


## 開発環境
- RUby on Rails 6.1.5
- PsotgreSQL
- Heroku
- GitHub Actions

## セットアップ

`$ bin/setup`

`$ bin/rails server`
