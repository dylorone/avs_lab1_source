git config --global advice.defaultBranchName false

rm -rf lab0

find_file() {
      echo `find . -name $1`
}

mkdir lab0; cd lab0
git init
git remote add origin git@github.com:dylorone/avs_lab1.git

echo -e "1. Создание дерева каталогов и файлов"

mkdir -p claude_monet/kitchen/morning_shift \
         claude_monet/kitchen/evening_shift \
         claude_monet/hall \
         claude_monet/office \
         staff_room \
         reserve_empty

touch claude_monet/kitchen/morning_shift/senya_tasks \
      claude_monet/kitchen/morning_shift/fedya_tasks \
      claude_monet/kitchen/evening_shift/max_tasks \
      claude_monet/kitchen/evening_shift/denis_tasks \
      claude_monet/kitchen/leva_order \
      claude_monet/hall/table_plan \
      claude_monet/hall/complaints \
      claude_monet/office/barinov_schedule \
      staff_room/late_report \
      shift_message

cd ..

cat <<EOF > $(find_file 'senya_tasks')
Сеня принимает мясо в начале смены
До открытия нужно подготовить горячий цех
Лёва ждёт отчёт о продуктах
После обеда проверить остатки на складе
EOF

cat <<EOF > $(find_file 'fedya_tasks')
Федя проверяет свежесть рыбы
Утром подготовить холодные закуски
Перед подачей показать блюдо Лёве
В конце смены убрать рабочее место
EOF

cat <<EOF > $(find_file 'max_tasks')
Макс приходит на вечернюю смену
Первое блюдо готовится для седьмого столика
Баринов поручил Максу новый соус
После закрытия помочь Лёве с отчётом
EOF

cat <<EOF > $(find_file 'denis_tasks')
Денис выступает перед гостями вечером
До концерта он помогает на кухне
В середине смены приготовить заказ Нагиева
Последнее блюдо передать официантам
EOF

cat <<EOF > $(find_file 'leva_order')
Лёва распределяет задачи между поварами
Утренняя смена готовит ресторан к открытию
Вечерняя смена отвечает за банкет
Все отчёты передать Лёве после закрытия
EOF

cat <<EOF > $(find_file 'table_plan')
Столик один обслуживает Настя
Столик три оставить для постоянных гостей
Столик семь принимает большой заказ
Банкетный стол подготовить к вечеру
EOF

cat <<EOF > $(find_file 'complaints')
Гость долго ждал блюдо от Макса
За третьим столиком забыли принести напитки
Один заказ вернули на кухню
Вика просит разобрать жалобы после смены
EOF

cat <<EOF > $(find_file 'barinov_schedule')
Баринов приходит на кухню до открытия
В полдень шеф проверяет утреннюю смену
Перед банкетом проходит общее собрание
Лёва докладывает шефу после закрытия
EOF

cat <<EOF > $(find_file 'late_report')
Сеня опоздал на утреннюю смену
Макс перепутал время собрания
Лёва записал объяснения поваров
Повторные опоздания передадут Баринову
EOF

cat <<EOF > $(find_file 'shift_message')
Команда собирается за час до открытия
Лёва назначен старшим на текущую смену
Вика проверяет готовность зала
Баринов ждёт общий отчёт утром
EOF

cd lab0

git status
git add .
git commit -m "First subtask"
git push origin master

echo -e "\n2. Установка прав доступа"

chmod 755 $(find_file 'claude_monet')
chmod u=rwx,g=rx,o=--- $(find_file 'kitchen')
chmod 750 $(find_file 'morning_shift')
chmod u=rw,g=r,o=--- $(find_file 'senya_tasks')
chmod 640 $(find_file 'fedya_tasks')
chmod u=rwx,g=rx,o=--- $(find_file 'evening_shift')
chmod 644 $(find_file 'max_tasks')
chmod u=rw,g=r,o=r $(find_file 'denis_tasks')
chmod 660 $(find_file 'leva_order')
chmod u=rwx,g=rx,o=rx $(find_file 'hall')
chmod 644 $(find_file 'table_plan')
chmod u=rw,g=rw,o=r $(find_file 'complaints')
chmod 750 $(find_file 'office')
chmod u=rw,g=r,o=--- $(find_file 'barinov_schedule')
chmod u=rwx,g=rx,o=--- $(find_file 'staff_room')
chmod 640 $(find_file 'late_report')
chmod 700 $(find_file 'reserve_empty')
chmod u=rw,g=r,o=r $(find_file 'shift_message')

tree -p

git status
git add .
git commit -m "Second subtask"
git push origin master

echo -e "\n3. Копирование, перемещение и создание ссылок"

cp staff_room/late_report claude_monet/office/discipline_report
cp -r claude_monet/kitchen/morning_shift claude_monet/kitchen/evening_shift/morning_backup
ln -s ../claude_monet/kitchen/leva_order staff_room/current_order
ln -s claude_monet/kitchen shift_kitchen
ln shift_message claude_monet/kitchen/common_message
cat claude_monet/kitchen/morning_shift/senya_tasks claude_monet/kitchen/morning_shift/fedya_tasks > claude_monet/kitchen/morning_report
cat claude_monet/office/barinov_schedule >> claude_monet/kitchen/leva_order
mv claude_monet/hall/complaints claude_monet/office/guest_complaints

git status
git add .
git commit -m "Third subtask"
git push origin master

echo -e "\n4. Поиск, фильтрация и обработка данных"

ls -lRp | grep -v "^$" | grep -Ev "/|total|\.:" | sort -k 5 -r | head -n 5
grep -hriE 'смен|лёва' | grep -v 'отчёт' | sort | head -n 6
grep -lr 'смен' claude_monet/kitchen/morning_shift/ claude_monet/kitchen/evening_shift/morning_backup/ | wc -l
tail -n 2 `find claude_monet/kitchen/morning_shift/ claude_monet/kitchen/evening_shift/ -type f | grep -E ".+_tasks"` | grep -iE "лёва|смен" | sort -r
cat claude_monet/kitchen/morning_report | grep -Ev 'Сеня|Федя' | sort -r | head -n 4 | wc -w
ls -lR | grep " 2 " | sort -k 8
ls -lR | grep "\->" | grep -v "shift" | sort -rk 8

git status
git add .
git commit -m "Fourth subtask"
git push origin master

echo -e "\n5. Удаление файлов, ссылок и каталогов"

rm staff_room/late_report
rm staff_room/current_order
rm shift_kitchen
rm shift_message
rm claude_monet/kitchen/common_message
rm claude_monet/kitchen/evening_shift/denis_tasks
rmdir reserve_empty
rm -rf claude_monet/kitchen/evening_shift/morning_backup

git status
git add .
git commit -m "Fifth subtask"
git push origin master
