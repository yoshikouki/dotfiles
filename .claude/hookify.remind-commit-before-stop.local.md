---
name: remind-commit-before-stop
enabled: true
event: stop
pattern: .*
action: warn
---

⚠️ **未コミット変更の確認**

タスク完了前に `git status` を確認してください。
変更したファイルをコミットし忘れていませんか？

**推奨アクション:**
1. `git status` で変更を確認
2. `git add [files]` で変更をステージング
3. `git commit -m "type(scope): describe WHY"` でコミット

「変更のたびにコミット」を忘れないようにしましょう！
