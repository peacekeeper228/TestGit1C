﻿
Функция ШаблонURL1Get(Запрос)
    Ответ = Новый HTTPСервисОтвет(200);  
	ПарНомер = Запрос.ПараметрыЗапроса.Получить("requestYa");
    Результат = Сервер.ЗапросВЯндекс(ПарНомер);
	Ответ.УстановитьТелоИзСтроки(Результат.ТекстОтвета,КодировкаТекста.UTF8);	
	Ответ.Заголовки.Вставить("Content-Type","text/html; charset=utf-8"); 
	Возврат Ответ;
КонецФункции                