#!/bin/bash

# Проверяем, равно ли количество аргументов командной строки двум
if [[ "$#" -ne 2 ]]; then
    # Выходим с кодом ошибки 1, если количество аргументов неправильное
    exit 1
fi

# Присваиваем первый аргумент командной строки переменной input_dir
input_dir=$1
# Присваиваем второй аргумент командной строки переменной output_dir
output_dir=$2

# Создаем директорию output_dir, если он не существует
mkdir -p "$output_dir"

# Определяем функцию для копирования файла в каталог назначения
copy_file () {
    #переменная для пути к файлу, который нужно скопировать
    local file_path=$1
    # Извлекаем базовое имя файла
    local base_name=$(basename "$file_path")
    # Определяем начальный путь назначения
    local destination="$output_dir/$base_name"

    # Проверяем, существует ли уже файл с таким же именем в каталоге назначения
    if [[ -e $destination ]]; then
        # Инициализируем счетчик для добавления к имени файла в случае дубликата
        local counter=1
        # Извлекаем расширение файла
        local file_extension="${base_name##*.}"
        # Извлекаем имя файла без расширения
        local file_name="${base_name%.*}"

        # Цикл для нахождения уникального имени файла путем увеличения счетчика
        while [[ -e "$output_dir/${file_name}_$counter.$file_extension" ]]; do
            ((counter++))
        done
        # Обновляем путь назначения новым уникальным именем файла
        destination="$output_dir/${file_name}_$counter.$file_extension"
    fi

    # Копируем файл в новое место назначения
    cp "$file_path" "$destination"
}

# Ищем все файлы в директории input и её поддиректориях
find "$input_dir" -type f | while read -r file; do
    # Вызываем функцию copy_file для каждого найденного файла
    copy_file "$file"
done
