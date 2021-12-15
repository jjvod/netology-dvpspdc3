## Решения домашнего задания «2.4. Инструменты Git»

Склонировал репозиторий https://github.com/hashicorp/terraform.git

---

#### 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

Выполнил `git show aefea`, вывод которой показал:
```
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md


... ну и diff дальше
```

Ответ:
   - полный хеш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
   - комментарий коммита: Update CHANGELOG.md

#### 2. Какому тегу соответствует коммит `85024d3`?

Выполнил `git show 85024d3` вывод:
```
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23
```

Ответ: коммит `85024d3` соответствует тегу  `v0.12.23`

#### 3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

Выполнил `git show b8d720` вывод:

```
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: 56cd7859e 9ea88f22f
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Jan 21 17:45:48 2020 -0800

    Merge pull request #23916 from hashicorp/cgriggs01-stable
    
    [Cherrypick] community links

```
Ответ: это мерж-коммит имеет двух родителей:
   - 56cd7859e (56cd7859e05c36c06b56d013b55a252d0bb7e158) <-- тоже мерж-коммит в свою очередь
   - 9ea88f22f (9ea88f22fc6269854151c571162c5bcf958bee2b)

#### 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами `v0.12.23` и `v0.12.24`

Используем `git log --oneline v0.12.23..v0.12.24` вывод со всеми хэшами:

```
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
```

#### 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы)

Здесь уже интереснее..

Найдем файл где определена функция `git grep 'func providerSource('`

Получим: `provider_source.go:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
`

Функция лежит в файле `provider_source.go`
Просмотрим лог `git log -L :'func providerSource(':provider_source.go`, найдем коммит:
```
8c928e835 main: Consult local directories as potential mirrors of providers

diff --git a/provider_source.go b/provider_source.go
--- /dev/null
+++ b/provider_source.go
@@ -0,0 +19,5 @@
+func providerSource(services *disco.Disco) getproviders.Source {
+       // We're not yet using the CLI config here because we've not implemented
+       // yet the new configuration constructs to customize provider search
+       // locations. That'll come later.
+       // For now, we have a fixed set of search directories:

```

Ответ: это коммит `8c928e835` ветки `main` с комментарием `Consult local directories as potential mirrors of providers`

#### 6. Найдите все коммиты в которых была изменена функция globalPluginDirs

Найдем файл где определена функция `git grep -p 'func globalPluginDirs('`. 
Это файл `plugins.go`. Далее `git log -L :'func globalPluginDirs(':plugins.go` выдаст нам все коммиты, это:
   - 78b12205587fe839f10d946ea3fdc06719decb05
   - 52dbf94834cb970b510f2fba853a5b49ad9b1a46
   - 41ab0aef7a0fe030e84018973a64135b11abcd70
   - 66ebff90cdfaa6938f26f908c7ebad8d547fea17
   - 8364383c359a6b738a436d1b7745ccdce178df47q

#### 7. Кто автор функции synchronizedWriters?

`git log -S'synchronizedWriters' --oneline` показывает:

```
bdfea50cc remove unused
fd4f7eb0b remove prefixed io
5ac311e2a main: synchronize writes to VT100-faker on Windows
```

Далее `git show 5ac311e2a` и видим:

```
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700
```
и прочие строки, среди которых искомое
```
...
+func synchronizedWriters(targets ...io.Writer) []io.Writer {
+       mutex := &sync.Mutex{}
+       ret := make([]io.Writer, len(targets))
+       for i, target := range targets {
+               ret[i] = &synchronizedWriter{
+                       Writer: target,
+                       mutex:  mutex,
+               }
+       }
+       return ret
+}

...
```

Ответ: автор функции synchronizedWriters -- **Martin Atkins** 