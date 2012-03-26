
# Categories

Category.find_or_create_by_name('Образование').tap do |education|
  education.children.find_or_create_by_name('Школы').update_attributes(:keywords => 'школа', :icon => 'school', :table => 'objects', :type => 'school')
  education.children.find_or_create_by_name('Университеты').update_attributes(:keywords => 'университет', :icon => 'university', :table => 'objects', :type => 'university')
end

Category.find_or_create_by_name('Спорт').tap do |sport|
  sport.children.find_or_create_by_name('Стадионы').update_attributes(:keywords => 'спорт спортивный стадион', :icon => 'stadium', :table => 'objects', :type => 'stadium')
  sport.children.find_or_create_by_name('Площадки').update_attributes(:keywords => 'спорт спортивная площадка', :table => 'objects', :type => 'pitch')
  sport.children.find_or_create_by_name('Спортивные школы').update_attributes(:keywords => 'спорт спортивная школа', :table => 'objects', :type => 'sport_school')
  sport.children.find_or_create_by_name('Спортивные центры').update_attributes(:keywords => 'спорт спортивный центр', :table => 'objects', :type => 'sports_centre')
  sport.children.find_or_create_by_name('Шахматы').update_attributes(:keywords => 'шахматы щахматный', :table => 'objects', :type => 'chess')
  sport.children.find_or_create_by_name('Шашки').update_attributes(:keywords => 'шашки щащечный', :table => 'objects', :type => 'checkers')
end

Category.find_or_create_by_name('Досуг').tap do |leisure|
  leisure.children.find_or_create_by_name('Парки').update_attributes(:keywords => 'парк', :table => 'objects', :type => 'park')
end

Page.find_or_create_by_slug('about').update_attributes(:title => 'About', :body => '<p>It\'s simple local map service implementation based on <a href="http://openstretmap.org">OpenStreetMap</a></p>')
Page.find_or_create_by_slug('credits').update_attributes(:title => 'Credits', :body => '<p>This service exists thanks to existence of followin projects:</p><ul><li><a href="http://openstreetmap.org">OpenStreetMap</a></li><li><a href="http://mapnik.org/">Mapnik</a></li><li><a href="http://leaflet.cloudmade.com">Leafleat</a></li></ul>')
