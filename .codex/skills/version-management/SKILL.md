---
name: version-management
description: 依存関係、ツール、provider、runtime、インフラ関連のバージョンについて、最新安定版を確認し、安全に制約やlockfileを更新する。Codexが最新安定版の確認、バージョンアップ、lockfile更新、pre-releaseの除外、Terraformやpackage managerなどのversion/state/lockfileの説明を求められたときに使う。
---

# バージョン管理

## ワークフロー

1. バージョン管理対象と、それを制御しているファイルを特定する。
   - 例: Terraform `required_version`、Terraform `required_providers`、`.terraform.lock.hcl`、package managerのmanifest、runtime指定ファイル、CIのsetup version。
2. 信頼できる一次情報から最新安定版を確認する。
   - 公式release page、公式registry、vendor docs、package registry metadataを優先する。
   - 「latest」は記憶に頼らない。
   - ユーザーが明示しない限り、prerelease、beta、rc、nightly、canary、alpha、dev、snapshot版は除外する。
3. 既存リポジトリの流儀に合う、予想外の少ない制約を選ぶ。
   - exact lockfileでは、生成されたexact versionを維持する。
   - tool制約では、既存の書き方に合わせてpatch/minor範囲を適切に制限する。
   - Terraform coreの `~> X.Y.Z` は `>= X.Y.Z, < X.(Y+1).0` を意味する。
   - Terraform providerは `required_providers` でpinまたは範囲指定し、`.terraform.lock.hcl` はTerraformコマンドで更新する。
4. 先に設定ファイルを更新し、その後にnative toolでlockfileを再生成する。
   - 公式の更新コマンドがあるlockfileは手編集しない。例外は、公式手段がなくユーザーがそのtradeoffを許容した場合のみ。
5. 検証する。
   - 可能ならformatとvalidateを実行する。
   - 検証にnetworkやsandbox権限昇格が必要な場合は承認を求め、実行できなかった場合は明記する。

## Terraform

- `.terraform.lock.hcl` はTerraform root moduleごとにGit管理する。
- `.terraform/` と `terraform.tfstate*` はcommitしない。
- `terraform.tfstate` はインフラの実状態として扱い、依存関係metadataとして扱わない。
- `.terraform.lock.hcl` はprovider依存関係metadataとして扱い、インフラの実状態として扱わない。
- providerの最新確認にはTerraform Registryまたは公式provider releaseを使う。
- provider制約を変更した後は、次を実行する。

```bash
terraform init -upgrade
terraform validate
```

これらのコマンドは `environments/dev` のようなroot module directoryで実行する。

## 報告

変更前のversion、確認済みの最新安定version、使用した情報源、変更ファイル、実行したコマンドを報告する。現在の設定が既に最新安定版なら、その旨を明記し、不要な差分を作らない。
