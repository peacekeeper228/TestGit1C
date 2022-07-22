﻿Функция ЗаписатьВРегистр(ТекстЗапроса, ВремяВыполнения, ВремяДо) Экспорт
	НоваяЗапись = РегистрыСведений.ИсторияЗапросов.СоздатьМенеджерЗаписи();
	НоваяЗапись.ТекстЗапроса = ТекстЗапроса;
	НоваяЗапись.ВремяПолученияОтвета = ВремяВыполнения;
	НоваяЗапись.ДатаИВремяОбращения = ВремяДо;
	НоваяЗапись.Записать(Истина);
КонецФункции

Функция ЗапросВЯндекс(ТекстЗапроса) Экспорт
	ВремяДо = ТекущаяДата();
    Соединение = Новый HTTPСоединение(
        "ya.ru", // сервер (хост)
        443, // порт, по умолчанию для http используется 80, для https 443
        , // пользователь для доступа к серверу (если он есть)
        , // пароль для доступа к серверу (если он есть)
        , // здесь указывается прокси, если он есть
        , // таймаут в секундах, 0 или пусто - не устанавливать
       Новый ЗащищенноеСоединениеOpenSSL()
    );   
	Заголовки = Новый Соответствие;
 	Заголовки.Вставить("User-Agent", "Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20100101 Firefox/4.0.1");
    ОтветЯндекса = "";
    Запрос = Новый HTTPЗапрос("/yandsearch?text="+ТекстЗапроса, Заголовки); 
    Результат = Соединение.Получить(Запрос); 
	Если Результат.КодСостояния = 302 Тогда 
 		URI = Сервер.СтруктураURI(Результат.Заголовки.Получить("Location"));
 		Если URI.Схема = "https" Тогда
 			БезопасноеСоединение = Новый HTTPСоединение(URI.ИмяСервера,443,,,,,Новый ЗащищенноеСоединениеOpenSSL());
 			Ответ = БезопасноеСоединение.Получить(Новый HTTPЗапрос(URI.ПутьНаСервере));
 			Если Ответ.КодСостояния = 200 Тогда  
				ОтветЯндекса=Ответ.ПолучитьТелоКакСтроку();
 			КонецЕсли;
 		КонецЕсли;
	КонецЕсли; 
	
	ВремяПосле = ТекущаяДата();
	ВремяВыполнения = ВремяПосле - ВремяДо; 
	
    ИтоговыйОтвет = Новый Структура;
	ИтоговыйОтвет.Вставить("Время",ВремяВыполнения);
	ИтоговыйОтвет.Вставить("ТекстОтвета", ОтветЯндекса);
	ИтоговыйОтвет.Вставить("КодСостояния", Ответ.КодСостояния); 
	
	Сервер.ЗаписатьВРегистр(ТекстЗапроса, ВремяВыполнения, ВремяДо); 
	
	Возврат ИтоговыйОтвет;
КонецФункции  

Функция СтруктураURI(Знач СтрокаURI) Экспорт
 СтрокаURI = СокрЛП(СтрокаURI);
 
 Схема = "";
 Позиция = Найти(СтрокаURI, "://");
 Если Позиция > 0 Тогда
 Схема = НРег(Лев(СтрокаURI, Позиция - 1));
 СтрокаURI = Сред(СтрокаURI, Позиция + 3);
 КонецЕсли;
 
 СтрокаСоединения = СтрокаURI;
 ПутьНаСервере = "";
 Позиция = Найти(СтрокаСоединения, "/");
 Если Позиция > 0 Тогда
 ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
 СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
 КонецЕсли;
 
 СтрокаАвторизации = "";
 ИмяСервера = СтрокаСоединения;
 Позиция = Найти(СтрокаСоединения, "@");
 Если Позиция > 0 Тогда
 СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
 ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
 КонецЕсли;
 
 Логин = СтрокаАвторизации;
 Пароль = "";
 Позиция = Найти(СтрокаАвторизации, ":");
 Если Позиция > 0 Тогда
 Логин = Лев(СтрокаАвторизации, Позиция - 1);
 Пароль = Сред(СтрокаАвторизации, Позиция + 1);
 КонецЕсли;
 
 Хост = ИмяСервера;
 Порт = "";
 Позиция = Найти(ИмяСервера, ":");
 Если Позиция > 0 Тогда
 Хост = Лев(ИмяСервера, Позиция - 1);
 Порт = Сред(ИмяСервера, Позиция + 1);
 КонецЕсли;
 
 Результат = Новый Структура;
 Результат.Вставить("Схема", Схема);
 Результат.Вставить("Логин", Логин);
 Результат.Вставить("Пароль", Пароль);
 Результат.Вставить("ИмяСервера", ИмяСервера);
 Результат.Вставить("Хост", Хост);
 Результат.Вставить("Порт", ?(Порт <> "", Число(Порт), Неопределено));
 Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
 
 Возврат Результат;
КонецФункции