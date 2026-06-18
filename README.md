# arcs

Метод ведения работы файлами. Два примитива — **arc** (атом работы) и **goal** (арка с целью,
держит вложенные арки). Состояние в файлах, не в эфемерном чате. Независим от тулзов.
Вся работа в скрытой `.arcs/` — **не засоряет код проекта**.

```
arcs/                        ← этот репо (тулинг + спека, снаружи проектов)
  SPEC.md                    метод целиком
  bin/arcs                   CLI: init · new-arc · new-goal · status
  template/.arcs/            скелет (arcs/ + goals/)
  skill/SKILL.md             Claude-skill (симлинк в ~/.claude/skills/)
  docs/DEPLOY.md             как развернуть для нового проекта
```

## Суть за 20 секунд
```
.arcs/                       мета-дир в корне проекта
  arcs/NN-slug/              атом: input → workspace → output (наружу только output) + arc.md
  goals/NN-slug/             арка с целью + свои арки
    NN-slug-goal.md          краткий статус, версия = ведущий номер (высший = текущий)
    input/ workspace/ output/ arcs/
```
Вынырнул из работы → открыл текущий `*-goal.md` → видишь где ты. Не теряешься.

## Старт
```bash
export PATH="$HOME/Documents/projects/arcs/bin:$PATH"   # один раз в ~/.zshrc
cd my-project && arcs init
arcs new-goal <slug>     # или: arcs new-arc <slug>
arcs status
```
Подробно — `docs/DEPLOY.md`.
