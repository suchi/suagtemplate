# suagtemplate — AIエージェント設定テンプレート

GitHub Copilot・Claude Code・Codexで開発するためのデフォルト設定を備えたリポジトリテンプレート。

エージェントへの指示はリポジトリルートの`AGENTS.md`に集約する単一ソース構成をとる。各エージェント固有のファイル(`CLAUDE.md`、`.github/copilot-instructions.md`)は`AGENTS.md`を参照する薄いファイルとして保つ。

## このテンプレートの使い方

- テンプレート自体の説明・構成: [template-docs/README.md](template-docs/README.md)
- 新しいリポジトリへ適用する手順: [template-docs/setup-guide.md](template-docs/setup-guide.md)
- 個人(マシン)側のグローバル設定: [personal/README.md](personal/README.md)

テンプレートから作成したリポジトリでは、`template-docs/`と`personal/`を削除し、このREADMEをプロジェクトのREADMEに書き換えること(手順は setup-guide 参照)。

## 言語について

日本語のドキュメント`<名前>.md`が正で、`<名前>_en.md`はその英語版。日本語版を変更したときは英語版も必ず同時に更新する。
