# テンプレート変更履歴(セッション記録)

このテンプレート自体をエージェントと改良していく過程の記録。テンプレートに変更を加えたセッションごとに、要望・決定事項・設計判断を追記する。

## 2026-07-05: 初版作成(Claude Codeとのセッション)

### 要望

- GitHub Copilot・Claude Code・Codex向けのデフォルト設定を持つリポジトリテンプレートを作る
- Vibe codingではなく、人間が判断するAgentic Codingを指向
- 標準的な注意事項+過去リポジトリから抽出した個人の開発スタイルを入れる
- ドキュメントは日本語ベース、`<ファイル名>_en.md`として英語版も作成・同時更新
- リポジトリではなく個人メモリ(グローバル設定)に置くべきものは別に作成
- AGENTS.mdだけでなく、skills/hooksにしたほうがよいものはそうする
- テンプレート自体のドキュメントは分離し、実運用ではそのフォルダを除けばそのまま使える形にする
- 実運用リポジトリへの適用手順書も作成

### 参考にした資料

オーナーの過去リポジトリのエージェント設定ファイル一式(AGENTS.md・CLAUDE.md・copilot-instructions.md・commands等)。個別のリポジトリ名・アカウント情報・件数などの詳細は本リポジトリのドキュメントには記載しない方針。

### セッション中の決定事項(Q&A)

1. `.claude/`のコマンド・スキルは英語で作成し、日本語訳を`template-docs/ja/`に置く(`commands/`に`commit_en.md`を置くと`/commit_en`という重複コマンドが登録されてしまう問題の回避)
2. 個人設定は`personal/`+反映スクリプト(`install.sh`/`install.ps1`)の形にする
3. ADR雛形(`docs/adr/`)をテンプレートに含める
4. コード内文字列(ログ・エラー・UIラベル)は英語をデフォルトにし、プロジェクト側で上書き可能とする
5. PR/Issueはタイトルのみ英語、本文は日本語(UIが自動生成したPR #1の本文が英語だったことを受けて明文化。AGENTS.mdの言語ルール表・PR規約と個人設定に反映)

### 主な設計判断

- AGENTS.md単一ソース: CopilotとCodexはAGENTS.mdをネイティブサポート(Copilotのコードレビュー/コーディングエージェント対応は2025-11のGitHub変更ログで確認)。Claude Codeは`CLAUDE.md`の`@AGENTS.md`でインポート。
- 薄いポインタファイルには_en版を作らない: `CLAUDE.md`・`.github/copilot-instructions.md`は翻訳対象外とし、ルールをAGENTS.mdに明記。
- hooks: (1)危険Git操作ガード — main/masterへの直接push・force push・`--no-verify`をdeny、その他の破壊的操作はask(自動承認モードでも確認が入る)。(2)日英同期リマインダー — `_en.md`対応ファイルを持つ日本語md編集時にエージェントへ通知。
- skills: `adr`(ADRの作成・非推奨化手順)と`sync-docs-en`(日英同期手順)。hooksのリマインドとskillが連動する設計。
- copilot-code-review.yml: 2026-07時点で公式ドキュメントに記載がないことを確認。過去リポジトリからの互換で残しつつ、確実な手段として`copilot-instructions.md`内の日本語レビュー指示を主とする。
- Dependabot cooldown: サプライチェーン対策として標準装備し、AGENTS.mdのセキュリティ節に「承認なしで削除禁止」を明記(過去リポジトリで発生した削除インシデントの再発防止)。
- 採用しなかったもの: 絵文字禁止は標準に採用、ASCII/日本語間スペース規則はレンダラ依存のため標準にせずsetup-guideのカスタマイズ候補に記載。サブエージェント並列運用パターンはプロジェクト依存が強いため同じくカスタマイズ候補とした。

## 2026-07-05: セキュリティ強化・参考文献・運用ノート・Vibe Coding切替ガイドの追加

### 要望

1. ベストプラクティスとして参照した公式ドキュメントを記録する
2. Anthropic・GitHub・OpenAIの公式セキュリティ推奨事項(製品コードの脆弱性防止、エージェントの危険行動ガードの両面)と照合し、不足を反映する
3. 3ツールでこのテンプレートを使う上での、テンプレートで表現しきれない注意点を追加する
4. Vibe Coding的に開発したい場合の変更点をわかるようにする

### 公式推奨との照合結果

3社共通の推奨のうち、初版時点で不足していたのは以下で、今回反映した:

- 外部由来コンテンツの指示に従わない(プロンプトインジェクション対策): AGENTS.mdセキュリティ節に追加(Claude Code Security・Copilot cloud agentリスク緩和・Codex approvalsの3文書が共通して指摘。Issue/PRコメント経由の実証攻撃報告もあり)
- 依存パッケージの実在・タイポスクワッティング確認: AGENTS.mdに追加
- シークレットファイルのコミット防止: .gitignoreに`.env`系を追加、`git add .env`をフックでask化
- ダウンロードスクリプトの直接実行(`curl | sh`): フックでask化(Claude Codeがcurl/wgetを自動承認しない設計に合わせ、他モードでも効くガードとして)
- エージェントが自分のガードを外すことの防止: protect-config.shを新設(`.claude/settings.json`・hooks・workflows・dependabot.ymlの変更をask化)。Codexのレビューアポリシーが「永続的なセキュリティ弱体化」を検査する設計に倣った
- 認証情報ディレクトリの保護: permissions.denyに`~/.ssh`・`~/.aws`を追加

初版時点で既にカバーされていたもの: 人間レビュー必須のマージフロー、main直push禁止、シークレットのハードコード禁止、dependabot cooldown、破壊的操作の確認、生成コードの検証(検証コマンド+CI)。

### 追加ドキュメント

- `references.md` / `_en.md`: 参照した公式ドキュメント一覧(参照日付き)
- `agent-notes.md` / `_en.md`: Claude Code(hooksのスナップショット・permission mode・Web版のgh不在等)、Copilot(AGENTS.md最近接優先・coding agentの安全装置・再レビュー方法等)、Codex(フック機構なし・サンドボックス既定・untrusted等)の運用ノート
- `vibe-coding.md` / `_en.md`: Vibe Coding切替ガイド(緩めるもの/緩めないもの/追加するもの、AGENTS.md差し替えスニペット付き)

### 検証

新設・変更したフックのガードを17パターンのペイロードでテストし、すべてPASS。なお、このセッション中に前回コミットしたフック自体が有効化され、テストペイロードを含むコマンドがdenyされる(ガードが実際に機能する)ことが図らずも実地確認された。

## 2026-07-05: 指示の簡潔化リファクタリング

### 要望

Anthropicの推奨(指示は簡潔なほど遵守率が高い)に基づき、全設定を見直して冗長・重複・矛盾を解消し、要件を維持したまま2026年7月時点で最適な形に書き換える。

### 見つかった問題と対処

- ADRルールの三重記述(AGENTS.md・docs/adr/README.md・adrスキルに同じ手順が全文重複)+ 循環参照(docs/adr/README.mdが「詳細はAGENTS.md」を指し、AGENTS.mdがREADMEを指す): `docs/adr/README.md`を唯一の正(スニペット含む完全版)とし、AGENTS.mdは1行+参照、スキルはトリガー+クイックリファレンスに縮小。
- 整合性チェックリストの重複(/commit・/ship・/consistency-checkにほぼ同じ項目): `/consistency-check`を正とし、/shipはそれを参照、/commitは簡易チェック3項目のみに縮小。
- コミット規約の重複記述(AGENTS.md・/commit・/babysit-pr・personalで形式説明を繰り返し): AGENTS.mdを正とし、コマンド側は「AGENTS.mdに従う」+最小限の要点のみに。
- 文章の冗長: AGENTS.md・personal/global-instructions.mdの各節を、要件(確認が必要な操作・言語ルール・禁止事項・セキュリティ項目)を欠かさず圧縮。
- 設計方針「指示は簡潔に(1ルール1か所)」をtemplate-docs/READMEに明文化。

### 削らなかったもの

検証コマンド表・言語ルール表・セキュリティ節の各項目・PR/レビュー/マージの禁止事項・babysit-prの運用ノウハウ(gh 2.88.0要件等)は、いずれも過去の実インシデントまたは公式推奨に由来するため維持。

## 2026-07-05: アカウント情報の除去とメンテナンスガイドの追加

### 要望

1. 過去の経験に基づくことは記載してよいが、個別のアカウント情報(ユーザー名・リポジトリ名)をテンプレート・ドキュメントに残さない。
2. テンプレート自体を今後運用・改良していくための指針を、テンプレートではなくtemplate-docs側に追加する。

### 対応

- ユーザー名入りURLと過去リポジトリの個別名を、全ドキュメント14か所で汎用表現に置換(personal・references・history・README・setup-guide)。「個別のリポジトリ名・アカウント情報は記載しない」を以後の方針としてmaintenance.mdに明記。
- `maintenance.md` / `_en.md`を新設: 原則(AGENTS.mdフロー遵守・1ルール1か所・汎用のもののみ昇格・日英同期とhistory追記の義務)、変更種類ごとの推奨手順(実プロジェクトからの知見還元・フック変更・コマンド/スキル変更・公式仕様への定期追従)、リリース運用、PR前チェックリスト。
- フックのテストハーネスを`tests/hook-tests.sh`としてリポジトリに同梱(従来はセッション内の一時スクリプト)。38ケースすべてPASSを確認。フック変更時はテストも同じ変更で追加する運用とした。

## 2026-07-05: 改行コード問題の原因究明と、ワークアラウンド禁止ルールの追加

### 経緯

「.gitattributesでmdはLF指定なのにCRLFのファイルがあり混乱した」との指摘を受けて調査した。

- 原因: 初期コミットのREADME.mdが、`.gitattributes`が追加される前のコミットでCRLFのままblobとして格納されていた。gitの属性はコミット/チェックアウト時にしか作用しないため、格納済みblobのCRLFは属性を後から追加しても残り続ける。「触っていないのにREADME.mdがmodified扱いになる」症状はこれが原因。
- 現状: 全blobと作業ツリーがLFであることを検証済み(該当blobはテンプレート初回コミットの書き直しで解消)。属性が効いている現在は、CRLFを書き込んでもコミット時にLFへ正規化されるため、リポジトリにCRLFのmdが入ることはない。
- 反省: セッション冒頭にこの異常(phantom modified)を観測しながら、原因を特定せず書き換えで通過していた。まさに「原因不明のままのワークアラウンド」であり、下記ルール追加のきっかけとした。

### 対応

- AGENTS.md「進め方」に追加: 想定外の挙動は原因を特定してから対処する。原因不明のままワークアラウンドで迂回しない(脆弱性や誤ったコード・アーキテクチャの温床になる)。やむを得ない場合は経緯を記録しユーザーに報告する。personal/global-instructions.mdにも同旨を追加。
- `check-line-endings.sh`(新設): LFポリシーのファイルにCRLFが書き込まれたら警告するPostToolUseフック(CRLF指定の`*.ps1`等は除外)。テスト3ケースを追加し、全41ケースPASS。
- setup-guide: 既存リポジトリへ後付け適用する場合の`git add --renormalize .`を追記(今回の原因と同型の事故の予防)。

## 2026-07-05: check-line-endingsフックの撤回と、太字を見出しに使わないルールの追加

### check-line-endingsフックの撤回

前項で追加した`check-line-endings.sh`は、原因(属性追加前に格納された既存blob)に対して過剰な対応だったため、ユーザー判断で撤回した。改行コードはエディタ・gitattributes・renormalizeといった設定側で対応すべき内容であり、フックで都度監視する必要はない。settings.json・テストハーネス・READMEのフック表からも削除した(setup-guideの`git add --renormalize .`の記載は設定側の対応として維持)。

### 太字を見出しに使わないルール

`- 太字ラベル: 説明`のように太字へ見出し・ラベルの意味を持たせる書き方は、構造的な意味を書式で表現する誤りであるため禁止する(絵文字制限と同趣旨)。

- AGENTS.mdの言語ルールに追加: 太字を見出しやラベルの代わりに使わない。ラベル付き箇条書きは「タイトル: 説明」形式で書く(コロン区切りは英語技術文書の一般的な慣例として採用)。
- 既存ドキュメントを一括修正: template-docs配下の10ファイルにあった太字ラベル・太字強調をすべて平文化した。
- 修正時の教訓: 一括置換で`feature/**`(コードスパン内のグロブパターン)の`**`まで除去してしまい、復元した。書式記号の一括置換ではコードスパン・コードブロック内の同一記号に注意する。

## 2026-07-05: babysit-prの環境対応(レビュー対応ループを1コマンドで起動)

レビュー対応ループ(修正→スレッド返信→resolve→再レビュー依頼→No New Comment)を、環境を問わず`/babysit-pr <PR番号>`の一言で指示できるようにした。

- `/babysit-pr`に「環境への適応」節を追加: ローカル(ghあり)はそのまま、claude.ai/code(Webセッション、ghなし)ではGitHub MCPツール+PRイベント購読(`subscribe_pr_activity`)で同じループを回し、マージ/クローズまたはユーザーの停止指示で購読解除する。

## 2026-07-06: 個人設定にStopフック(git状態チェック)を追加

セッション中に`~/.claude/`へ行った設定を、personal/の推奨テンプレートとして取り込んだ。

- `stop-hook-git-check.sh`: 応答終了前に未コミット・未追跡・署名に問題のあるコミット(未署名・署名破損・committerメール不一致。通常GitHubでUnverified表示になる)・未プッシュを検知してエージェントに知らせるStopフック。GitHub生成コミット(committerメールが`noreply@github.com`)をUnverifiedと誤検知していた問題の修正を含み、期待するcommitterメールは変数化した。
- `claude-user-settings-snippet.json`: `~/.claude/settings.json`へのフック登録スニペット。既存設定を壊さないよう自動マージはせず手動とした。
- `install.sh` / `install.ps1`をコピー元・コピー先を取る形に一般化し、フック本体の配置に対応。
- 推奨gitグローバル設定として`fetch.prune true`をREADMEに記載(マージで削除されたリモートブランチの追跡refが残ると、フックがunpushedを誤検知するため)。
- Windowsネイティブ環境はMicrosoft Core Utils(公式coreutils実装)を利用する前提を明記した(ユーザー指定)。microsoft/coreutilsリポジトリで内容を確認: uutils版coreutils・findutils・grepのMicrosoftビルドで、bash・awk・sedは含まれない。したがってフック本体の実行はGit Bash(Claude CodeのBashツールと同じ要件)とする整理。
- agent-notesの「babysit-prはローカル用」の記述を実態に合わせて更新した。

## 2026-07-06: 2テンプレート構成への再構成(/template/ と /template_ja/)

### 要望

トップに`/template/`(すべて英語)と`/template_ja/`(日本語でよいファイルは日本語)の2つのリポジトリテンプレートを持つ構成に再構成する。このリポジトリ自体のルール(テンプレート間の同期)や履歴は、トップと`/docs/`配下に日本語で記録する。

### セッション中の決定事項(Q&A)

1. `_en.md`ファイルと日英同期の仕組み(AGENTS.mdの同期ルール・同期チェックフック・同期スキル)は両テンプレートから除去する。同期はメタリポジトリ(このリポジトリ)のルールとなり、`template/`と`template_ja/`の対応ファイルを揃える新フックで支援する。
2. メタ文書(トップREADME・AGENTS.md・docs/配下)は日本語のみとし、英語版(`_en.md`)は廃止する。英語の成果物は`template/`そのものが担う。
3. `personal/`(個人グローバル設定の推奨)は各テンプレートの中に置く(英語版・日本語版)。
4. セットアップガイドの主シナリオはフォルダコピー(degit等)とし、GitHubの「Use this template」は補足とする。

### 構成の変更内容

- `template/`(全英語)と`template_ja/`(日本語ベース)を新設。それぞれが自己完結したリポジトリテンプレート(AGENTS.md・CLAUDE.md・.github・.claude・docs/adr・personal)。
- 旧`template-docs/ja/`の日本語コマンド訳は、`template_ja/.claude/commands/`の正式なコマンド(frontmatter・`$ARGUMENTS`付き)へ昇格した。
- 旧トップのテンプレート一式・`_en.md`各種・`sync-docs-en`スキル・日英同期チェックフックは廃止した。
- メタ文書は`template-docs/`から`docs/`へ移動した(history・references・agent-notes・vibe-coding)。setup-guide・maintenanceは2テンプレート構成に合わせて書き直した。
- フックのテストハーネスは`docs/tests/hook-tests.sh`に移動し、新フックのケースと両テンプレートのコード類の同一性チェック(バイト一致)を追加した。

### 主な設計判断

- コード類(hooks・settings.json・install系スクリプト・dotfiles)は両テンプレートでバイト単位一致とし、テストで機械的に検証する。文書類(AGENTS.md・コマンド・スキル)は対訳として意味内容を一致させる。
- 日英同期フック(旧check-docs-en-sync)の後継として、`template/`または`template_ja/`配下のファイル編集時に、もう一方の対応ファイルの同時更新を促すPostToolUseフック(check-template-sync.sh)をメタリポジトリ専用に新設した。対応ファイルが存在しない片側専用ファイル(例: `template_ja/.github/copilot-code-review.yml`)は対象外とする。
- copilot-code-review.yml(レビュー言語の日本語指定)はtemplate_ja側にのみ同梱する。template側はレビュー言語の指定自体が不要なため、copilot-instructions.mdも薄いポインタのみとした。

### レビュー対応

- protect-config.shを強化: `file_path`が相対パスで渡された場合に`*/`前提のcaseパターンを素通りし得る問題(Copilot指摘)への対応として、マッチ前に相対パスを`CLAUDE_PROJECT_DIR`(なければカレント)基準で絶対化する正規化を追加した。相対パスのテストケースも追加。
- check-template-sync.shにも同様の正規化を追加(再レビュー指摘): 相対パス・`./`付きパスでもテンプレート配下の判定が働くよう、`CLAUDE_PROJECT_DIR`基準で絶対化してからリポジトリ相対に変換する。対応ファイルの存在確認もリポジトリルート基準にし、相対パスのテストケースを追加。
- .editorconfigのPowerShellセクションを`[*.ps1]`のみに修正(再レビュー指摘): `.psd`/`.psm`は実在しない拡張子(正しくは`.psd1`/`.psm1`)で、`.gitattributes`が`*.psd1`/`*.psm1`をLFと定める方針とも矛盾して見えるため、CRLF指定は`.ps1`に限定した。
- /shipの完了報告文言を/consistency-checkの正式表記(「整合性チェック OK」/ "consistency check OK")に統一(再レビュー指摘)。
- stop-hook-git-check.shのjqへのJSON受け渡しを`echo`から`printf '%s'`に変更(再レビュー指摘): 入力が`-n`等で始まる場合のシェル実装差による誤動作を避け、他のフックと書き方を統一。
- .editorconfigの`[*.{bat,cmd}]`から`charset = sjis`を削除(再レビュー指摘): `sjis`はEditorConfig標準外の値で多くの実装が無視するため、無効な指定を置かず「cmd.exeはシステムロケールのコードページ(日本語WindowsはCP932)前提。エンコーディングはエディタ側で設定する」という意図をコメントで残した。Copilot案のutf-8-bomは、日本語Windowsのcmd.exeで文字化けの実害があるため採用しない。

## 2026-07-08: テンプレート内からメタリポジトリ名を除去

- 要望: `template/`・`template_ja/`配下に、元リポジトリ(suagtemplate)であることがわかる記述を残さない。テンプレート検討用のリポジトリ名は適用先ではノイズになるため。
- 対応: 両テンプレートのREADMEから出自の一文を削除し、`personal/global-instructions.md`のリポジトリ名を「エージェント設定テンプレートリポジトリ」に一般化した。
- 方針: 今後もテンプレート配下にはメタリポジトリ名を書かない(「個別のリポジトリ名を書かない」品質ルールの適用範囲を明確化)。

## 2026-07-10: 情報源ルールの追加とテーブル書式の統一(ユーザー直接コミット)+レビュー修正

### ユーザーによる変更(mainへの直接コミット)

- 両テンプレートのAGENTS.mdに「情報源」節を追加: Qiita・Zenn・note・AI生成記事・SEO記事は指定時以外参照しない。公式仕様→公式リポジトリのコード→Issue/PR/Discussion→開発者資料→コミュニティ情報(手掛かりのみ・一次情報で確認)の優先順位と、一次情報で確認できない場合の明示ルール。
- AGENTS.mdの表をパディング揃えの書式に統一した。

### レビューでの修正(このリポジトリのルールとの整合)

- template_ja/AGENTS.mdの新設見出しが英語(Information sources)のままだったため「情報源」に修正した(template_jaの言語ルール: ドキュメントは日本語。本文は日本語で見出しのみ直し漏れ)。
- 上記のユーザー変更をhistory.mdに記録した(メタルール: テンプレート変更はhistory追記とセット)。
- 「テンプレート配下にメタリポジトリ名を書かない」方針(2026-07-08の記録)を、正の置き場所であるトップAGENTS.mdの品質ルールに反映した(1ルール1か所)。
