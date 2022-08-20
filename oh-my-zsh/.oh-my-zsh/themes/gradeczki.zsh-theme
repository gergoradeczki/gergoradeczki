circle_left() {
  echo $'\ue0b6'
}

right_triangle() {
  echo $'\ue0b0'
}

arrow_start() {
  echo "%{$fg[$GLYPH_BG]%}%{$bg[$GLYPH_FG]%}%B%{$fg[$TEXT_FB]%}%{$bg[$TEXT_BG]%}"
}

arrow_end() {
  echo "%{$reset_color%}%{$fg[$NEXT_GLYPH_FG]%}%{$bg[$NEXT_GLYPH_BG]%}$(right_triangle)%{$reset_color%}"
}

username_start() {
  echo "%{$fg[$GLYPH_FG]%}%{$bg[$GLYPH_BG]%}$(circle_left)%{$fg[$TEXT_FB]%}%{$bg[$TEXT_BG]%}"
}

current_time_segment() {
  echo -n "%{$fg[yellow]%}[%*]%{$reset_color%} "
}

username_segment() {
  GLYPH_FG="magenta"
  GLYPH_BG=""
  TEXT_FB="black"
  TEXT_BG="magenta"
  NEXT_GLYPH_FG="magenta"
  NEXT_GLYPH_BG="cyan"
  echo -n "$(username_start) %n@%m $(arrow_end)"
}

directory_segment() {
  GLYPH_FG="cyan"
  GLYPH_BG="cyan"
  TEXT_FB="black"
  TEXT_BG="cyan"
  NEXT_GLYPH_FG="cyan"
  NEXT_GLYPH_BG=""
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    NEXT_GLYPH_BG="yellow"
  fi
  
  echo -n "$(arrow_start) %~ $(arrow_end)"
}

git_prompt_segment() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi

  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    GLYPH_FG="yellow"
    GLYPH_BG="black"
    TEXT_FB="black"
    TEXT_BG="yellow"
    NEXT_GLYPH_FG="yellow"
    NEXT_GLYPH_BG=""
    echo -n "$(arrow_start) $(git_prompt_info) $(arrow_end)"
  fi
}

prompt_indicator_segment() {
  echo "\n\u276f "
}

# set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# set the git_prompt_status text
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✈%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✭%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%} ✱%{$reset_color%}"

build_prompt() {
   current_time_segment
   username_segment
   directory_segment
   git_prompt_segment
   prompt_indicator_segment
}

PROMPT='$(build_prompt)'
