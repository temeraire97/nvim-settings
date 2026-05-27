# nvim-settings

[LazyVim](https://www.lazyvim.org/) 기반 개인 Neovim 설정.

## 빠른 시작 (새 머신)

```bash
git clone git@github.com:temeraire97/nvim-settings.git /tmp/nvim-settings
bash /tmp/nvim-settings/install.sh
```

스크립트가 자동으로 수행:

1. 기존 `~/.config/nvim`, `~/.local/share/nvim`, `~/.local/state/nvim`, `~/.cache/nvim`을 `.bak.YYYYMMDD-HHMMSS`로 백업
2. 이 repo를 `~/.config/nvim`으로 clone (SSH 우선, 실패 시 HTTPS)
3. `nvim --headless "+Lazy! sync" +qa`로 플러그인 사전 설치

이후 `nvim` 실행만 하면 끝. `lazyvim.json`의 extras와 `lazy-lock.json`의 플러그인 버전이 자동 복원됩니다.

### 사전 요구사항

- `git`
- `neovim` (macOS: `brew install neovim`)
- GitHub SSH key (없으면 HTTPS로 자동 fallback)

## 구성

```
~/.config/nvim
├── init.lua                  # stock (LazyVim starter)
├── lazyvim.json              # ★ 활성화된 extras 목록
├── lazy-lock.json            # 플러그인 버전 고정 (재현성)
├── install.sh                # 새 머신 부트스트랩 스크립트
├── lua/
│   ├── config/               # stock (autocmds, keymaps, lazy, options)
│   └── plugins/
│       ├── colorscheme.lua   # ★ solarized-osaka 테마
│       └── explorer.lua      # ★ snacks explorer 숨김 파일 표시
└── (기타 starter 부속: LICENSE, .gitignore, .neoconf.json, stylua.toml)
```

`★` 표시 3개가 개인 커스텀입니다. 나머지는 LazyVim starter 그대로 유지.

## 커스텀 내역

### 1. 컬러스킴 — `lua/plugins/colorscheme.lua`

`craftzdog/solarized-osaka.nvim` 설치 후 `LazyVim` `opts.colorscheme`로 지정.

### 2. Snacks Explorer — `lua/plugins/explorer.lua`

`<leader>e`로 여는 기본 파일 탐색기(snacks)에서 dotfile·gitignore 파일을 기본 표시.

탐색기 안 키맵:

| 키 | 동작 |
|----|------|
| `H` | 숨김 파일(dotfile) 토글 |
| `I` | gitignore 파일 토글 |
| `.` | 현재 디렉터리를 cwd로 |
| `Z` | 모든 디렉터리 닫기 |

### 3. Extras — `lazyvim.json`

`:LazyExtras`로 관리되는 LazyVim 공식 확장팩. 현재 활성화 중:

- **언어**: `typescript` (+`tsgo`, `vtsls`), `python`, `java`, `docker`, `terraform`, `tailwind`, `json`, `yaml`, `toml`, `sql`, `markdown`, `git`
- **포매팅/린트**: `prettier`, `eslint`
- **편집**: `yanky`, `util.dot`
- **AI**: `ai.claudecode`

## 일상 사용

### 플러그인 업데이트

```vim
:Lazy update
```

`lazy-lock.json`이 변경되므로 별도 브랜치로 커밋:

```bash
git checkout -b update-lazy-lock
# nvim 안에서 :Lazy update
git add lazy-lock.json
git commit -m "chore(deps): :Lazy update"
gh pr create && gh pr merge --merge
```

LazyVim이 큰 변경을 도입하면 nvim 켤 때 `NEWS.md`로 알려줍니다.

### Extras 추가/제거

`:LazyExtras` 명령으로 토글하면 `lazyvim.json`이 자동 갱신됩니다. 이 파일도 커밋 대상.

### 커스텀 추가

새 플러그인 설정은 `lua/plugins/`에 새 `.lua` 파일로. `opts` override 방식을 권장 — LazyVim 공식 merge 규칙으로 본체 업데이트와 충돌하지 않습니다.

## 왜 충돌이 없는가

- `~/.config/nvim`은 LazyVim starter의 `.git`을 제거한 **독립 repo**. upstream이 없으니 `git merge` 대상도 없음.
- LazyVim 본체(`LazyVim/LazyVim`)는 `~/.local/share/nvim/lazy/`에 별도 설치. `:Lazy update`로만 갱신되고 이 repo를 건드리지 않음.
- 커스텀은 전부 `lua/plugins/*.lua`의 `opts` override 방식. LazyVim [공식 merge 규칙](https://www.lazyvim.org/configuration/plugins)으로 기본값 위에 안전하게 얹힙니다.

## 라이선스

Apache 2.0 (LazyVim starter 원본 라이선스 유지)
