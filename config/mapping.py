from imposm.mapping import (
    Options,
    Points, LineStrings, Polygons,
    String, Bool, Integer, OneOfInt, FieldType,
    set_default_name_type, LocalizedName,
    WayZOrder, ZOrder, Direction,
    GeneralizedTable, UnionView,
    PseudoArea, meter_to_mapunit, sqr_meter_to_mapunit,
)

import yaml
import os


db_yml = yaml.load(file(os.getenv("DB_CONFIG") or "config/database.yml"))
db_env = db_yml[os.getenv("RAILS_ENV") or "development"]

db_conf = Options(
    host=db_env['host'],
    user=db_env['username'],
    password=db_env['password'],
    port=5432,
    sslmode='allow',
    prefix='osm_new_',
    proj='epsg:900913',
)

set_default_name_type(LocalizedName(['name:ru','name','int_name']))

class Length(FieldType):
    column_type = "REAL"

    def value(self, val, osm_elem):
        length = osm_elem.geom.length
        if not length:
            return None

        return length * (40075160 / 360)

    def extra_fields(self):
        return []

class NotArea(Bool):

    def value(self, val, osm_elem):
        if hasattr(osm_elem.coords, 'type'): # Ugly way to detect relations
            return 0

        if val is None or val.strip().lower() in self.neg_aliases:
            return 1  # not self.default
        return 0  # self.default

places = Points(
    name = 'places',
    mapping = {
        'place': (
            'city',
            'town',
            'village'
        ),
    },
    fields = (
        ('z_order', ZOrder(['city','town','village'])),
        ('population', Integer()),
    )
)

roads = LineStrings(
    name = 'roads',
    mapping = {
        'highway': ('__any__',),
    },
    fields = (
        ('z_order', WayZOrder()),
        ('tunnel', Bool()),
        ('bridge', Bool()),
        ('covered', Bool()),
        ('surface', String()),
        ('ref', String()),
        ('length', Length()),
    ),
    field_filter = (
        ('area', Bool()),
    )
)

railways = LineStrings(
    name = 'railways',
    mapping = {
        'railway': ('__any__',),
    },
    fields = (
        ('z_order', WayZOrder()),
        ('tunnel', Bool()),
        ('bridge', Bool()),
        ('length', Length()),
    )
)

buildings = Polygons(
    name = 'buildings',
    mapping = {
        'building': ('__any__',),
    },
    fields = (
        ('addr:housenumber', String()),
    )
)

waterways = LineStrings(
    name = 'waterways',
    mapping = {
        'barrier': (
            'ditch'
        ),
        'waterway': (
            'stream',
            'river',
            'canal',
            'drain',
            'ditch'
        ),
    },
    fields = (
        ('length', Length()),
    ),
    field_filter = (
        ('tunnel', Bool()),
    ),
)

waterareas = Polygons(
    name = 'waterareas',
    mapping = {
        'waterway': (
            'riverbank',
            'dock',
            'mill_pond',
            'canal'
        ),
        'natural': (
            'water',
            'lake',
            'bay'
        ),
        'landuse': (
            'basin',
            'reservoir'
        ),
    },
    fields = (
        ('area', PseudoArea()),
    )
)

landuses = Polygons(
    name = 'landuses',
    mapping = {
        'landuse': ('__any__',),
    },
    fields = (
        ('area', PseudoArea()),
        ('z_order', ZOrder([
            'construction',
            'cemetery',
            'residential',
            'industrial',
            'commercial',
        ])),
    )
)

squares = Polygons(
    name = 'squares',
    mapping = {
        'highway': ('__any__',),
    },
    field_filter = (
        ('area', NotArea()),
    )
)

areas = Polygons(
    name = 'areas',
    mapping = {
        'leisure': (
            'park',
            'garden',
            'playground',
            'golf_course',
            'sports_centre',
            'pitch',
            'stadium',
            'common',
            'nature_reserve',
        ),
        'natural': (
            'wood',
            'land',
            'scrub',
            'wetland',
            'beach',
        ),
        'amenity': ('__any__',),
        'tourism': ('__any__',),
    },
    fields = (
        ('area', PseudoArea()),
        ('z_order', ZOrder([
            'fuel',
            'zoo',
            'footway',
            'pedestrian',
            'parking',
            'school',
            'university',
            'college',
            'hospital',
            'place_of_worship',
            'sports_centre',
            'stadium',
            'pitch',
            'garden',
            'park',
            'playground',
            'common',
            'wood',
            'scrub',
            'wetland',
            'beach',
        ])),
    ),
    field_filter = (
        ('building', Bool()),
    )
)

barrier_lines = LineStrings(
    name = 'barrier_lines',
    mapping = {
        'barrier': (
            'city_wall',
            'fence',
            'hedge',
            'retaining_wall',
            'wall',
            'bollard',
            'gate',
            'spikes',
            'lift_gate',
            'kissing_gate',
            'embankment',
            'yes',
            'wire_fence',
        ),
        'natural': (
            'cliff',
        ),
        'man_made': (
            'enbankment',
        )
    },
    fields = (
        ('length', Length()),
    )
)

barrier_polys = Polygons(
    name = 'barrier_polys',
    mapping = {
        'barrier': (
            'city_wall',
            'fence',
            'hedge',
            'retaining_wall',
            'wall',
            'bollard',
            'gate',
            'spikes',
            'lift_gate',
            'kissing_gate',
            'embankment',
            'yes',
            'wire_fence',
        ),
        'natural': (
            'cliff',
        ),
        'man_made': (
            'enbankment',
        )
    },
    fields = (
        ('length', Length()),
    )
)

barriers = UnionView(
    name = 'barriers',
    fields = (),
    mappings = [barrier_lines, barrier_polys],
)

roads_gen = GeneralizedTable(
    name = 'roads_gen',
    tolerance = meter_to_mapunit(50.0),
    origin = roads,
)

railways_gen = GeneralizedTable(
    name = 'railways_gen',
    tolerance = meter_to_mapunit(50.0),
    origin = railways,
)
