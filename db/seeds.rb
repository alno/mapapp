
# Categories

Category.find_or_create_by_name('Образование').tap do |education|
  education.children.find_or_create_by_name('Детские сады').update_attributes(:keywords => 'детский сад', :table => 'objects', :types => ['kindergarten'], :icon => 'daycare', :default_object_name => 'Детский сад')
  education.children.find_or_create_by_name('Школы').update_attributes(:keywords => 'школа', :table => 'objects', :types => ['school'], :icon => 'school', :default_object_name => 'Школа')
  education.children.find_or_create_by_name('Университеты').update_attributes(:keywords => 'университет', :table => 'objects', :types => ['university'], :icon => 'university', :default_object_name => 'Универститет')
  education.children.find_or_create_by_name('Колледжи').update_attributes(:keywords => 'колледж техникум лицей', :table => 'objects', :types => ['college'], :icon => 'highschool', :default_object_name => 'Колледж')
end

Category.find_or_create_by_name('Здоровье').tap do |health|
  health.children.find_or_create_by_name('Аптеки').update_attributes(:keywords => 'аптека', :table => 'objects', :types => ['pharmacy'], :icon => 'drugstore', :default_object_name => 'Аптека')
  health.children.find_or_create_by_name('Больницы').update_attributes(:keywords => 'больница клиника врач', :table => 'objects', :types => ['hospital'], :icon => 'medicine', :default_object_name => 'Больница')
  health.children.find_or_create_by_name('Клиники').update_attributes(:keywords => 'клиника врач', :table => 'objects', :types => ['doctors'], :icon => 'medicine', :default_object_name => 'Клиника')
  health.children.find_or_create_by_name('Зубные клиники').update_attributes(:keywords => 'зубной зубы клиника', :table => 'objects', :types => ['dentist'], :icon => 'dentist', :default_object_name => 'Зубная клиника')
  health.children.find_or_create_by_name('Ветеринары').update_attributes(:keywords => 'ветеринар ветеринарная клиника', :table => 'objects', :types => ['veterinary'], :icon => 'dentist', :default_object_name => 'Ветеринар')
end

Category.find_or_create_by_name('Спорт').tap do |sport|
  sport.children.find_or_create_by_name('Стадионы').update_attributes(:keywords => 'спорт спортивный стадион', :table => 'objects', :types => ['stadium'], :icon => 'stadium', :default_object_name => 'Стадион')
  sport.children.find_or_create_by_name('Площадки').update_attributes(:keywords => 'спорт спортивная площадка', :table => 'objects', :types => ['pitch'], :default_object_name => 'Спортивная площадка')
  sport.children.find_or_create_by_name('Спортивные школы').update_attributes(:keywords => 'спорт спортивная школа', :table => 'objects', :types => ['sport_school'], :default_object_name => 'Спортивная школа')
  sport.children.find_or_create_by_name('Спортивные центры').update_attributes(:keywords => 'спорт спортивный центр', :table => 'objects', :types => ['sports_centre'], :default_object_name => 'Спортивный центр')
  sport.children.find_or_create_by_name('Бассейны').update_attributes(:keywords => 'бассейн плавание', :table => 'objects', :types => ['swimming_pool'], :icon => 'swimming', :default_object_name => 'Бассейн')
  # sport.children.find_or_create_by_name('Шахматы').update_attributes(:keywords => 'шахматы шахматный', :table => 'objects', :type => 'chess')
  # sport.children.find_or_create_by_name('Шашки').update_attributes(:keywords => 'шашки шашечный', :table => 'objects', :type => 'checkers')
end

Category.find_or_create_by_name('Досуг').tap do |leisure|
  leisure.children.find_or_create_by_name('Парки').update_attributes(:keywords => 'парк', :table => 'objects', :types => ['park','garden'])
  leisure.children.find_or_create_by_name('Детские площадки').update_attributes(:keywords => 'детская площадка', :table => 'objects', :types => ['playground'], :default_object_name => 'Детская площадка')
  leisure.children.find_or_create_by_name('Фонтаны').update_attributes(:keywords => 'фонтан', :table => 'objects', :types => ['fountain'], :icon => 'fountain-2', :default_object_name => 'Фонтан')
  leisure.children.find_or_create_by_name('Кинотеатры').update_attributes(:keywords => 'кино кинотеатр', :table => 'objects', :types => ['cinema'], :icon => 'cinema', :default_object_name => 'Кинотеатр')
  leisure.children.find_or_create_by_name('Театры').update_attributes(:keywords => 'кино кинотеатр', :table => 'objects', :types => ['theatre'], :icon => 'theater', :default_object_name => 'Театр')
  leisure.children.find_or_create_by_name('Катки').update_attributes(:keywords => 'каток коньки', :table => 'objects', :types => ['ice_rink'], :icon => 'iceskating', :default_object_name => 'Каток')
end

Category.find_or_create_by_name('Торговля').tap do |shop|
  shop.children.find_or_create_by_name('Торговые центры').update_attributes(:keywords => 'тц тороговый центр', :table => 'objects', :types => ['mall'], :icon => 'mall', :default_object_name => 'Торговый центр')
  shop.children.find_or_create_by_name('Продуктовые').update_attributes(:keywords => 'мини-маркет минимаркет продукты продуктовый магазин универсам', :table => 'objects', :types => ['convenience'], :icon => 'conveniencestore', :default_object_name => 'Продуктовый магазин')
  shop.children.find_or_create_by_name('Супермаркеты').update_attributes(:keywords => 'супер-маркет супермаркет магазин', :table => 'objects', :types => ['supermarket'], :icon => 'supermarket', :default_object_name => 'Супермаркет')
  shop.children.find_or_create_by_name('Киоски').update_attributes(:keywords => 'киоск', :table => 'objects', :types => ['kiosk'], :icon => 'kiosk', :default_object_name => 'Киоск')
  shop.children.find_or_create_by_name('Магазины одежды').update_attributes(:keywords => 'магазин одежды', :table => 'objects', :types => ['clothes','boutique','underwear'], :icon => 'clothes', :default_object_name => 'Магазин одежды')
  shop.children.find_or_create_by_name('Рынки').update_attributes(:keywords => 'рынок', :table => 'objects', :types => ['marketplace'], :icon => 'market', :default_object_name => 'Рынок')
  shop.children.find_or_create_by_name('Магазины бытовой химии').update_attributes(:keywords => 'бытовая химия', :table => 'objects', :types => ['chemist'], :default_object_name => 'Магазин бытовой химии')
  shop.children.find_or_create_by_name('Хозяйственные магазины').update_attributes(:keywords => 'хозяйственный', :table => 'objects', :types => ['doityourself','hardware'], :icon => 'hardware', :default_object_name => 'Хозяйственный магазин')
  shop.children.find_or_create_by_name('Салоны связи').update_attributes(:keywords => 'мобильные сотовые телефоны магазин салон связи', :table => 'objects', :types => ['mobile_phone'], :icon => 'phones', :default_object_name => 'Саллон мобильной связи')
  shop.children.find_or_create_by_name('Цветочные магазины').update_attributes(:keywords => 'магазин цветы флорист', :table => 'objects', :types => ['florist'], :icon => 'store-flowers', :default_object_name => 'Цветочный магазин')
  shop.children.find_or_create_by_name('Магазины обуви').update_attributes(:keywords => 'магазин обуви обувной', :table => 'objects', :types => ['shoes'], :icon => 'sneakers', :default_object_name => 'Магазин обуви')
  shop.children.find_or_create_by_name('Магазины игрушек').update_attributes(:keywords => 'магазин игрушек детский', :table => 'objects', :types => ['toys'], :icon => 'toys', :default_object_name => 'Магазин игрушек')
  shop.children.find_or_create_by_name('Компьютерные магазины').update_attributes(:keywords => 'компьютерный магазин компьютер', :table => 'objects', :types => ['computer'], :icon => 'computers', :default_object_name => 'Компьютерный магазин')
  shop.children.find_or_create_by_name('Подарки и сувениры').update_attributes(:keywords => 'магазин подарков сувениров', :table => 'objects', :types => ['gift', 'souvenirs'], :icon => 'gifts', :default_object_name => 'Подарки и сувениры')
  shop.children.find_or_create_by_name('Книжные магазины').update_attributes(:keywords => 'книжный магазин книги', :table => 'objects', :types => ['books'], :default_object_name => 'Книжный магазин')
  shop.children.find_or_create_by_name('Ювелирные магазины').update_attributes(:keywords => 'ювелирный магазин', :table => 'objects', :types => ['jewelry'], :icon => 'jewelry', :default_object_name => 'Ювелирный магазин')
  shop.children.find_or_create_by_name('Магазины мебели').update_attributes(:keywords => 'мебельный магазин мебель', :table => 'objects', :types => ['furniture'], :default_object_name => 'Магазин мебели')
  shop.children.find_or_create_by_name('Алкоголь').update_attributes(:keywords => 'магазин алкоголь', :table => 'objects', :types => ['alcohol'], :default_object_name => 'Алкоголь')
  shop.children.find_or_create_by_name('Выпечка').update_attributes(:keywords => 'пекарня выпечка', :table => 'objects', :types => ['bakery'], :default_object_name => 'Выпечка')
  shop.children.find_or_create_by_name('Мясо').update_attributes(:keywords => 'мясо', :table => 'objects', :types => ['butcher'], :default_object_name => 'Мясной')
  shop.children.find_or_create_by_name('Универмаги').update_attributes(:keywords => 'универмаг', :table => 'objects', :types => ['department_store'], :icon => 'departmentstore', :default_object_name => 'Универмаг')
  shop.children.find_or_create_by_name('Оптика').update_attributes(:keywords => 'оптика очки', :table => 'objects', :types => ['optician'], :default_object_name => 'Оптика')
  shop.children.find_or_create_by_name('Часы').update_attributes(:keywords => 'оптика очки', :table => 'objects', :types => ['clock'], :default_object_name => 'Часы')
  shop.children.find_or_create_by_name('Кондитерские').update_attributes(:keywords => 'кондитерская сладости конфеты', :table => 'objects', :types => ['confectionery'], :icon => 'patisserie', :default_object_name => 'Кондитерская')
  shop.children.find_or_create_by_name('Спортивные магазины').update_attributes(:keywords => 'спорт спортивный магазин', :table => 'objects', :types => ['sports'], :default_object_name => 'Спортивный магазин')
  shop.children.find_or_create_by_name('Детские товары').update_attributes(:keywords => 'детские товары', :table => 'objects', :types => ['baby_goods'], :default_object_name => 'Детские товары')
  shop.children.find_or_create_by_name('Электроника').update_attributes(:keywords => 'магазин электроника', :table => 'objects', :types => ['electronics','hifi'], :default_object_name => 'Магазин электроники')
  shop.children.find_or_create_by_name('Фотостудии').update_attributes(:keywords => 'магазин фотостудии', :table => 'objects', :types => ['photo','photostudio'], :icon => 'photography', :default_object_name => 'Фотостудия')
  shop.children.find_or_create_by_name('Фрукты, овощи').update_attributes(:keywords => 'магазин фрукты овощи', :table => 'objects', :types => ['greengrocer'], :icon => 'grocery', :default_object_name => 'Фрукты, овощи')
end

Category.find_or_create_by_name('Авто', :keywords => 'автомобиль автомоблильный машина').tap do |auto|
  auto.children.find_or_create_by_name('Автомагазины').update_attributes(:keywords => 'автомагазин автосалон', :table => 'objects', :types => ['car'], :icon => 'car', :default_object_name => 'Автосалон')
  auto.children.find_or_create_by_name('Автомойки').update_attributes(:keywords => 'автомагазин', :table => 'objects', :types => ['car_wash'], :icon => 'carwash', :default_object_name => 'Автомойка')
  auto.children.find_or_create_by_name('Авторемонт').update_attributes(:keywords => 'авторемонт', :table => 'objects', :types => ['car_repair'], :icon => 'carrepair', :default_object_name => 'Авторемонт')
  auto.children.find_or_create_by_name('Автозапчасти').update_attributes(:keywords => 'автозапчасти запастные части', :table => 'objects', :types => ['car_parts'], :icon => 'carrepair', :default_object_name => 'Автозапчасти')
  auto.children.find_or_create_by_name('Заправки').update_attributes(:keywords => 'заправка автозаправка', :table => 'objects', :types => ['fuel'], :icon => 'filling-station', :default_object_name => 'Автозаправка')
  auto.children.find_or_create_by_name('Парковки').update_attributes(:keywords => 'автопарковка стоянка', :table => 'objects', :types => ['parking'], :icon => 'filling-station', :default_object_name => 'Парковка')
  auto.children.find_or_create_by_name('Автошкола').update_attributes(:keywords => 'автошкола вождение', :table => 'objects', :types => ['driving_school'], :default_object_name => 'Автошкола')
end

Category.find_or_create_by_name('Услуги').tap do |service|
  service.children.find_or_create_by_name('Банки').update_attributes(:keywords => 'банк', :table => 'objects', :types => ['bank'], :icon => 'bank', :default_object_name => 'Банк')
  service.children.find_or_create_by_name('Банкоматы').update_attributes(:keywords => 'банкомат', :table => 'objects', :types => ['atm'], :icon => 'atm-2', :default_object_name => 'Банкомат')
  service.children.find_or_create_by_name('Фаст-фуд').update_attributes(:keywords => 'еда фаст-фуд', :table => 'objects', :types => ['fast_food'], :icon => 'fastfood', :default_object_name => 'Кафе быстрого питания')
  service.children.find_or_create_by_name('Кафе').update_attributes(:keywords => 'еда кафе', :table => 'objects', :types => ['cafe'], :icon => 'coffee', :default_object_name => 'Кафе')
  service.children.find_or_create_by_name('Бары').update_attributes(:keywords => 'бар', :table => 'objects', :types => ['bar','pub'], :icon => 'bar', :default_object_name => 'Бар')
  service.children.find_or_create_by_name('Рестораны').update_attributes(:keywords => 'ресторан еда', :table => 'objects', :types => ['restaurant'], :icon => 'restaurant', :default_object_name => 'Ресторан')
  service.children.find_or_create_by_name('Ночные клубы').update_attributes(:keywords => 'ночной клуб', :table => 'objects', :types => ['nightclub'], :icon => 'restaurant', :default_object_name => 'Ночной клуб')
  service.children.find_or_create_by_name('Отели').update_attributes(:keywords => 'отель гостиница', :table => 'objects', :types => ['hotel','motel'], :icon => 'motel-2', :default_object_name => 'Отель')
  service.children.find_or_create_by_name('Парикмахерские').update_attributes(:keywords => 'парикмахер парикмахерская стрижка', :table => 'objects', :types => ['hairdresser'], :icon => 'barber', :default_object_name => 'Парикмахерская')
  service.children.find_or_create_by_name('Бани, сауны').update_attributes(:keywords => 'баня сауна парная', :table => 'objects', :types => ['sauna'], :default_object_name => 'Баня')

  service.children.find_or_create_by_name('Связь').tap do |conn|
    conn.children.find_or_create_by_name('Телефоны').update_attributes(:keywords => 'телефон телефонный автомат', :table => 'objects', :types => ['telephone'], :icon => 'telephone', :default_object_name => 'Телефон')
    conn.children.find_or_create_by_name('Почтовые ящики').update_attributes(:keywords => 'почтовый ящик', :table => 'objects', :types => ['post_box'], :default_object_name => 'Почтовый ящик')
    conn.children.find_or_create_by_name('Почтовые отделения').update_attributes(:keywords => 'почтовое отделение почта', :table => 'objects', :types => ['post_office'], :default_object_name => 'Почтовое отделение')
  end
end

Category.find_or_create_by_name('Прочее').tap do |other|
  other.children.find_or_create_by_name('Религия').tap do |religy|
    religy.update_attributes(:keywords => 'храм место поклонения', :table => 'objects', :types => ['place_of_worship'], :default_object_name => 'Место поклонения')
  end

  other.children.find_or_create_by_name('Музеи').update_attributes(:keywords => 'музей', :table => 'objects', :types => ['museum'], :default_object_name => 'Музей')
  other.children.find_or_create_by_name('Библиотеки').update_attributes(:keywords => 'библиотека', :table => 'objects', :types => ['library'], :icon => 'library', :default_object_name => 'Библиотека')
  other.children.find_or_create_by_name('Центры искусств').update_attributes(:keywords => 'центр искусств', :table => 'objects', :types => ['arts_centre'], :default_object_name => 'Центр искусств')
  other.children.find_or_create_by_name('Танцевальные залы').update_attributes(:keywords => 'танцевальный зал', :table => 'objects', :types => ['dance'], :default_object_name => 'Танцевальный зал')

  other.children.find_or_create_by_name('Достопримечательности').tap do |memorial|
    memorial.update_attributes(:keywords => 'достопримечательность')
    memorial.children.find_or_create_by_name('Мемориалы').update_attributes(:keywords => 'мемориал памятник', :table => 'objects', :types => ['memorial'], :icon => 'memorial', :default_object_name => 'Памятник')
    memorial.children.find_or_create_by_name('Монументы').update_attributes(:keywords => 'монумент', :table => 'objects', :types => ['monument'], :icon => 'monument', :default_object_name => 'Монумент')
    memorial.children.find_or_create_by_name('Artworks').update_attributes(:keywords => 'произведение искусства', :table => 'objects', :types => ['artwork'], :icon => 'monument', :default_object_name => 'Artwork')
  end

  other.children.find_or_create_by_name('Полиция').update_attributes(:keywords => 'отделение полиции', :table => 'objects', :types => ['police'], :icon => 'police', :default_object_name => 'Отделение полиции')
  other.children.find_or_create_by_name('Пожарные').update_attributes(:keywords => 'пожарные отделение', :table => 'objects', :types => ['fire_station'], :icon => 'firemen', :default_object_name => 'Пожарная станция')
  other.children.find_or_create_by_name('Туалеты').update_attributes(:keywords => 'туалет', :table => 'objects', :types => ['toilets'], :icon => 'toilets', :default_object_name => 'Туалет')
  other.children.find_or_create_by_name('Информация').update_attributes(:keywords => 'информация', :table => 'objects', :types => ['information'], :default_object_name => 'Информация')
  other.children.find_or_create_by_name('Администрация').update_attributes(:keywords => 'администрация', :table => 'objects', :types => ['townhall','goverment','government'], :default_object_name => 'Администрация')
  other.children.find_or_create_by_name('Мусорные баки').update_attributes(:keywords => 'мусорный бак', :table => 'objects', :types => ['recycling','waste_disposal'], :default_object_name => 'Мусорный бак')
  other.children.find_or_create_by_name('Урны').update_attributes(:keywords => 'мусорная корзина урна', :table => 'objects', :types => ['waste_basket'], :default_object_name => 'Урна')
  other.children.find_or_create_by_name('Кладбища').update_attributes(:keywords => 'кладбище', :table => 'objects', :types => ['cemetery','grave_yard'], :default_object_name => 'Кладбище')
  other.children.find_or_create_by_name('Руины').update_attributes(:keywords => 'руины', :table => 'objects', :types => ['ruins'], :icon => 'ruins-2', :default_object_name => 'Руины')

  other.children.find_or_create_by_name('Питьевая вода').update_attributes(:keywords => 'питьевая вода', :table => 'objects', :types => ['drinking_water'], :icon => 'drinkingwater', :default_object_name => 'Питьевая вода')
  other.children.find_or_create_by_name('Колодцы, колонки').update_attributes(:keywords => 'колодце колонка', :table => 'objects', :types => ['water_well','well','artesian_well'], :icon => 'waterwellpump', :default_object_name => 'Колодец, колонка')
  other.children.find_or_create_by_name('Родники').update_attributes(:keywords => 'родник', :table => 'objects', :types => ['spring'], :default_object_name => 'Родник')
end

# Pages

Page.find_or_create_by_slug('about').update_attributes(:title => 'About', :body => '<p>It\'s simple local map service implementation based on <a href="http://openstretmap.org">OpenStreetMap</a></p>')
Page.find_or_create_by_slug('credits').update_attributes(:title => 'Credits', :body => '<p>This service exists thanks to existence of followin projects:</p><ul><li><a href="http://openstreetmap.org">OpenStreetMap</a></li><li><a href="http://mapnik.org/">Mapnik</a></li><li><a href="http://leaflet.cloudmade.com">Leafleat</a></li></ul>')
