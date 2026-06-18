# Развернуть arcs для нового проекта

Тулинг живёт в этом репо (`~/Documents/projects/arcs`). Проект получает только `.arcs/`.
Метод не засоряет код: всё бухгалтерство в скрытой `.arcs/`, CLI/skill — снаружи.

## 1. CLI на PATH (один раз)
Добавь в `~/.zshrc`:
```bash
export PATH="$HOME/Documents/projects/arcs/bin:$PATH"
```
Перезапусти шелл → команда `arcs` доступна откуда угодно.

Проверка:
```bash
arcs help
```

## 2. Завести метод в проекте
Из корня проекта:
```bash
cd my-project
arcs init                 # создаёт .arcs/{arcs,goals} + README-пойнтер
```

## 3. Работать
```bash
arcs new-goal payments            # многоарочная работа → .arcs/goals/01-payments/
arcs new-arc -g payments stripe   # арка внутри цели
arcs new-arc spike-redis          # одиночная арка → .arcs/arcs/NN-...
arcs status                       # доска: что сделано, где узкое горло
```
Дальше — по `SPEC.md`: input → workspace → output, наружу только output.

## 4. Claude-skill (опционально)
Skill-исходник — `skill/SKILL.md` в этом репо. Установить глобально симлинком (не копией,
чтоб правка в репо сразу подхватывалась):
```bash
ln -s ~/Documents/projects/arcs/skill ~/.claude/skills/arcs
```
После этого агент знает метод и зовёт CLI сам.

## .gitignore проекта
`.arcs/` обычно **коммитим** (это память работы). Если не хочешь — добавь `.arcs/` в `.gitignore`.
