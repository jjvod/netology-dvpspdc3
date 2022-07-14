# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

>### Ответ:
 
>Скачали и установили
```bash
user@user-Aspire-5750G:~/Загрузки$ wget "https://go.dev/dl/go1.18.4.linux-amd64.tar.gz"
--2022-07-14 14:07:35--  https://go.dev/dl/go1.18.4.linux-amd64.tar.gz
Распознаётся go.dev (go.dev)… 216.239.34.21, 216.239.38.21, 216.239.36.21, ...
Подключение к go.dev (go.dev)|216.239.34.21|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа… 302 Found
Адрес: https://dl.google.com/go/go1.18.4.linux-amd64.tar.gz [переход]
--2022-07-14 14:07:35--  https://dl.google.com/go/go1.18.4.linux-amd64.tar.gz
Распознаётся dl.google.com (dl.google.com)… 142.250.150.136, 142.250.150.93, 142.250.150.91, ...
Подключение к dl.google.com (dl.google.com)|142.250.150.136|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа… 200 OK
Длина: 141812725 (135M) [application/x-gzip]
Сохранение в: «go1.18.4.linux-amd64.tar.gz»

go1.18.4.linux-amd64.tar.gz                          100%[===================================================================================================================>] 135,24M  10,4MB/s    за 13s

2022-07-14 14:07:48 (10,4 MB/s) - «go1.18.4.linux-amd64.tar.gz» сохранён [141812725/141812725]

user@user-Aspire-5750G:~/Загрузки$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.4.linux-amd64.tar.gz
user@user-Aspire-5750G:~/Загрузки$ export PATH=$PATH:/usr/local/go/bin
user@user-Aspire-5750G:~/Загрузки$ go version
go version go1.18.4 linux/amd64
```

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

>### Ответ:

>1.Код доступен по [ссылке](source/1/1.go). 
```go
package main

import (
	"fmt"
)

func FootToMeter(x float64) float64 {
	return x * 0.3048
}

func main() {
	var input float64
	fmt.Print("Enter a number: ")
	fmt.Scanf("%f", &input)
	fmt.Println(FootToMeter(input))
}
```

>Результат выполнения программы:
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-05-golang/source$ go run 1.go
Enter a number: 10
3.048
```

>2.Код доступен по [ссылке](source/2/2.go).

```go
package main

import "fmt"

func main() {
	var x = []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	var min = x[0]

	for _, el := range x[1:] {
		fmt.Printf("%v ",el)
		if el < min {
			min = el
		}
	}

	fmt.Printf("\n min=%v \n",min)
}

```

>Результат выполнения программы:
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-05-golang/source$ go run 2.go
96 86 68 57 82 63 70 37 34 83 27 19 97 9 17
 min=9
```

>3.Код доступен по [ссылке](source/3/3.go). 

```go
package main

import "fmt"

func minListValue(list []int) int {
	var min = list[0]

	for _, el := range list[1:] {
		if el < min {
			min = el
		}
	}

	return min
}


func main() {
	var x = []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	var min = minListValue(x)

	fmt.Printf("\n min=%v \n",min)
}


```

>Результат выполнения программы:
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-05-golang/source$ go run 3.go
3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99
```

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

>### Ответ:

>1.Код доступен по [ссылке](source/1/1_test.go). 
```go
package main

import "testing"

func TestFootToMeter(t *testing.T) {
	res := FootToMeter(2500)
	if res != 762 {
		t.Errorf("Value was incorrect, got: %f, want: %d.", res, 762)
	}
}
```
>Результат выполнения теста:
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-05-golang/source/1$ go test
PASS
ok      _/home/user/netology-dvpspdc3/07-terraform-05-golang/source/1   0.002s
```

>2.Код доступен по [ссылке](source/2/2_test.go). 
```go
package main

import (
	"testing"
)

func TestminListValue(t *testing.T) {
	min := minListValue([]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 5, 17})
	if min != 5 {
		t.Errorf("Sum was incorrect, got: %d, want: %d.", min, 762)
	}
}

```
>Результат выполнения теста:
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-05-golang/source/2$ go test
testing: warning: no tests to run
PASS
ok      _/home/user/netology-dvpspdc3/07-terraform-05-golang/source/2   0.003s
```