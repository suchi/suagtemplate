# AGENTS.md — このリポジトリ(メタリポジトリ)のエージェント指示

このリポジトリは2つのリポジトリテンプレート(`template/`=全英語・`template_ja/`=日本語ベース)を育てていくメタリポジトリ。本ファイルは「このリポジトリ自体に対する作業」の指示を定める。

開発の進め方・言語ルール・コミット規約・PR/レビュー/マージ・セキュリティの一般ルールは[template_ja/AGENTS.md](template_ja/AGENTS.md)に従う(1ルール1か所の原則により再掲しない)。以下はこのリポジトリ固有の追加ルール。

## 検証コマンド

| 用途 | コマンド |
| --- | --- |
| フックのテスト+テンプレート間同一性チェック | `sh docs/tests/hook-tests.sh` |
| プレースホルダの確認 | `grep -rn "TODO(project)" template template_ja` |

## テンプレート間同期(最重要ルール)

`template/`と`template_ja/`は同じ構成・同じ意味内容を保つ。片方を変更したら、必ず同じ変更の中でもう片方にも反映する。

- コード類(`.claude/hooks/`・`settings.json`・`personal/`のスクリプト・dotfiles): バイト単位で同一にする。`docs/tests/hook-tests.sh`が同一性を検証する。
- 文書類(AGENTS.md・commands・skills・README等): 対訳として意味内容を一致させる(英語版と日本語版)。
- 片側専用ファイル(例: `template_ja/.github/copilot-code-review.yml`)は対象外。新たに片側専用ファイルを作るときは、理由を`docs/history.md`に記録する。
- PostToolUseフック(`check-template-sync.sh`)が、対応ファイルを持つテンプレート内ファイルの編集時にリマインドする。

## メタ文書のルール

- トップの`README.md`・本ファイル・`docs/`配下は日本語で書く。英語版(`_en.md`)は作らない(英語の成果物は`template/`そのものが担う)。
- テンプレートに変更を加えたら、同じPRで`docs/history.md`に要望・決定事項・設計判断を追記する。
- 運用手順の詳細は[docs/maintenance.md](docs/maintenance.md)に従う。

## テンプレート品質のルール

- 個別のアカウント情報・リポジトリ名・件数などの詳細をテンプレート・ドキュメントに書かない(過去の経験に基づく知見を一般化して書くのはよい)。このリポジトリ自体の名前も`template/`・`template_ja/`配下には書かない(適用先ではノイズになるため)。
- `TODO(project):`プレースホルダを消さない(実運用リポジトリ側で埋める設計)。
- フック・ガードを変更したら、同じ変更で`docs/tests/hook-tests.sh`にテストケースを追加し、全ケースPASSを確認する。

## 構成

| パス | 内容 |
| --- | --- |
| `template/` | 全英語のリポジトリテンプレート |
| `template_ja/` | 日本語ベースのリポジトリテンプレート |
| `docs/` | メタ文書(setup-guide・maintenance・history・references・agent-notes・vibe-coding・tests) |
| `.claude/` | このリポジトリ自体で作業するときの設定(テンプレートと同じガード+`check-template-sync.sh`) |
| `.github/` | このリポジトリ自体のCopilot設定・dependabot |
