﻿
&НаКлиенте
Процедура ОтправитьЗапрос(Команда)       
	СтрукураОтвета = Сервер.ЗапросВЯндекс(ТекстЗапроса); 
	HtmlОтвет = СтрукураОтвета.ТекстОтвета;
	КодОтвета = СтрукураОтвета.КодСостояния;
	ВремяОтвета = СтрукураОтвета.Время;  
КонецПроцедуры

