# ワクチンプラン
### お子さんの予防接種の予定を自動で計算します

http://www.vaccination-plan.com/

## サービスについて
このサービスは乳幼児期のお子さんを育てている保護者を対象とした、予防接種の予定管理サービスです。
子どもの予防接種の計画を立てるのが大変という問題を解決したく、このサービスを考えました。

子どもの生年月日と前回の予防接種の記録を行うことで、他の予防接種との兼ね合いを考慮しながら、次の予防接種日を自動で計算します。

接種規定については日本小児科学会の推奨のデータを参考に作っています。
https://www.jpeds.or.jp/uploads/files/vaccine_schedule.pdf

## 使い方

- アカウント登録後、お子さんのお名前・生年月日を入力します
- これまでに接種したことのある予防接種の日付を入力します
- 出来上がった予定を確認して、予防接種を打ちましょう！

<img width="750" alt="スクリーンショット 2022-09-06 2 07 42" src="https://user-images.githubusercontent.com/82350582/188493383-d144fbbe-7670-40f9-b77b-d0a5e3a3a65b.png">

## 開発環境
- Ruby on Rails 6.1.5
- PostgreSQL
- Heroku
- GitHubActions
- BULMA

## セットアップ

`$ bin/setup`

`$ bin/rails server`
