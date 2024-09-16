Функция ОбработкаСтрокиНастройки(СтрокаФайла)
    РезультатОбработки = Новый Структура;
    ИндексРавно = Найти(СтрокаФайла, "=");
    Если ИндексРавно = 0 Тогда
        Сообщить("Отсутствуют знаки = ");
        Возврат Неопределено;
    КонецЕсли;
    СтрокаИмени = СокрЛП(Лев(СтрокаФайла, ИндексРавно - 1));
    СтрокаЗначения = СокрЛП(Прав(СтрокаФайла, СтрДлина(СтрокаФайла) - ИндексРавно));
    РезультатОбработки.Вставить("ИмяПеременной", СтрокаИмени);
    Если Найти(СтрокаЗначения, ";") <> 0 Тогда
      ДанныеЗначений = СтрРазделить(СтрокаЗначения, ";");
    Иначе
      ДанныеЗначений = СтрокаЗначения;
    КонецЕсли;
РезультатОбработки.Вставить("ЗначениеПеременной", ДанныеЗначений);
Возврат РезультатОбработки;
КонецФункции

Функция ОбработатьНастройки()
ФайлНастроек = "настройка.ini";
Текст = Новый ЧтениеТекста;
Текст.Открыть(ФайлНастроек,"UTF-8");
Стр = Текст.ПрочитатьСтроку();
стрданных = Новый Структура;
Пока Стр <> Неопределено Цикл
    ДанныеСтроки = ОбработкаСтрокиНастройки(Стр);
    Если ДанныеСтроки.ИмяПеременной = "Путь" Тогда
        стрданных.Вставить("Путь", ДанныеСтроки.ЗначениеПеременной);
    ИначеЕсли ДанныеСтроки.ИмяПеременной = "Месяц" Тогда  
        стрданных.Вставить("Месяц",ДанныеСтроки.ЗначениеПеременной);
    ИначеЕсли ДанныеСтроки.ИмяПеременной = "Отчет" Тогда  
        стрданных.Вставить("Отчет",ДанныеСтроки.ЗначениеПеременной);
    КонецЕсли;
    Стр = Текст.ПрочитатьСтроку();        
КонецЦикла;
Возврат стрданных;
КонецФункции

Функция УдалитьФайлыПозжеМесяца()
стрданных = ОбработатьНастройки();
Если Не стрданных.Свойство("Путь") ИЛИ Не стрданных.Свойство("Месяц") ИЛИ Не стрданных.Свойство("Отчет") Тогда
    Сообщить("В файле настроек отсутствуют необходимые параметры. Правильный ввод: " +Символы.ПС+ "Путь = C:/ВашПуть/Папка/"+Символы.ПС+ "Месяц = Число" +Символы.ПС+ "Отчет = C:/ВашПуть/НазваниеФайла.txt"+Символы.ПС+ "Завершение работы.");
    Возврат Неопределено;
Иначе
    Сообщить("Все параметры в файле настроек присутствуют");
КонецЕсли;
Месяц = стрданных.Месяц;
ПутьКПапке = стрданных.Путь;
Отчет = стрданных.Отчет;
МесяцевНазад = ДобавитьМесяц(ТекущаяДата(), -Месяц);
масОписание = Новый Массив;
Количество_Удалений = 0;

Для Каждого Путь Из ПутьКПапке Цикл
    СписокФайлов = НайтиФайлы(Путь, "*.*");
    Для Каждого Файл Из СписокФайлов Цикл
        ДатаСоздания = Файл.ПолучитьВремяСоздания();
        Если ДатаСоздания < МесяцевНазад Тогда
            УдалитьФайлы(Файл.ПолноеИмя);
            Количество_Удалений = Количество_Удалений + 1;
            масОписание.Добавить(Файл.Имя + ", " + ДатаСоздания);
        КонецЕсли;
    КонецЦикла; 
КонецЦикла;
ЗаписьОтчета(масОписание, Количество_Удалений, Отчет); 
КонецФункции
Процедура ЗаписьОтчета(масОписание, Количество_Удалений, Отчет)
ФайлОтчета = Новый ЗаписьТекста(Отчет, КодировкаТекста.UTF8);
ФайлОтчета.ЗаписатьСтроку("Дата и время выполнения: " + ТекущаяДата() + Символы.ПС);
Если Количество_Удалений = 0 Тогда
    ФайлОтчета.ЗаписатьСтроку("Нет файлов на удаление")
ИначеЕсли Количество_Удалений > 0 Тогда
    ФайлОтчета.ЗаписатьСтроку("Удалено файлов: " + Количество_Удалений);
    ФайлОтчета.ЗаписатьСтроку("Список удаленных файлов:");
    Для каждого Описание Из масОписание Цикл
        ФайлОтчета.ЗаписатьСтроку(Описание);
    КонецЦикла;
КонецЕсли;
ФайлОтчета.Закрыть();
КонецПроцедуры


УдалитьФайлыПозжеМесяца();
