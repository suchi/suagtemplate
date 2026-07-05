# personal/ — 個人(マシン)側のグローバル設定

リポジトリ単位ではなく、個人のメモリ(グローバル設定)に置くべき指示。新しいマシンをセットアップするとき、または内容を更新したときに各エージェントへ反映する。

## 内容

| ファイル | 反映先 |
| --- | --- |
| `global-instructions.md` | `~/.claude/CLAUDE.md`(Claude Code)、`~/.codex/AGENTS.md`(Codex) |
| `copilot-personal-instructions.md` | GitHub Copilotの個人カスタム指示(手動で貼り付け) |

## 反映方法

- Linux / macOS / WSL2: `./install.sh`
- Windows(PowerShell): `./install.ps1`

既存ファイルの内容が異なる場合は、タイムスタンプ付きの`.bak`にバックアップしてから上書きする。

Copilotの個人指示はスクリプトで反映できないため、`copilot-personal-instructions.md`の手順に従って手動で貼り付ける。

## リポジトリのAGENTS.mdとの関係

- 内容が一部重複するのは意図的。`AGENTS.md`がないリポジトリでも共通スタイルを効かせるため。
- リポジトリ側の`AGENTS.md`の指示が常に優先される。個人設定にはプロジェクトに依存しない好みだけを書く。

## 実運用リポジトリでは

テンプレートから作成した実運用リポジトリでは、このフォルダは削除する(各マシンへの反映が済んでいる前提)。手順は`template-docs/setup-guide.md`参照。
