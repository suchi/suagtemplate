# suagtemplate — AIエージェント設定テンプレート集

GitHub Copilot・Claude Code・Codexで開発するためのデフォルト設定を備えたリポジトリテンプレートを2種類提供する。

エージェントへの指示はリポジトリルートの`AGENTS.md`に集約する単一ソース構成をとる。各エージェント固有のファイル(`CLAUDE.md`・`.github/copilot-instructions.md`)は`AGENTS.md`を参照する薄いファイルとして保つ。

## テンプレート

| フォルダ | 内容 |
| --- | --- |
| [template/](template/) | すべて英語のテンプレート |
| [template_ja/](template_ja/) | ドキュメント・会話が日本語のテンプレート(コード・識別子は英語) |

新しいリポジトリへの適用手順は[docs/setup-guide.md](docs/setup-guide.md)を参照。

## このリポジトリ自体について

このリポジトリはテンプレートを育てていくためのメタリポジトリで、その運用ルールは`AGENTS.md`(トップ)に、文書は`docs/`にまとめる。いずれも日本語で書く(決定事項)。

- [docs/setup-guide.md](docs/setup-guide.md): テンプレートから実運用リポジトリを作る手順
- [docs/maintenance.md](docs/maintenance.md): このリポジトリの運用指針(テンプレート間同期・変更手順)
- [docs/history.md](docs/history.md): 変更履歴(セッション記録)
- [docs/references.md](docs/references.md): 依拠した公式ドキュメント一覧
- [docs/agent-notes.md](docs/agent-notes.md): エージェント別の運用ノート
- [docs/vibe-coding.md](docs/vibe-coding.md): Vibe Coding切替ガイド
- [docs/tests/hook-tests.sh](docs/tests/hook-tests.sh): フックのテストハーネス

`template/`と`template_ja/`は構成・意味内容を常に同期する。コード類(hooks・settings・スクリプト)はバイト単位で同一、文書類は対訳として維持する(詳細は`AGENTS.md`と[docs/maintenance.md](docs/maintenance.md))。
