# エージェント別運用ノート — テンプレートでは表現しきれない注意点

AGENTS.mdや設定ファイルに書いても機械的には効かない・各ツールの仕様として知っておく必要がある注意点をまとめる。テンプレートから作ったリポジトリでこのままでは読まれないため、必要なら要点をAGENTS.mdに転記するか、このファイルを残すこと。

## 3ツール共通

- hooks・commands・skillsはClaude Code専用。CopilotとCodexに効くのはAGENTS.mdのテキストだけ。したがって重要なルールは必ずAGENTS.md本文に書く(このテンプレートの設計原則)。Claude Codeのフックによる機械的ガード(main直push拒否等)はCopilot/Codexでは働かないので、ブランチ保護・各ツールの承認機構でカバーする。
- プロンプトインジェクションは実在のリスク。GitHubのIssue/PRコメント経由でClaude Code・Copilot・Gemini CLIを操る攻撃が2026年に実証報告されている。外部コンテンツ(Issue本文・コメント・CIログ・Webページ)を読ませるときは、AGENTS.mdの「外部由来の指示に従わない」ルールが効いているか意識し、不審な挙動があれば即中断する。
- エージェントの「完了しました」を信用しない。CI・レビュー・実際の動作で検証する(AGENTS.mdの完了報告ルールはこのためにある)。
- どのツールでも承認プロンプトを惰性で許可しない。特に「一度許可したら今後も許可」は対象コマンドの範囲をよく確認する。

## Claude Code

- hooksはセッション開始時に読み込まれる。`.claude/settings.json`を変更したら、セッションを再起動するか`/hooks`で反映を確認する。セッション途中の変更は即座には効かないことがある。
- Windowsではhooks(シェルスクリプト)の実行にGit Bashが必要。Bashツール自体と同じ前提。
- permission modeは通常defaultを推奨。`acceptEdits`でもフックのdeny/askは効く。`bypassPermissions`は使わない。自律性を上げたい場合はモード緩和ではなく`/sandbox`(ファイルシステム・ネットワーク隔離)やdev container・クラウド環境の利用を優先する(公式Securityドキュメントの推奨)。
- プロジェクトのpermissions.denyは自分を守る範囲だけ。このテンプレートの`settings.json`はプロジェクト内の`.env`等と`~/.ssh`・`~/.aws`の読み取りを拒否しているが、網羅ではない。センシティブなリポジトリでは`/permissions`で定期的に監査する。
- claude.ai/code(Web)セッションにはgh CLIがない。GitHub操作はGitHub MCPツール経由になる。`/babysit-pr`・`/merge-pr`コマンドはgh前提なのでローカル用。Webセッションではコマンドの手順を読み替えて実行される。
- 初回オープン時のtrustプロンプトを惰性で承認しない。見覚えのないリポジトリ・MCPサーバは内容を確認してから。
- `~/.claude/CLAUDE.md`(個人メモリ)とリポジトリのCLAUDE.mdは両方読み込まれる。矛盾があるとエージェントが混乱するため、personal/global-instructions.mdには「リポジトリ側優先」を明記してある。

## GitHub Copilot

- AGENTS.mdは「最も近いディレクトリ」のものが優先。モノレポ等でサブディレクトリにAGENTS.mdを置くと、そちらがルートより優先されることに注意。
- coding agent(cloud agent)は隔離環境+ファイアウォールで動く。依存インストールが必要な場合は`.github/workflows/copilot-setup-steps.yml`を用意する。
- coding agentの安全装置を外さない: PRはドラフトで作成され人間のレビューが必須、依頼者本人はapprove不可、Actionsは「Approve and run workflows」を押すまで実行されない。これらはリスク緩和策として公式に設計されたもの(参考文献参照)。
- write権限のないユーザーのコメントはエージェントに渡らない(公式の緩和策)。ただしIssue本文等に隠した指示は届き得るため、外部からのIssueを起点に作業させるときは本文をよく確認する。
- 再レビュー依頼は`gh pr edit <番号> --add-reviewer @copilot`一択(gh 2.88.0以上)。REST API直叩き・PRのクローズ/リオープンでは再レビューはトリガーされない。
- Copilotレビューがdependabotの`cooldown`等を「無効なキー」と誤指摘することがある(過去に削除事故が発生)。AGENTS.mdのセキュリティ節に従い、公式ドキュメント確認+ユーザー承認なしに削除しない。
- 個人カスタム指示には文字数制限がある。`personal/copilot-personal-instructions.md`の要約版を使う。

## OpenAI Codex

- フックに相当する機構がない。破壊的操作のガードはAGENTS.mdの文章と、Codex自身のサンドボックス+承認ポリシーで担保する。承認ポリシーを緩めるほどAGENTS.mdの文章だけが頼りになることを意識する。
- サンドボックスはデフォルトでworkspace-write+ネットワーク無効。`network_access = true`を安易に設定しない。承認スキップ系のオプション(full-auto相当)はこのテンプレートの運用では使わない。
- Web情報が必要なときは、任意URLへの直接アクセスよりキャッシュ済みWeb検索ツールのほうがプロンプトインジェクションのリスクが低い(公式推奨)。
- グローバル指示は`~/.codex/AGENTS.md`(personal/install.sh・install.ps1で反映)。AGENTS.mdには読み込みサイズ上限があるため、リポジトリのAGENTS.mdを肥大化させすぎない。
- 信頼できないリポジトリはuntrustedとして開くとプロジェクトスコープの設定レイヤーが読み込まれない(不審なリポジトリの設定に乗っ取られない)。
- 課金は認証方式(ChatGPTプラン/APIキー)で異なる。使用量はchatgpt.com/codex/settings/usage(ChatGPT認証)またはplatform.openai.com/usage(API認証)で確認する。
