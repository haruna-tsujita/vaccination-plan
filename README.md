# ワクチンプラン
### お子さんの予防接種の予定を自動で計算します

https://vaccination-plan.herokuapp.com/

## サービスについて
このサービスは乳幼児期のお子さんを育てている保護者を対象とした、予防接種の予定管理サービスです。
子どもの予防接種の計画を立てるのが大変という問題を解決したく、このサービスを考えました。

子どもの生年月日と前回の予防接種の記録を行うことで、他の予防接種との兼ね合いを考慮しながら、次の予防接種日を自動で教えます。

接種規定については日本小児科学会の推奨のデータを参考に作っています。
https://www.jpeds.or.jp/uploads/files/vaccine_schedule.pdf

## 開発環境
- Ruby 3.1.0
- RUby on Rails 6.1.5
- PsotgreSQL
- Heroku
- GitHub Actions

## セットアップ

`$ bin/setup`

`$ bin/rails server`
